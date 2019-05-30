Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626B22F50C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfE3EoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbfE3DMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:06 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09C5024527;
        Thu, 30 May 2019 03:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185926;
        bh=Lt4gn8Zax1A1k0bW3kZVZAUEGQyIjyfrREkDlcuqJEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpAW13m2mzPDIjKObYwDThABF2s6LFTIRVS+5GcKA4Kn/RZrSmd1CJBrAW54n18F8
         EAxvioYsvmWvRsN4n136p7USpNTvhiGupaBh/8HFgC2pcLTDJkURfUCHZv++P7GjCL
         kHOjRwaSuF8CW3JnwYXbkzvBNxzx+Vsy5DYuUQXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 316/405] scsi: lpfc: avoid uninitialized variable warning
Date:   Wed, 29 May 2019 20:05:14 -0700
Message-Id: <20190530030556.767435137@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit faf5a744f4f8d76e7c03912b5cd381ac8045f6ec ]

clang -Wuninitialized incorrectly sees a variable being used without
initialization:

drivers/scsi/lpfc/lpfc_nvme.c:2102:37: error: variable 'localport' is uninitialized when used here
      [-Werror,-Wuninitialized]
                lport = (struct lpfc_nvme_lport *)localport->private;
                                                  ^~~~~~~~~
drivers/scsi/lpfc/lpfc_nvme.c:2059:38: note: initialize the variable 'localport' to silence this warning
        struct nvme_fc_local_port *localport;
                                            ^
                                             = NULL
1 error generated.

This is clearly in dead code, as the condition leading up to it is always
false when CONFIG_NVME_FC is disabled, and the variable is always
initialized when nvme_fc_register_localport() got called successfully.

Change the preprocessor conditional to the equivalent C construct, which
makes the code more readable and gets rid of the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 1aa00d2c3f74e..9defff7118846 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2080,15 +2080,15 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 		lpfc_nvme_template.max_hw_queues =
 			phba->sli4_hba.num_present_cpu;
 
+	if (!IS_ENABLED(CONFIG_NVME_FC))
+		return ret;
+
 	/* localport is allocated from the stack, but the registration
 	 * call allocates heap memory as well as the private area.
 	 */
-#if (IS_ENABLED(CONFIG_NVME_FC))
+
 	ret = nvme_fc_register_localport(&nfcp_info, &lpfc_nvme_template,
 					 &vport->phba->pcidev->dev, &localport);
-#else
-	ret = -ENOMEM;
-#endif
 	if (!ret) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME | LOG_NVME_DISC,
 				 "6005 Successfully registered local "
-- 
2.20.1



