Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E52E65A7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393828AbgL1QDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389981AbgL1N2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B963B2084D;
        Mon, 28 Dec 2020 13:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162086;
        bh=UgTDsomvO5pVjVr2vbcUZrE11dadQ4DwqVuwRyB5cyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5WLPgKmJNxpZRb5V8RABzql9VUmOk+HSPMZ9PxuULlOd137KVACSYiBjXgcysuji
         eX05bBMUoO1EXNkfPy6P8Ig1G8QtVeP6N/+fQ6z0MSX48GdCfoQ45N4DJGM8k3iWOi
         u+4QhlFlBINVoahNm++yvZ0un2oHd2Skd0zpShuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 181/346] PCI: Fix overflow in command-line resource alignment requests
Date:   Mon, 28 Dec 2020 13:48:20 +0100
Message-Id: <20201228124928.538881592@linuxfoundation.org>
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
index 5103d4b140ee3..cd628dd73719b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5854,7 +5854,7 @@ static resource_size_t pci_specified_resource_alignment(struct pci_dev *dev,
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



