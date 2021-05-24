Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9EE38EF3D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhEXP4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235095AbhEXPzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447DD61942;
        Mon, 24 May 2021 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870935;
        bh=tTbS9qsh48BgZ/xZUmWnHXd55ELDUM8yD8OjGeVeY4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KPFO3bSV+JVKZr1UoB00yy7O0rkefalk5RSs3++SH6ZIfcUcCyKVPSfqHom0ezGP
         HjQVHWGt03vL/t9RsBnUEVVpzO9c8NcxLFvFGC1q8EjTMrJqBK9QHm5UquBGCm41Qe
         gZsB9oDGw9SuulSwRZUE+mF/M4VyezzD+Hgyy+fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francois Gervais <fgervais@distech-controls.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 103/104] rtc: pcf85063: fallback to parent of_node
Date:   Mon, 24 May 2021 17:26:38 +0200
Message-Id: <20210524152336.267728819@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francois Gervais <fgervais@distech-controls.com>

commit 03531606ef4cda25b629f500d1ffb6173b805c05 upstream.

The rtc device node is always NULL.

Since v5.12-rc1-dontuse/3c9ea42802a1fbf7ef29660ff8c6e526c58114f6 this
will lead to a NULL pointer dereference.

To fix this use the parent node which is the i2c client node as set by
devm_rtc_allocate_device().

Using the i2c client node seems to be what other similar drivers do
e.g. rtc-pcf8563.c.

Signed-off-by: Francois Gervais <fgervais@distech-controls.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210310211026.27299-1-fgervais@distech-controls.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pcf85063.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -486,6 +486,7 @@ static struct clk *pcf85063_clkout_regis
 {
 	struct clk *clk;
 	struct clk_init_data init;
+	struct device_node *node = pcf85063->rtc->dev.parent->of_node;
 
 	init.name = "pcf85063-clkout";
 	init.ops = &pcf85063_clkout_ops;
@@ -495,15 +496,13 @@ static struct clk *pcf85063_clkout_regis
 	pcf85063->clkout_hw.init = &init;
 
 	/* optional override of the clockname */
-	of_property_read_string(pcf85063->rtc->dev.of_node,
-				"clock-output-names", &init.name);
+	of_property_read_string(node, "clock-output-names", &init.name);
 
 	/* register the clock */
 	clk = devm_clk_register(&pcf85063->rtc->dev, &pcf85063->clkout_hw);
 
 	if (!IS_ERR(clk))
-		of_clk_add_provider(pcf85063->rtc->dev.of_node,
-				    of_clk_src_simple_get, clk);
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 
 	return clk;
 }


