Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B681CAB85
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgEHMoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbgEHMoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A0E2145D;
        Fri,  8 May 2020 12:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941862;
        bh=phtwg+X3ydaYdZ8gGv29nuOkeod1D7dHea3Rggyq380=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wilx+sCuaR38rTXQJXAg6I0u3BpBGYf+lL6nXf+mtikTJM0AOi/Vbn76L0oLD1IDI
         /Usp8nxxKd49BoBYMipIXmFNOnl+Gt+aF0VFoRSe1neLCs5160cdHzCVmAFi0y+4aL
         PPmElxaOiZbiTzx/0lI7TpYDBqX24oUAQdwtnsGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <computersforpeace@gmail.com>,
        Jyri Sarha <jsarha@ti.com>, Sergej Sawazki <ce3a@gmx.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@baylibre.com>
Subject: [PATCH 4.4 203/312] clk: gpio: handle error codes for of_clk_get_parent_count()
Date:   Fri,  8 May 2020 14:33:14 +0200
Message-Id: <20200508123138.705657793@linuxfoundation.org>
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

From: Brian Norris <computersforpeace@gmail.com>

commit 0b2e78865d92e2d70542cb1d4d7af1d4ea0a286d upstream.

We might make bad memory allocations if we get (e.g.) -ENOSYS from
of_clk_get_parent_count().

Noticed by Coverity.

Fixes: f66541ba02d5 ("clk: gpio: Get parent clk names in of_gpio_clk_setup()")
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Sergej Sawazki <ce3a@gmx.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Michael Turquette <mturquette@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-gpio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/clk/clk-gpio.c
+++ b/drivers/clk/clk-gpio.c
@@ -287,12 +287,14 @@ static void __init of_gpio_clk_setup(str
 	const char **parent_names;
 	int i, num_parents;
 
+	num_parents = of_clk_get_parent_count(node);
+	if (num_parents < 0)
+		return;
+
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return;
 
-	num_parents = of_clk_get_parent_count(node);
-
 	parent_names = kcalloc(num_parents, sizeof(char *), GFP_KERNEL);
 	if (!parent_names)
 		return;


