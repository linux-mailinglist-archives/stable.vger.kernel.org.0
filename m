Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF7B8754
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391130AbfISWHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393166AbfISWHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:07:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CDAA21907;
        Thu, 19 Sep 2019 22:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930833;
        bh=06RDI3iiz+zPYLR3POWTBK2jvFv/vij3bYGO0YNwkuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EakkPiuudJwLKN12OGnivZoVAI4QoCM1ISfvQCHJy/9IHXG5oKnHuWXfbQ/WyXpLP
         CBmYjr5UaUAggHa5kRNWWtgB2z9IDQDGgel9hrD6Zsz7xLgNPSWXTl9ktWJeTmB6u6
         rU/V7QdRBO9GVjeo78mZzm2ckwQiSwJLMuvkDhEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Keerthy <j-keerthy@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 030/124] ARM: OMAP2+: Fix missing SYSC_HAS_RESET_STATUS for dra7 epwmss
Date:   Fri, 20 Sep 2019 00:01:58 +0200
Message-Id: <20190919214820.130762933@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit afd58b162e48076e3fe66d08a69eefbd6fe71643 ]

TRM says PWMSS_SYSCONFIG bit for SOFTRESET changes to zero when
reset is completed. Let's configure it as otherwise we get warnings
on boot when we check the data against dts provided data. Eventually
the legacy platform data will be just dropped, but let's fix the
warning first.

Reviewed-by: Suman Anna <s-anna@ti.com>
Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 4a5b4aee6615a..1ec21e9ba1e99 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -379,7 +379,8 @@ static struct omap_hwmod dra7xx_dcan2_hwmod = {
 static struct omap_hwmod_class_sysconfig dra7xx_epwmss_sysc = {
 	.rev_offs	= 0x0,
 	.sysc_offs	= 0x4,
-	.sysc_flags	= SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET,
+	.sysc_flags	= SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
+			  SYSC_HAS_RESET_STATUS,
 	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
 	.sysc_fields	= &omap_hwmod_sysc_type2,
 };
-- 
2.20.1



