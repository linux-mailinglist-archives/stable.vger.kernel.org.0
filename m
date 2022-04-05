Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079114F2765
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiDEIGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbiDEH6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B200AA01F;
        Tue,  5 Apr 2022 00:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C4BDB81BA7;
        Tue,  5 Apr 2022 07:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC38C340EE;
        Tue,  5 Apr 2022 07:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145195;
        bh=lfMoL5Nyc8RJg1qdgYmPYov80y4msIbqIDeHePByH+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztqXNchSQ6ECwmT3ggG+CKoJKeUgsuZlmA4QfsNRK8TcCO3c2uAB8GnC2hU/ZR3n5
         T/0IPOwweHWSUY7FcuVNHfhvflpSAAOaftrRWE1K38n5NJQdeRz1LX4MUou4/qZkrO
         TFs5B0JiTBAvS+NwwY7jUJNR3yt3RZgXLlke+bhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0319/1126] video: fbdev: smscufx: Fix null-ptr-deref in ufx_usb_probe()
Date:   Tue,  5 Apr 2022 09:17:46 +0200
Message-Id: <20220405070416.979751940@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index bfac3ee4a642..28768c272b73 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1656,6 +1656,7 @@ static int ufx_usb_probe(struct usb_interface *interface,
 	info->par = dev;
 	info->pseudo_palette = dev->pseudo_palette;
 	info->fbops = &ufx_ops;
+	INIT_LIST_HEAD(&info->modelist);
 
 	retval = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (retval < 0) {
@@ -1666,8 +1667,6 @@ static int ufx_usb_probe(struct usb_interface *interface,
 	INIT_DELAYED_WORK(&dev->free_framebuffer_work,
 			  ufx_free_framebuffer_work);
 
-	INIT_LIST_HEAD(&info->modelist);
-
 	retval = ufx_reg_read(dev, 0x3000, &id_rev);
 	check_warn_goto_error(retval, "error %d reading 0x3000 register from device", retval);
 	dev_dbg(dev->gdev, "ID_REV register value 0x%08x", id_rev);
-- 
2.34.1



