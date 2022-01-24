Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1C2499724
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446901AbiAXVJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354150AbiAXVFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24C4C0613E8;
        Mon, 24 Jan 2022 12:06:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8995BB81239;
        Mon, 24 Jan 2022 20:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8359C340E5;
        Mon, 24 Jan 2022 20:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054792;
        bh=x7S04SykEtkNO6jyz+/ia/IfgXn8OU6ejHj5ebXM5TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZ8TaNah0+GuvgPL1GlUqk5C9gX7fgzpE6xpIA72LTdw++QXCuhh4U4OHKuBEOpGk
         iWqTPmThS44eRAIzZ2/AOt+WIMT95DThubrZaqCh0mM4aaGUUlIWYMDE2BQgL8fe9b
         ZRhLo4HcCP/ESDY/+1QVoHNH79vS8UfrzCiu/ktQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 497/563] dmaengine: uniphier-xdmac: Fix type of address variables
Date:   Mon, 24 Jan 2022 19:44:22 +0100
Message-Id: <20220124184041.634891897@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit 105a8c525675bb7d4d64871f9b2edf39460de881 upstream.

The variables src_addr and dst_addr handle DMA addresses, so these should
be declared as dma_addr_t.

Fixes: 667b9251440b ("dmaengine: uniphier-xdmac: Add UniPhier external DMA controller driver")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/1639456963-10232-1-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/uniphier-xdmac.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dma/uniphier-xdmac.c
+++ b/drivers/dma/uniphier-xdmac.c
@@ -131,8 +131,9 @@ uniphier_xdmac_next_desc(struct uniphier
 static void uniphier_xdmac_chan_start(struct uniphier_xdmac_chan *xc,
 				      struct uniphier_xdmac_desc *xd)
 {
-	u32 src_mode, src_addr, src_width;
-	u32 dst_mode, dst_addr, dst_width;
+	u32 src_mode, src_width;
+	u32 dst_mode, dst_width;
+	dma_addr_t src_addr, dst_addr;
 	u32 val, its, tnum;
 	enum dma_slave_buswidth buswidth;
 


