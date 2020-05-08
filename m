Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732AB1CAF52
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgEHMo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729192AbgEHMoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8BDD208D6;
        Fri,  8 May 2020 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941865;
        bh=iu9kPeQefUOz9tbxzl85LDuwE2UENP8ezYaTmda1qaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqAS4wrSVLrAyX9LgSSvR8VVrZbBeQk0WYpD0bT/mFO6VBdpjF+YAu03OVMGFfzk4
         hAT3cF4r5nRL5QRFkUe1e1k6wBXLhxwqpWNp7lnqv6XxvjSUgZQWROAzSFaryM9EZr
         uV7wSu7kmM7oOVnDYQbpZmo6ckISb47BHrOL94Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 4.4 204/312] clk: ti: omap3+: dpll: use non-locking version of clk_get_rate
Date:   Fri,  8 May 2020 14:33:15 +0200
Message-Id: <20200508123138.772609902@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

commit a0d54c3899aaeb047969d9479263c6bcf385c331 upstream.

As the code in this file is being executed within irq context in some
cases, we must avoid the clk_get_rate which uses mutex internally.
Switch the code to use clk_hw_get_rate instead which is non-locking.

This fixes an issue where PM runtime will hang the system if enabled
with a serial console before a suspend-resume cycle.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Fixes: a53ad8ef3dcc ("clk: ti: Convert to clk_hw based provider APIs")
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ti/dpll3xxx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/ti/dpll3xxx.c
+++ b/drivers/clk/ti/dpll3xxx.c
@@ -437,7 +437,8 @@ int omap3_noncore_dpll_enable(struct clk
 
 	parent = clk_hw_get_parent(hw);
 
-	if (clk_hw_get_rate(hw) == clk_get_rate(dd->clk_bypass)) {
+	if (clk_hw_get_rate(hw) ==
+	    clk_hw_get_rate(__clk_get_hw(dd->clk_bypass))) {
 		WARN_ON(parent != __clk_get_hw(dd->clk_bypass));
 		r = _omap3_noncore_dpll_bypass(clk);
 	} else {


