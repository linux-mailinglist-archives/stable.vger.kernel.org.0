Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5606E6732
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbfJ0VSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731336AbfJ0VSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:51 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B8921848;
        Sun, 27 Oct 2019 21:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211128;
        bh=WTkKy8s4ac7duYl64OPSqQAgvDeJDiVxDqId02GUUs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGtdA1w2zUleEk7jMjxFH51717AQu6/pJoayI2Fnw+Qh+Th7wFhMPPVelOA8tDSRG
         fe7xPALIB1p+TZoQsKtHCvUhE3LU5Drh6VBMLcNt79vQ0cnYANumx7p/tqE6qdaOcm
         SJ+C5a64E0pL+cF0/g+I/6iIWiQ1sPcHxS4BJqkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 007/197] scsi: megaraid: disable device when probe failed after enabled device
Date:   Sun, 27 Oct 2019 21:58:45 +0100
Message-Id: <20191027203352.083484397@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 70054aa39a013fa52eff432f2223b8bd5c0048f8 ]

For pci device, need to disable device when probe failed after enabled
device.

Link: https://lore.kernel.org/r/1567818450-173315-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 45a66048801be..ff6d4aa924213 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4183,11 +4183,11 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		 */
 		if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ &&
 		    pdev->subsystem_device == 0xC000)
-		   	return -ENODEV;
+			goto out_disable_device;
 		/* Now check the magic signature byte */
 		pci_read_config_word(pdev, PCI_CONF_AMISIG, &magic);
 		if (magic != HBA_SIGNATURE_471 && magic != HBA_SIGNATURE)
-			return -ENODEV;
+			goto out_disable_device;
 		/* Ok it is probably a megaraid */
 	}
 
-- 
2.20.1



