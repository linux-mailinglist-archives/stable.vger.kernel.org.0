Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD20333B7C7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhCOOBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhCON7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 013E564F27;
        Mon, 15 Mar 2021 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816753;
        bh=zK4at9k5Dm8F1q5zVGnHRvNLo57LWKGfx8uZ+FjbCQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQsZN2yTTmR6XAe71sa7KFHzz89bgkOFMPZelfx77Vea5o8GVejHtS1/oV4y+Bg4+
         wQkgiY2jMPUV0c7JVGWKmp0XHt5FPiO4w0MUSu2FFau+jpQ0rxISqnnCWC/6KOfLZz
         wiBD9bb7YQVf0rkjrnMSrwkQyKZ6C+dEIRNAcKpo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Bolshakov <r.bolshakov@yadro.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/168] scsi: target: core: Add cmd length set before cmd complete
Date:   Mon, 15 Mar 2021 14:55:18 +0100
Message-Id: <20210315135553.210000175@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Aleksandr Miloserdov <a.miloserdov@yadro.com>

[ Upstream commit 1c73e0c5e54d5f7d77f422a10b03ebe61eaed5ad ]

TCM doesn't properly handle underflow case for service actions. One way to
prevent it is to always complete command with
target_complete_cmd_with_length(), however it requires access to data_sg,
which is not always available.

This change introduces target_set_cmd_data_length() function which allows
to set command data length before completing it.

Link: https://lore.kernel.org/r/20210209072202.41154-2-a.miloserdov@yadro.com
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 15 +++++++++++----
 include/target/target_core_backend.h   |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b1f4be055f83..a16835c0bb1d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -873,11 +873,9 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
-void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
+void target_set_cmd_data_length(struct se_cmd *cmd, int length)
 {
-	if ((scsi_status == SAM_STAT_GOOD ||
-	     cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) &&
-	    length < cmd->data_length) {
+	if (length < cmd->data_length) {
 		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
 			cmd->residual_count += cmd->data_length - length;
 		} else {
@@ -887,6 +885,15 @@ void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int len
 
 		cmd->data_length = length;
 	}
+}
+EXPORT_SYMBOL(target_set_cmd_data_length);
+
+void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
+{
+	if (scsi_status == SAM_STAT_GOOD ||
+	    cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) {
+		target_set_cmd_data_length(cmd, length);
+	}
 
 	target_complete_cmd(cmd, scsi_status);
 }
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 51b6f50eabee..0deeff9b4496 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -69,6 +69,7 @@ int	transport_backend_register(const struct target_backend_ops *);
 void	target_backend_unregister(const struct target_backend_ops *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
+void	target_set_cmd_data_length(struct se_cmd *, int);
 void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 
 void	transport_copy_sense_to_cmd(struct se_cmd *, unsigned char *);
-- 
2.30.1



