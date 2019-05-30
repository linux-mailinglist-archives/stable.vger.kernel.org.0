Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1CC2F23D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfE3EUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbfE3DPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF07D245AF;
        Thu, 30 May 2019 03:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186121;
        bh=Z9anbQd/siXILZd3R/mi5TSR9HtA3TXq3b/rWwdRsLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hq/nouIdCVXFXrQQxxqQRs2DjvaL1HKaw/bY7SIKmPUtXKGPKr1STibnDQH+1AOvo
         PgFdu/Q3MKH35qj1eRQ0bZ4TnVpYZO6TErRJ95EP+IXj3xDQOkKIo/Wl4Q2GHuLJSv
         YDwo/14AhCfAQmQOUlXec4nq7NVkT7u0LXMXa1Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 278/346] scsi: lpfc: avoid uninitialized variable warning
Date:   Wed, 29 May 2019 20:05:51 -0700
Message-Id: <20190530030555.013326270@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index 8c9f790422288..56df8b510186b 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2471,15 +2471,15 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
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



