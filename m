Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E5059A521
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353662AbiHSQoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353554AbiHSQmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:42:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99266558C8;
        Fri, 19 Aug 2022 09:11:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC97361888;
        Fri, 19 Aug 2022 16:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE93CC433D6;
        Fri, 19 Aug 2022 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925393;
        bh=THYaxhYxEtt5DwL3NnXBSqE1FH6qDsr39tfqXb4p+iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMPXUY0fxUR252LqFYU76InfDXCRawsqVicLQk22iC5fIorJlBAQuc6nhnKZSmCI1
         8QGA+EnvHu6qehQMzSrERL3dohibnZX2cJM3cY/19Skv81vHO9D4EcIupaizZ97iZR
         bAafw7/8tjYYH1IjNrc0ernkgUDqOYzlYO/yMTK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/545] video: fbdev: s3fb: Check the size of screen before memset_io()
Date:   Fri, 19 Aug 2022 17:43:28 +0200
Message-Id: <20220819153849.021915423@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit 6ba592fa014f21f35a8ee8da4ca7b95a018f13e8 ]

In the function s3fb_set_par(), the value of 'screen_size' is
calculated by the user input. If the user provides the improper value,
the value of 'screen_size' may larger than 'info->screen_size', which
may cause the following bug:

[   54.083733] BUG: unable to handle page fault for address: ffffc90003000000
[   54.083742] #PF: supervisor write access in kernel mode
[   54.083744] #PF: error_code(0x0002) - not-present page
[   54.083760] RIP: 0010:memset_orig+0x33/0xb0
[   54.083782] Call Trace:
[   54.083788]  s3fb_set_par+0x1ec6/0x4040
[   54.083806]  fb_set_var+0x604/0xeb0
[   54.083836]  do_fb_ioctl+0x234/0x670

Fix the this by checking the value of 'screen_size' before memset_io().

Fixes: a268422de8bf ("fbdev driver for S3 Trio/Virge")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/s3fb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/s3fb.c b/drivers/video/fbdev/s3fb.c
index 5c74253e7b2c..a936455a3df2 100644
--- a/drivers/video/fbdev/s3fb.c
+++ b/drivers/video/fbdev/s3fb.c
@@ -902,6 +902,8 @@ static int s3fb_set_par(struct fb_info *info)
 	value = clamp((htotal + hsstart + 1) / 2 + 2, hsstart + 4, htotal + 1);
 	svga_wcrt_multi(par->state.vgabase, s3_dtpc_regs, value);
 
+	if (screen_size > info->screen_size)
+		screen_size = info->screen_size;
 	memset_io(info->screen_base, 0x00, screen_size);
 	/* Device and screen back on */
 	svga_wcrt_mask(par->state.vgabase, 0x17, 0x80, 0x80);
-- 
2.35.1



