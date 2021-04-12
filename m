Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3523E35BFD3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbhDLJG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240232AbhDLJFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16A636134F;
        Mon, 12 Apr 2021 09:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218143;
        bh=QDDQMYiPxG+aUyQiCG50hJTNC7dLtm+Oh9GbfPEIuho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClZvhj+lj2e+9rx4cPkaG4EoMkY0EgeFD2NWfLLAJN7FzBXL6/hXMGFD+0NwgKN9J
         6PMztHvWM0duJqNM6p9H60GYkWQUJAE1XPdiNqqnELCkdrIxnsBaStABaGqLgaY2UU
         UxE7XD/AUNecauq8A9L6CcMGdlmGb3UItBUsigu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.11 086/210] scsi: target: iscsi: Fix zero tag inside a trace event
Date:   Mon, 12 Apr 2021 10:39:51 +0200
Message-Id: <20210412084018.883437586@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

commit 0352c3d3959a6cf543075b88c7e662fd3546f12e upstream.

target_sequencer_start event is triggered inside target_cmd_init_cdb().
se_cmd.tag is not initialized with ITT at the moment so the event always
prints zero tag.

Link: https://lore.kernel.org/r/20210403215415.95077-1-r.bolshakov@yadro.com
Cc: stable@vger.kernel.org # 5.10+
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/iscsi/iscsi_target.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1166,6 +1166,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_c
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
+	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
 	if (cmd->sense_reason) {
 		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
@@ -1180,8 +1181,6 @@ int iscsit_setup_scsi_cmd(struct iscsi_c
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
-	/* only used for printks or comparing with ->ref_task_tag */
-	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_cmd_parse_cdb(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;


