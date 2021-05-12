Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A4037C902
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhELQOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235828AbhELQBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7467F613C2;
        Wed, 12 May 2021 15:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833580;
        bh=EuN0jmkZAT174ZxhbQczPDZMg+vgNKSeYtDiRKZhCno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BejPvu0cdvnIb28TBZqvmVt4tsY4TNxexmQ4Ih+dEW7eR232b6TOv+3TjmrdiHufQ
         QgI3AfGmFZQdi/rEPK9BwqFkaGxi8WPpuNjFVLlRNy7rVkJX/u+q2CcoahKjxBKeD2
         5/TV9zL4m4l8eEiZttb+xyiwkzxxW5QoscVl3paI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 206/601] usb: gadget: s3c: Fix incorrect resources releasing
Date:   Wed, 12 May 2021 16:44:43 +0200
Message-Id: <20210512144834.628421200@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 42067ccd9eb2077979ac3ce8b7b95c694bd09e14 ]

Since commit 188db4435ac6 ("usb: gadget: s3c: use platform resources"),
'request_mem_region()' and 'ioremap()' are no more used, so they don't need
to be undone in the error handling path of the probe and in the remove
function.

Remove these calls and the unneeded 'rsrc_start' and 'rsrc_len' global
variables.

Fixes: 188db4435ac6 ("usb: gadget: s3c: use platform resources")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/b317638464f188159bd8eea44427dd359e480625.1616830026.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/s3c2410_udc.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/udc/s3c2410_udc.c b/drivers/usb/gadget/udc/s3c2410_udc.c
index 1d3ebb07ccd4..b81979b3bdb6 100644
--- a/drivers/usb/gadget/udc/s3c2410_udc.c
+++ b/drivers/usb/gadget/udc/s3c2410_udc.c
@@ -54,8 +54,6 @@ static struct clk		*udc_clock;
 static struct clk		*usb_bus_clock;
 static void __iomem		*base_addr;
 static int			irq_usbd;
-static u64			rsrc_start;
-static u64			rsrc_len;
 static struct dentry		*s3c2410_udc_debugfs_root;
 
 static inline u32 udc_read(u32 reg)
@@ -1775,7 +1773,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 	base_addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base_addr)) {
 		retval = PTR_ERR(base_addr);
-		goto err_mem;
+		goto err;
 	}
 
 	the_controller = udc;
@@ -1793,7 +1791,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 	if (retval != 0) {
 		dev_err(dev, "cannot get irq %i, err %d\n", irq_usbd, retval);
 		retval = -EBUSY;
-		goto err_map;
+		goto err;
 	}
 
 	dev_dbg(dev, "got irq %i\n", irq_usbd);
@@ -1864,10 +1862,7 @@ err_gpio_claim:
 		gpio_free(udc_info->vbus_pin);
 err_int:
 	free_irq(irq_usbd, udc);
-err_map:
-	iounmap(base_addr);
-err_mem:
-	release_mem_region(rsrc_start, rsrc_len);
+err:
 
 	return retval;
 }
@@ -1899,9 +1894,6 @@ static int s3c2410_udc_remove(struct platform_device *pdev)
 
 	free_irq(irq_usbd, udc);
 
-	iounmap(base_addr);
-	release_mem_region(rsrc_start, rsrc_len);
-
 	if (!IS_ERR(udc_clock) && udc_clock != NULL) {
 		clk_disable_unprepare(udc_clock);
 		clk_put(udc_clock);
-- 
2.30.2



