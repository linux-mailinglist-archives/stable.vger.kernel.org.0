Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18201462728
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbhK2XBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbhK2W7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:59:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A256CC12BCC7;
        Mon, 29 Nov 2021 10:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E4A7DCE12FD;
        Mon, 29 Nov 2021 18:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C665C53FAD;
        Mon, 29 Nov 2021 18:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210847;
        bh=3CC0WAJIggZ1iPTycczb5ka6k5PNHu7aQfYYiqCRytI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YD8qiqnX+8+tfrOesh5IQl5d3l3OgzMpWp9goO1VSB+Oqg64AzQzak+39ozdyCKLt
         yy9TBYDb45qIuzyR58vqLOvKstFIGBHDSiVGJszB7pV/l8kEbf/KDXO07CB2BdG1Bi
         uO2eOJN+TWSw/TSEYBcMwdqFElrwNmUCjtZls+3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.15 016/179] usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference in probe
Date:   Mon, 29 Nov 2021 19:16:50 +0100
Message-Id: <20211129181719.487072504@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d4d2e5329ae9dfd6742c84d79f7d143d10410f1b upstream.

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
 drivers/usb/chipidea/ci_hdrc_imx.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -420,15 +420,15 @@ static int ci_hdrc_imx_probe(struct plat
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
 


