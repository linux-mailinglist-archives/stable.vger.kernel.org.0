Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1F72E3FDB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506435AbgL1OpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506426AbgL1OpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:45:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E1C1206DC;
        Mon, 28 Dec 2020 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166680;
        bh=VIljnmLgoMidPH+NPH7k9deXuouhEESFj021t73kJII=;
        h=Subject:To:From:Date:From;
        b=2rSj+iklXqIMyvFpRk8lZOMZzCJEnS6EZ5Bt9oAY0DHOlIX4JVGNC4t+Jn8gIb7iO
         StnAA35vak3zB9xOeMIsrbpHCj7lGM8e90cmQHorSjVcX2Z6Kc1gkn4aQ+4CO1HRIW
         xHzrTWy4q8In9UVyqPT8DiOP5QYYAZETqV78QMKA=
Subject: patch "usb: dwc3: meson-g12a: disable clk on error handling path in probe" added to usb-linus
To:     zhengzengkai@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, martin.blumenstingl@googlemail.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:46:02 +0100
Message-ID: <160916676217213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: meson-g12a: disable clk on error handling path in probe

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a5ada3dfe6a20f41f91448b9034a1ef8da3dc87d Mon Sep 17 00:00:00 2001
From: Zheng Zengkai <zhengzengkai@huawei.com>
Date: Tue, 15 Dec 2020 10:54:59 +0800
Subject: usb: dwc3: meson-g12a: disable clk on error handling path in probe

dwc3_meson_g12a_probe() does not invoke clk_bulk_disable_unprepare()
on one error handling path. This patch fixes that.

Fixes: 347052e3bf1b ("usb: dwc3: meson-g12a: fix USB2 PHY initialization on G12A and A1 SoCs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20201215025459.91794-1-zhengzengkai@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index 417e05381b5d..bdf1f98dfad8 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -754,7 +754,7 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 
 	ret = priv->drvdata->setup_regmaps(priv, base);
 	if (ret)
-		return ret;
+		goto err_disable_clks;
 
 	if (priv->vbus) {
 		ret = regulator_enable(priv->vbus);
-- 
2.29.2


