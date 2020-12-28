Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0BA2E3D32
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439914AbgL1OMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439910AbgL1OMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 556E52063A;
        Mon, 28 Dec 2020 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164743;
        bh=u81EBZxBV+ddhWB2v3XDMRlaNyq29QoFNxu9fFsZkf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6/VcQt4S7LGv/TK61nIdhKB0NQKh+JTX1IrsZhirVm14BV5SCOHLsJYyPU3CSV07
         kX0p/0Y9Sd+SNn9L23t/Zg5/aKwZIdy085c4yx7wI9HfreiWz+jW+CNYN+RH9R8nXD
         ncdRp050/ZmZz2Jh5Bh9GJ+IV4DbyrnNwv3Qmvvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/717] PCI: Fix overflow in command-line resource alignment requests
Date:   Mon, 28 Dec 2020 13:43:59 +0100
Message-Id: <20201228125032.535801761@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit cc73eb321d246776e5a9f7723d15708809aa3699 ]

The shift of 1 by align_order is evaluated using 32 bit arithmetic and the
result is assigned to a resource_size_t type variable that is a 64 bit
unsigned integer on 64 bit platforms. Fix an overflow before widening issue
by making the 1 a ULL.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: 32a9a682bef2 ("PCI: allow assignment of memory resources with a specified alignment")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b7a860e790979..6427cbd0a5be2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6216,7 +6216,7 @@ static resource_size_t pci_specified_resource_alignment(struct pci_dev *dev,
 		ret = pci_dev_str_match(dev, p, &p);
 		if (ret == 1) {
 			*resize = true;
-			align = 1 << align_order;
+			align = 1ULL << align_order;
 			break;
 		} else if (ret < 0) {
 			pr_err("PCI: Can't parse resource_alignment parameter: %s\n",
-- 
2.27.0



