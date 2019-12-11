Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D7511B346
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbfLKPlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387890AbfLKPfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E04F2173E;
        Wed, 11 Dec 2019 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078512;
        bh=Qg9zV/+M2zmODgLZIIMHmF0ZnnWlnBh71Hg7gizc5U0=;
        h=From:To:Cc:Subject:Date:From;
        b=O4b4ZjcnOZZUPSd0073TJyIr8owKi5SRdnv0IjO+5+SrkXO9u8yJIuEuwA43lPKi3
         kcS9L7X3f40y8WrTA+7BZ040cYY5IYBG9QpAr+dJg5ODzxkSSLf6JkXp1M2Lfm1mC4
         IvNEbI6/qmZ1ey+MniKBrwfinA7e306fOo0rOxjk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/42] scsi: mpt3sas: Fix clear pending bit in ioctl status
Date:   Wed, 11 Dec 2019 10:34:29 -0500
Message-Id: <20191211153510.23861-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 782b281883caf70289ba6a186af29441a117d23e ]

When user issues diag register command from application with required size,
and if driver unable to allocate the memory, then it will fail the register
command. While failing the register command, driver is not currently
clearing MPT3_CMD_PENDING bit in ctl_cmds.status variable which was set
before trying to allocate the memory. As this bit is set, subsequent
register command will be failed with BUSY status even when user wants to
register the trace buffer will less memory.

Clear MPT3_CMD_PENDING bit in ctl_cmds.status before returning the diag
register command with no memory status.

Link: https://lore.kernel.org/r/1568379890-18347-4-git-send-email-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 26cdc127ac89c..90a87e59ff602 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1465,7 +1465,8 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 			    " for diag buffers, requested size(%d)\n",
 			    ioc->name, __func__, request_data_sz);
 			mpt3sas_base_free_smid(ioc, smid);
-			return -ENOMEM;
+			rc = -ENOMEM;
+			goto out;
 		}
 		ioc->diag_buffer[buffer_type] = request_data;
 		ioc->diag_buffer_sz[buffer_type] = request_data_sz;
-- 
2.20.1

