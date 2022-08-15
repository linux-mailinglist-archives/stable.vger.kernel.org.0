Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA1593CDA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242686AbiHOTt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344565AbiHOTr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:47:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9252A71737;
        Mon, 15 Aug 2022 11:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FA88B810A1;
        Mon, 15 Aug 2022 18:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62311C433C1;
        Mon, 15 Aug 2022 18:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589377;
        bh=THYaxhYxEtt5DwL3NnXBSqE1FH6qDsr39tfqXb4p+iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rd/278UB4SHCwcCfdz8X7aX975cruP6mwc07y5q5MSq4mWpmAHNMYGhx1+igS2L6m
         eltcw3k3wKBUVHEhQZwUCa2Uv27JRoe5lkKqTCFCxGA9lciqR5xep4riebl1PaUSYe
         RmxUmjr7ZcuVRakvb54rZs0R2pj2w+x8Fznun5Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 668/779] video: fbdev: s3fb: Check the size of screen before memset_io()
Date:   Mon, 15 Aug 2022 20:05:12 +0200
Message-Id: <20220815180405.892058097@linuxfoundation.org>
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



