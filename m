Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997D82E63CD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405409AbgL1Pmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:42:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405007AbgL1Nqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:46:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEB3121D94;
        Mon, 28 Dec 2020 13:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163155;
        bh=jMK7j6O9afa4nADOyjHH4HWw62AI0i5eaUh8OBsokMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HMYthP3SieQq1Jz3ZUOEf63N5wCsPUdoeouAvM7hbChby+qePUtKpjzsmTO9a+4E
         665VB4y4Kc/SC+R2nrpL318fuHX55PTxNdxnhqCVIU3cg8TDr02CWx3UN0IoKP8AbQ
         Qkb4B9+14QABT+3xUFGEPGOCdTz3/L86V6Ggc5qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/453] PCI: Fix overflow in command-line resource alignment requests
Date:   Mon, 28 Dec 2020 13:47:05 +0100
Message-Id: <20201228124946.306003220@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 158a7aa2a8e6e..89dece8a41321 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6143,7 +6143,7 @@ static resource_size_t pci_specified_resource_alignment(struct pci_dev *dev,
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



