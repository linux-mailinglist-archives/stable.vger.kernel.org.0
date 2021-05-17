Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C776383334
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241298AbhEQO4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238603AbhEQOxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0B446198E;
        Mon, 17 May 2021 14:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261443;
        bh=KL1Fhf4Z+trvpS3bikucTfq08Btw5xHT9eFlDcIK0BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/fAtw14Fyyof06Y7J0tpNWJO31jLwLVuLjHWT2Yzl9xM5em6DREQAPU8U7A+CXC7
         vXzWxCocfHvm/xHZANCImWozI2OBwnyMMd7Y66Utu3F0SaHL+6DUDB72x73IFLY+Du
         U4VhbJ44t0iPq//NCqHUD21dVlqgNQ9YDMPZjXlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sean V Kelley <sean.v.kelley@intel.com>,
        Sasha Levin <sashal@kernel.org>, Wen Jin <wen.jin@intel.com>
Subject: [PATCH 5.11 114/329] PCI/RCEC: Fix RCiEP device to RCEC association
Date:   Mon, 17 May 2021 16:00:25 +0200
Message-Id: <20210517140305.966431743@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit d9b7eae8e3424c3480fe9f40ebafbb0c96426e4c ]

rcec_assoc_rciep() used "rciep->devfn" (a single byte encoding both the
device and function number) as the device number to check whether the
corresponding bit was set in the RCEC's Association Bitmap for RCiEPs.

But per PCIe r5.0, sec 7.9.10.2, "Association Bitmap for RCiEPs", the
32-bit bitmap contains one bit per device.  That bit applies to all
functions of the device.

Fix rcec_assoc_rciep() to convert the value of "rciep->devfn" to a device
number to ensure that RCiEP devices are correctly associated with the RCEC.

Reported-and-tested-by: Wen Jin <wen.jin@intel.com>
Fixes: 507b460f8144 ("PCI/ERR: Add pcie_link_rcec() to associate RCiEPs")
Link: https://lore.kernel.org/r/20210222011717.43266-1-qiuxu.zhuo@intel.com
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sean V Kelley <sean.v.kelley@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/rcec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/rcec.c b/drivers/pci/pcie/rcec.c
index 2c5c552994e4..d0bcd141ac9c 100644
--- a/drivers/pci/pcie/rcec.c
+++ b/drivers/pci/pcie/rcec.c
@@ -32,7 +32,7 @@ static bool rcec_assoc_rciep(struct pci_dev *rcec, struct pci_dev *rciep)
 
 	/* Same bus, so check bitmap */
 	for_each_set_bit(devn, &bitmap, 32)
-		if (devn == rciep->devfn)
+		if (devn == PCI_SLOT(rciep->devfn))
 			return true;
 
 	return false;
-- 
2.30.2



