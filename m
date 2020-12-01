Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5162C9CC6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbgLAJAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388388AbgLAJAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:00:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAA6B21D46;
        Tue,  1 Dec 2020 09:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813228;
        bh=xRhEKCxH1itKE1wlM/YR80gfrAOlSyTV8ixtllnBiPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4Zjss3x65dWQbvSOygEcEm8fudd1SCm7DXMISqOlW1EFCpO1uXan80wjBoLyP0Rs
         WVXd2Af8KxyxnmMeXnX9MRKOucJXqaqacbbpdd3iJT8oCNAWOu0DbgQSBEOl/lwFwd
         AAPqUJl2cMyHBLw79veEs3NxjllyfIFE7cwtYtWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/57] scsi: target: iscsi: Fix cmd abort fabric stop race
Date:   Tue,  1 Dec 2020 09:53:30 +0100
Message-Id: <20201201084650.410035711@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit f36199355c64a39fe82cfddc7623d827c7e050da ]

Maurizio found a race where the abort and cmd stop paths can race as
follows:

 1. thread1 runs iscsit_release_commands_from_conn and sets
    CMD_T_FABRIC_STOP.

 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It
    then returns from the aborted_task callout and we finish
    target_handle_abort and do:

    target_handle_abort -> transport_cmd_check_stop_to_fabric ->
	lio_check_stop_free -> target_put_sess_cmd

    The cmd is now freed.

 3. thread1 now finishes iscsit_release_commands_from_conn and runs
    iscsit_free_cmd while accessing a command we just released.

In __target_check_io_state we check for CMD_T_FABRIC_STOP and set the
CMD_T_ABORTED if the driver is not cleaning up the cmd because of a session
shutdown. However, iscsit_release_commands_from_conn only sets the
CMD_T_FABRIC_STOP and does not check to see if the abort path has claimed
completion ownership of the command.

This adds a check in iscsit_release_commands_from_conn so only the abort or
fabric stop path cleanup the command.

Link: https://lore.kernel.org/r/1605318378-9269-1-git-send-email-michael.christie@oracle.com
Reported-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2602b57936d4b..58ccded1be857 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -492,8 +492,7 @@ EXPORT_SYMBOL(iscsit_queue_rsp);
 void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	spin_lock_bh(&conn->cmd_lock);
-	if (!list_empty(&cmd->i_conn_node) &&
-	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
+	if (!list_empty(&cmd->i_conn_node))
 		list_del_init(&cmd->i_conn_node);
 	spin_unlock_bh(&conn->cmd_lock);
 
@@ -4054,12 +4053,22 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 	spin_lock_bh(&conn->cmd_lock);
 	list_splice_init(&conn->conn_cmd_list, &tmp_list);
 
-	list_for_each_entry(cmd, &tmp_list, i_conn_node) {
+	list_for_each_entry_safe(cmd, cmd_tmp, &tmp_list, i_conn_node) {
 		struct se_cmd *se_cmd = &cmd->se_cmd;
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
-			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
+			if (se_cmd->transport_state & CMD_T_ABORTED) {
+				/*
+				 * LIO's abort path owns the cleanup for this,
+				 * so put it back on the list and let
+				 * aborted_task handle it.
+				 */
+				list_move_tail(&cmd->i_conn_node,
+					       &conn->conn_cmd_list);
+			} else {
+				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
+			}
 			spin_unlock_irq(&se_cmd->t_state_lock);
 		}
 	}
-- 
2.27.0



