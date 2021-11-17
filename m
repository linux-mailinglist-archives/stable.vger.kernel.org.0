Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B90A454822
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbhKQOIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:08:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhKQOIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A795861B6F;
        Wed, 17 Nov 2021 14:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157938;
        bh=vw+aMKvT7eSGUVWQ4FNrOz4GGoQmqPBiJNL4kb0uNq4=;
        h=Subject:To:From:Date:From;
        b=uWzna2yVSw/sJUzHskX+oEdwV/aslR39OOwuXdZi5swGMb2q89igmT99PzLT4MrE/
         kd3Km9ByMvUfHhGrCSv73b6RQ/+lUN0MF9ci0FnMqn8UzjeRxP01jqEtixmNn13me6
         9RqNEOj5W7ZqY74XCBbEtSMsUca0hrVxN3JvwUF8=
Subject: patch "usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference" added to usb-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:05:27 +0100
Message-ID: <163715792778216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d4d2e5329ae9dfd6742c84d79f7d143d10410f1b Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 17 Nov 2021 10:49:23 +0300
Subject: usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference
 in probe

If the first call to devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0)
fails with something other than -ENODEV then it leads to an error
pointer dereference.  For those errors we should just jump directly to
the error handling.

Fixes: 8253a34bfae3 ("usb: chipidea: ci_hdrc_imx: Also search for 'phys' phandle")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211117074923.GF5237@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index f1d100671ee6..097142ffb184 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -420,15 +420,15 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	data->phy = devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0);
 	if (IS_ERR(data->phy)) {
 		ret = PTR_ERR(data->phy);
-		if (ret == -ENODEV) {
-			data->phy = devm_usb_get_phy_by_phandle(dev, "phys", 0);
-			if (IS_ERR(data->phy)) {
-				ret = PTR_ERR(data->phy);
-				if (ret == -ENODEV)
-					data->phy = NULL;
-				else
-					goto err_clk;
-			}
+		if (ret != -ENODEV)
+			goto err_clk;
+		data->phy = devm_usb_get_phy_by_phandle(dev, "phys", 0);
+		if (IS_ERR(data->phy)) {
+			ret = PTR_ERR(data->phy);
+			if (ret == -ENODEV)
+				data->phy = NULL;
+			else
+				goto err_clk;
 		}
 	}
 
-- 
2.34.0


