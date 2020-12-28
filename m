Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674F52E6596
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389970AbgL1N2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389965AbgL1N2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F19B207FF;
        Mon, 28 Dec 2020 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162080;
        bh=R2JNKXKJLp+/RplIksuI/Oz7ovJqYk/Hgm0atTwAcFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHmYmlqb7zOtITkVS+NDwJiPhSGhhKCnPxmqzs1Bfh0zaGneyw3afNzytQEOAWebF
         v7tWm6H7UaaN9M94q/zCrlM34CkpdBHLXzFB8/xeE07fGSClY+nTn7bZtbOQXR6Jc8
         e+VRuI/32563+5RIk39LYhmx/0HtNgOfleney9es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/346] PCI: Bounds-check command-line resource alignment requests
Date:   Mon, 28 Dec 2020 13:48:19 +0100
Message-Id: <20201228124928.490779191@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 6534aac198b58309ff2337981d3f893e0be1d19d ]

32-bit BARs are limited to 2GB size (2^31).  By extension, I assume 64-bit
BARs are limited to 2^63 bytes.  Limit the alignment requested by the
"pci=resource_alignment=" command-line parameter to 2^63.

Link: https://lore.kernel.org/r/20201007123045.GS4282@kadam
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 57a87a001b4f4..5103d4b140ee3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5840,19 +5840,21 @@ static resource_size_t pci_specified_resource_alignment(struct pci_dev *dev,
 	while (*p) {
 		count = 0;
 		if (sscanf(p, "%d%n", &align_order, &count) == 1 &&
-							p[count] == '@') {
+		    p[count] == '@') {
 			p += count + 1;
+			if (align_order > 63) {
+				pr_err("PCI: Invalid requested alignment (order %d)\n",
+				       align_order);
+				align_order = PAGE_SHIFT;
+			}
 		} else {
-			align_order = -1;
+			align_order = PAGE_SHIFT;
 		}
 
 		ret = pci_dev_str_match(dev, p, &p);
 		if (ret == 1) {
 			*resize = true;
-			if (align_order == -1)
-				align = PAGE_SIZE;
-			else
-				align = 1 << align_order;
+			align = 1 << align_order;
 			break;
 		} else if (ret < 0) {
 			pr_err("PCI: Can't parse resource_alignment parameter: %s\n",
-- 
2.27.0



