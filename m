Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E372337C701
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhELP5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233687AbhELPwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10504610A7;
        Wed, 12 May 2021 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833198;
        bh=mcFo/pMqkFJDcYTnmH9D1hzBs2yGoissAQjkyqQ9gr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tRiyNblLJEB2KOc0BfOPFUoMmMZKZZFZphev4L1zdMo45plkTCUMrjCwFshA/E5X
         ic2RDQo0qobNKO5eDtjtn0BEbLDFqwqudIzzYP0fGpm7PhCpe1M5T3CBCBrRjxob41
         gCGY3BP4c/uodThGCHW4lnFoCa+6qf7QboV3Pq8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dann.frazier@canonical.com,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.11 030/601] PCI: xgene: Fix cfg resource mapping
Date:   Wed, 12 May 2021 16:41:47 +0200
Message-Id: <20210512144828.813081534@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

commit d4707d79fae08c8996a1ba45965a491045a22dda upstream.

In commit e2dcd20b1645 a change was made to use
devm_platform_ioremap_resource_byname() to simplify code and remove
the res variable; this was wrong since the res variable is still needed
and as an outcome the port->cfg_addr gets an erroneous address.

Revert the change going back to original behaviour.

Link: https://lore.kernel.org/r/20210328144118.305074-1-zhengdejin5@gmail.com
Fixes: e2dcd20b1645a ("PCI: controller: Convert to devm_platform_ioremap_resource_byname()")
Reported-by: dann.frazier@canonical.com
Tested-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org    # v5.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-xgene.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -353,7 +353,8 @@ static int xgene_pcie_map_reg(struct xge
 	if (IS_ERR(port->csr_base))
 		return PTR_ERR(port->csr_base);
 
-	port->cfg_base = devm_platform_ioremap_resource_byname(pdev, "cfg");
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cfg");
+	port->cfg_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(port->cfg_base))
 		return PTR_ERR(port->cfg_base);
 	port->cfg_addr = res->start;


