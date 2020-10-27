Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AD529AE6E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753570AbgJ0OAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752386AbgJ0N7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:59:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D61218AC;
        Tue, 27 Oct 2020 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807182;
        bh=awAwHl2l1lqoAKnhM1zlJmktAQRGZGMRhrpWOz2/8bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyMtCPMOzFKOGqg5EZWr5EbVUuuGUCmf2eN0jLub7ZsycYP2Una0rZQO/TOiPAuTU
         GW9NMrhvCHz4ydeu/Cr6cRxKrT4RXpHDJ95bDrVTP2qFV10pTrThfn8vJeNO8jZQrf
         bOrikwLdUoMrmjyXjJPRTxGeZlTSqVFEbbEIPyFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Roger Quadros <rogerq@ti.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 073/112] memory: omap-gpmc: Fix a couple off by ones
Date:   Tue, 27 Oct 2020 14:49:43 +0100
Message-Id: <20201027134904.005456129@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4c54228ac8fd55044195825873c50a524131fa53 ]

These comparisons should be >= instead of > to prevent reading one
element beyond the end of the gpmc_cs[] array.

Fixes: cdd6928c589a ("ARM: OMAP2+: Add device-tree support for NOR flash")
Fixes: f37e4580c409 ("ARM: OMAP2: Dynamic allocator for GPMC memory space")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Roger Quadros <rogerq@ti.com>
Link: https://lore.kernel.org/r/20200825104707.GB278587@mwanda
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/omap-gpmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
index 49691a8c74ee9..af187c91fc33b 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -928,7 +928,7 @@ static int gpmc_cs_remap(int cs, u32 base)
 	int ret;
 	u32 old_base, size;
 
-	if (cs > gpmc_cs_num) {
+	if (cs >= gpmc_cs_num) {
 		pr_err("%s: requested chip-select is disabled\n", __func__);
 		return -ENODEV;
 	}
@@ -963,7 +963,7 @@ int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
 	struct resource *res = &gpmc->mem;
 	int r = -1;
 
-	if (cs > gpmc_cs_num) {
+	if (cs >= gpmc_cs_num) {
 		pr_err("%s: requested chip-select is disabled\n", __func__);
 		return -ENODEV;
 	}
-- 
2.25.1



