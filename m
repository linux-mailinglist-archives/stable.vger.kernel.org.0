Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454BE500F16
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244191AbiDNNYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244178AbiDNNXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:23:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABDD93981;
        Thu, 14 Apr 2022 06:18:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80BBC617BB;
        Thu, 14 Apr 2022 13:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FC9C385A1;
        Thu, 14 Apr 2022 13:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942305;
        bh=nQoZ/jKhcbsjHwPxJEIr5sDQrgJemWYWU/Nl4SZ37ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+7ZsVHwoU2qpvzyBeATeYma5WVe4TY8M7z1y741ZchFrwneDpKVdDp/w6TRF0vWb
         qWyw0f8y7FrdqfMzeHP1ROQV9YtlyFP7hIco8T6UiPTni8dNArlhEuI9pn3/s+3I9W
         e5xc252bQr/stlKPJYp1b9VxvEg0dLApB7M9pbeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/338] video: fbdev: smscufx: Fix null-ptr-deref in ufx_usb_probe()
Date:   Thu, 14 Apr 2022 15:09:51 +0200
Message-Id: <20220414110841.403437368@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 1791f487f877a9e83d81c8677bd3e7b259e7cb27 ]

I got a null-ptr-deref report:

BUG: kernel NULL pointer dereference, address: 0000000000000000
...
RIP: 0010:fb_destroy_modelist+0x38/0x100
...
Call Trace:
 ufx_usb_probe.cold+0x2b5/0xac1 [smscufx]
 usb_probe_interface+0x1aa/0x3c0 [usbcore]
 really_probe+0x167/0x460
...
 ret_from_fork+0x1f/0x30

If fb_alloc_cmap() fails in ufx_usb_probe(), fb_destroy_modelist() will
be called to destroy modelist in the error handling path. But modelist
has not been initialized yet, so it will result in null-ptr-deref.

Initialize modelist before calling fb_alloc_cmap() to fix this bug.

Fixes: 3c8a63e22a08 ("Add support for SMSC UFX6000/7000 USB display adapters")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/smscufx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 22b606af0a87..da54a84d2e62 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1662,6 +1662,7 @@ static int ufx_usb_probe(struct usb_interface *interface,
 	info->par = dev;
 	info->pseudo_palette = dev->pseudo_palette;
 	info->fbops = &ufx_ops;
+	INIT_LIST_HEAD(&info->modelist);
 
 	retval = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (retval < 0) {
@@ -1672,8 +1673,6 @@ static int ufx_usb_probe(struct usb_interface *interface,
 	INIT_DELAYED_WORK(&dev->free_framebuffer_work,
 			  ufx_free_framebuffer_work);
 
-	INIT_LIST_HEAD(&info->modelist);
-
 	retval = ufx_reg_read(dev, 0x3000, &id_rev);
 	check_warn_goto_error(retval, "error %d reading 0x3000 register from device", retval);
 	dev_dbg(dev->gdev, "ID_REV register value 0x%08x", id_rev);
-- 
2.34.1



