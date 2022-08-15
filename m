Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8A3593D0F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345301AbiHOTtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345606AbiHOTrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:47:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FB87170B;
        Mon, 15 Aug 2022 11:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A50460FB8;
        Mon, 15 Aug 2022 18:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7A4C433C1;
        Mon, 15 Aug 2022 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589374;
        bh=Nr2tTi7hex0MmEAfHhyJS0YEDbBqvlF6Y+BVTcagX2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ibq3gvQDMJZ4xphm1G8FciTaDJtALhWEWE1oUyGxGN1Wbk5+rvOWwTWATp0jqShdJ
         NQ5gN74l9Ae76qij/enH9O8fJd2yqRv8/s0AbpxrhWz8xKBZKc90XWo55V52PwaTUi
         SqtPpLdXEFuooFcWLxj68HQn6HQ0ut6FXtGr/W04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 667/779] video: fbdev: arkfb: Check the size of screen before memset_io()
Date:   Mon, 15 Aug 2022 20:05:11 +0200
Message-Id: <20220815180405.850582198@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index d94cc5ad1ef6..8d092b106470 100644
--- a/drivers/video/fbdev/arkfb.c
+++ b/drivers/video/fbdev/arkfb.c
@@ -794,6 +794,8 @@ static int arkfb_set_par(struct fb_info *info)
 	value = ((value * hmul / hdiv) / 8) - 5;
 	vga_wcrt(par->state.vgabase, 0x42, (value + 1) / 2);
 
+	if (screen_size > info->screen_size)
+		screen_size = info->screen_size;
 	memset_io(info->screen_base, 0x00, screen_size);
 	/* Device and screen back on */
 	svga_wcrt_mask(par->state.vgabase, 0x17, 0x80, 0x80);
-- 
2.35.1



