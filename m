Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D0E2F03B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbfE3DSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731405AbfE3DSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:04 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B72C12475D;
        Thu, 30 May 2019 03:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186283;
        bh=uJWCgcHIYbc4SdYfmmV2gAJQm/i9pZikepTpAYBVqCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4grOyIOBOiRJo7Pc80MdvusLFa1d93T2atjV+are6CAAHfd7dV+3MZSlKIi1O+Ca
         0zZYJc6Y91jhhkcDGpMxoqaTFbWlZf3dsfyt2FxM2lF4It9RdweUumYBFpxjfDGWMJ
         aJq2ny3V76f9ejoGUavxo14hKM0VvVj8voplxcG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 237/276] scsi: lpfc: avoid uninitialized variable warning
Date:   Wed, 29 May 2019 20:06:35 -0700
Message-Id: <20190530030539.944220603@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
index ca62117a2d131..099f70798fdda 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2482,15 +2482,15 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 	if (!cstat)
 		return -ENOMEM;
 
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



