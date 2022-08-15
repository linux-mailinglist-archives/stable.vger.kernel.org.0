Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E464593CC6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345209AbiHOTs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345577AbiHOTrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B8170E6F;
        Mon, 15 Aug 2022 11:49:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26174611EC;
        Mon, 15 Aug 2022 18:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A122C433C1;
        Mon, 15 Aug 2022 18:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589371;
        bh=iNolcQLsPmYHRMyNxtH30MXdTPCUZ/VVHnCYzYOKTLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3+p/mwWVJiDJYbaxy9Espib/Ey2xhRHoxP1PZrgZJ7LrfWw6ds0JmoDKX994VnCZ
         oJg3lNYYejoEHNMFcQaRpnyVOuM/FtH9jagNgineZuDCmXY5sZ5RyxBA9e15Dq9qqm
         Mt6jxIzb+dYlYOMrLqxFLKbdKIfYphCFF73H7iXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 666/779] video: fbdev: vt8623fb: Check the size of screen before memset_io()
Date:   Mon, 15 Aug 2022 20:05:10 +0200
Message-Id: <20220815180405.808687784@linuxfoundation.org>
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

[ Upstream commit ec0754c60217248fa77cc9005d66b2b55200ac06 ]

In the function vt8623fb_set_par(), the value of 'screen_size' is
calculated by the user input. If the user provides the improper value,
the value of 'screen_size' may larger than 'info->screen_size', which
may cause the following bug:

[  583.339036] BUG: unable to handle page fault for address: ffffc90005000000
[  583.339049] #PF: supervisor write access in kernel mode
[  583.339052] #PF: error_code(0x0002) - not-present page
[  583.339074] RIP: 0010:memset_orig+0x33/0xb0
[  583.339110] Call Trace:
[  583.339118]  vt8623fb_set_par+0x11cd/0x21e0
[  583.339146]  fb_set_var+0x604/0xeb0
[  583.339181]  do_fb_ioctl+0x234/0x670
[  583.339209]  fb_ioctl+0xdd/0x130

Fix the this by checking the value of 'screen_size' before memset_io().

Fixes: 558b7bd86c32 ("vt8623fb: new framebuffer driver for VIA VT8623")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/vt8623fb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/vt8623fb.c b/drivers/video/fbdev/vt8623fb.c
index 7a959e5ba90b..c274ec5e965c 100644
--- a/drivers/video/fbdev/vt8623fb.c
+++ b/drivers/video/fbdev/vt8623fb.c
@@ -504,6 +504,8 @@ static int vt8623fb_set_par(struct fb_info *info)
 			 (info->var.vmode & FB_VMODE_DOUBLE) ? 2 : 1, 1,
 			 1, info->node);
 
+	if (screen_size > info->screen_size)
+		screen_size = info->screen_size;
 	memset_io(info->screen_base, 0x00, screen_size);
 
 	/* Device and screen back on */
-- 
2.35.1



