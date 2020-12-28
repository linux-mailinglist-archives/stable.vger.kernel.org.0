Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1610E2E3B22
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405013AbgL1Nqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405016AbgL1NqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:46:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D90C5208BA;
        Mon, 28 Dec 2020 13:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163149;
        bh=4HGJGRqVwBUVXqqlVS5LfyPC/hJ/b7vlDDk97G3RzK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVKjLGjg5uKPt1+vHfPHOmQ/kccpmR4pp2aRo7x9kxoLHBnpPVunklv3a5M8LDOh7
         /qc2Mkhqb87aD4j70mpv2GEi9TH/D+K30vV5BvjkgApGMH30IQfsydqmyemavD3OTQ
         Ia4Bs+nOWQTqv/LaP//Dz8i0x1n010pTWTGBtGgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/453] PCI: Bounds-check command-line resource alignment requests
Date:   Mon, 28 Dec 2020 13:47:04 +0100
Message-Id: <20201228124946.257457484@linuxfoundation.org>
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
index b1b2c8ddbc927..158a7aa2a8e6e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6129,19 +6129,21 @@ static resource_size_t pci_specified_resource_alignment(struct pci_dev *dev,
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



