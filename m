Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF5B32AFE6
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhCCA3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245031AbhCBMjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:39:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B23264F3F;
        Tue,  2 Mar 2021 11:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686204;
        bh=I2lv/9SStLTy4zZSlYc2iaKDToCb6xpMaXnbTiFrzOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APLav2dFBXO6rVWLcEOuUPs7amk7RtPnxVioKLF1G11847ybW56bieueZcaWZQ4JJ
         KMYCK3dzzBX3+BQ+aIXJoeAjFuebtv6DKqXmD21zOA8hYT4ii7uj/Dppxq7fDuO+p/
         t/CP1oTElIUXpZRmCvJUCXDSFF/o63FZ2EqPbF8MhRNPlbVW5rPdkyY7IE/IhPCrgx
         ROk2tB64pjsSs26mqK4utv3t7LDLkJUacFPXtnRc1McpmSqZAzV49dr0lHSUDQhIbm
         PQZukOn+zyNwQftE63F7Gu2OmTbnzzbqbRULQA3vXAvCYsMcm2vTSuMspdSeluMO3b
         IK7BeRki1P3qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksandr Miloserdov <a.miloserdov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 5.11 51/52] scsi: target: core: Add cmd length set before cmd complete
Date:   Tue,  2 Mar 2021 06:55:32 -0500
Message-Id: <20210302115534.61800-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index fca4bd079d02..8a4d58fdc9fe 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -879,11 +879,9 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
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
@@ -893,6 +891,15 @@ void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int len
 
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
index 6336780d83a7..ce2fba49c95d 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -72,6 +72,7 @@ int	transport_backend_register(const struct target_backend_ops *);
 void	target_backend_unregister(const struct target_backend_ops *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
+void	target_set_cmd_data_length(struct se_cmd *, int);
 void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 
 void	transport_copy_sense_to_cmd(struct se_cmd *, unsigned char *);
-- 
2.30.1

