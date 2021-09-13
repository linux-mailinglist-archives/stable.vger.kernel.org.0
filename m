Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9B40928A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242631AbhIMOMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345158AbhIMOKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC260613DA;
        Mon, 13 Sep 2021 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540509;
        bh=l/Xpl2qhOTIDjKOxOrGc8J1pvnpinX1zH4ibSLKWbPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZjP73CsDfxo5qZQK1+flQntZTfDgkqXs4aBp4OwX8f4VN/4KBk/GWKoKLtSe+5FX
         B8zItvp/cLIjc3cdBjZXiHZHBcBfh+wwrXtfZjCkGQsfeziLK6CKdquHV/O7q4DFfi
         q02pKuK728vHPfs78J04KkBbnb9E5XQttnq79E98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 222/300] m68k: coldfire: return success for clk_enable(NULL)
Date:   Mon, 13 Sep 2021 15:14:43 +0200
Message-Id: <20210913131116.856268391@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f6a4f0b424df957d84fa7b9f2d02981234ff5828 ]

The clk_enable is supposed work when CONFIG_HAVE_CLK is false, but it
returns -EINVAL.  That means some drivers fail during probe.

[    1.680000] flexcan: probe of flexcan.0 failed with error -22

Fixes: c1fb1bf64bb6 ("m68k: let clk_enable() return immediately if clk is NULL")
Fixes: bea8bcb12da0 ("m68knommu: Add support for the Coldfire m5441x.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/coldfire/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/coldfire/clk.c b/arch/m68k/coldfire/clk.c
index 076a9caa9557..c895a189c5ae 100644
--- a/arch/m68k/coldfire/clk.c
+++ b/arch/m68k/coldfire/clk.c
@@ -92,7 +92,7 @@ int clk_enable(struct clk *clk)
 	unsigned long flags;
 
 	if (!clk)
-		return -EINVAL;
+		return 0;
 
 	spin_lock_irqsave(&clk_lock, flags);
 	if ((clk->enabled++ == 0) && clk->clk_ops)
-- 
2.30.2



