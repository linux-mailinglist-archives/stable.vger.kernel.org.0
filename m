Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09243E81E1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbhHJSDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237084AbhHJSBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60B1613B3;
        Tue, 10 Aug 2021 17:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617628;
        bh=w/2rgKHASbWUjHG49uEgq7xo3wn+EV0axey8DCLWdmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwhcBgyyILFn5IoQSH1Yorj3cTmhFQELEU+Sax3Rb4CKEs5uZebQGD9GpKHMqbz4K
         FVxbX2IkW483D0INt19tNagsoUD0yQY7/GOBD55sAGT/R2JZd168StCC6ZBkA/0/Tj
         ZO+kQ4jWD0L8paFukICS3z1DH8n+UWQny1lryMc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.13 143/175] ARM: omap2+: hwmod: fix potential NULL pointer access
Date:   Tue, 10 Aug 2021 19:30:51 +0200
Message-Id: <20210810173005.661087923@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

commit b070f9ca78680486927b799cf6126b128a7c2c1b upstream.

omap_hwmod_get_pwrdm() may access a NULL clk_hw pointer in some failure
cases. Add a check for the case and bail out gracely if this happens.

Reported-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap2/omap_hwmod.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -3776,6 +3776,7 @@ struct powerdomain *omap_hwmod_get_pwrdm
 	struct omap_hwmod_ocp_if *oi;
 	struct clockdomain *clkdm;
 	struct clk_hw_omap *clk;
+	struct clk_hw *hw;
 
 	if (!oh)
 		return NULL;
@@ -3792,7 +3793,14 @@ struct powerdomain *omap_hwmod_get_pwrdm
 		c = oi->_clk;
 	}
 
-	clk = to_clk_hw_omap(__clk_get_hw(c));
+	hw = __clk_get_hw(c);
+	if (!hw)
+		return NULL;
+
+	clk = to_clk_hw_omap(hw);
+	if (!clk)
+		return NULL;
+
 	clkdm = clk->clkdm;
 	if (!clkdm)
 		return NULL;


