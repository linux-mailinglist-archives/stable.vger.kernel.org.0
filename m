Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11749594CE5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244692AbiHPAr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348565AbiHPAqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:46:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FE4195825;
        Mon, 15 Aug 2022 13:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CA9DB81197;
        Mon, 15 Aug 2022 20:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF290C433D6;
        Mon, 15 Aug 2022 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596287;
        bh=blUag92h8eWnSLEZbHuaNvoEH/qbG9jaiisbiWnHFkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfJo81JiTttzwhlW9ybGnUV9Gs7/VBmoukrTcyaEJEvAX+BXR/v/u8pRRzhCmBRek
         hkd6RciBuU91o8dHuOBhY+mHx6ls0MpmPB2b41c56/LFmf/fOoyQ1xQVDCB3k5aFQ1
         JKauiz9OkrcSLTHszspHdeq5+KLjgjW/n5TCqNHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1031/1157] video: fbdev: arkfb: Check the size of screen before memset_io()
Date:   Mon, 15 Aug 2022 20:06:27 +0200
Message-Id: <20220815180521.202515046@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 96b550971c65d54d64728d8ba973487878a06454 ]

In the function arkfb_set_par(), the value of 'screen_size' is
calculated by the user input. If the user provides the improper value,
the value of 'screen_size' may larger than 'info->screen_size', which
may cause the following bug:

[  659.399066] BUG: unable to handle page fault for address: ffffc90003000000
[  659.399077] #PF: supervisor write access in kernel mode
[  659.399079] #PF: error_code(0x0002) - not-present page
[  659.399094] RIP: 0010:memset_orig+0x33/0xb0
[  659.399116] Call Trace:
[  659.399122]  arkfb_set_par+0x143f/0x24c0
[  659.399130]  fb_set_var+0x604/0xeb0
[  659.399161]  do_fb_ioctl+0x234/0x670
[  659.399189]  fb_ioctl+0xdd/0x130

Fix the this by checking the value of 'screen_size' before memset_io().

Fixes: 681e14730c73 ("arkfb: new framebuffer driver for ARK Logic cards")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/arkfb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/arkfb.c b/drivers/video/fbdev/arkfb.c
index ed76ddc7df3d..a2a381631628 100644
--- a/drivers/video/fbdev/arkfb.c
+++ b/drivers/video/fbdev/arkfb.c
@@ -797,6 +797,8 @@ static int arkfb_set_par(struct fb_info *info)
 	value = ((value * hmul / hdiv) / 8) - 5;
 	vga_wcrt(par->state.vgabase, 0x42, (value + 1) / 2);
 
+	if (screen_size > info->screen_size)
+		screen_size = info->screen_size;
 	memset_io(info->screen_base, 0x00, screen_size);
 	/* Device and screen back on */
 	svga_wcrt_mask(par->state.vgabase, 0x17, 0x80, 0x80);
-- 
2.35.1



