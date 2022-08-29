Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DAD5A4A60
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiH2LhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiH2Lgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:36:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34655754BC;
        Mon, 29 Aug 2022 04:21:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 272FFB80F62;
        Mon, 29 Aug 2022 11:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D0EC433D6;
        Mon, 29 Aug 2022 11:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771510;
        bh=j0O6seP0hDl2M/tiFwyK3s5JdTNEVqLVc61BtKI2w4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gI8TUuW2M64dSMkGQ+5vKiW7AI0j+zMtq1PDg7XZw3TEgdyFNbzu/EL/0F/sgiJS9
         OisIgRQhTU3hYHD/bRRyZDfDDVW9cudnu6z3qEOKgPnI/7s1LQCmXdByvCTYU36OFY
         BM2Z8GfYdZ4w17ii2RQJJaKNyzt16aLSnz/5ElUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a168dbeaaa7778273c1b@syzkaller.appspotmail.com,
        Shigeru Yoshida <syoshida@redhat.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 111/136] fbdev: fbcon: Properly revert changes when vc_resize() failed
Date:   Mon, 29 Aug 2022 12:59:38 +0200
Message-Id: <20220829105809.264085223@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

commit a5a923038d70d2d4a86cb4e3f32625a5ee6e7e24 upstream.

fbcon_do_set_font() calls vc_resize() when font size is changed.
However, if if vc_resize() failed, current implementation doesn't
revert changes for font size, and this causes inconsistent state.

syzbot reported unable to handle page fault due to this issue [1].
syzbot's repro uses fault injection which cause failure for memory
allocation, so vc_resize() failed.

This patch fixes this issue by properly revert changes for font
related date when vc_resize() failed.

Link: https://syzkaller.appspot.com/bug?id=3443d3a1fa6d964dd7310a0cb1696d165a3e07c4 [1]
Reported-by: syzbot+a168dbeaaa7778273c1b@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Helge Deller <deller@gmx.de>
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2413,15 +2413,21 @@ static int fbcon_do_set_font(struct vc_d
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fbcon_display *p = &fb_display[vc->vc_num];
-	int resize;
+	int resize, ret, old_userfont, old_width, old_height, old_charcount;
 	char *old_data = NULL;
 
 	resize = (w != vc->vc_font.width) || (h != vc->vc_font.height);
 	if (p->userfont)
 		old_data = vc->vc_font.data;
 	vc->vc_font.data = (void *)(p->fontdata = data);
+	old_userfont = p->userfont;
 	if ((p->userfont = userfont))
 		REFCOUNT(data)++;
+
+	old_width = vc->vc_font.width;
+	old_height = vc->vc_font.height;
+	old_charcount = vc->vc_font.charcount;
+
 	vc->vc_font.width = w;
 	vc->vc_font.height = h;
 	vc->vc_font.charcount = charcount;
@@ -2437,7 +2443,9 @@ static int fbcon_do_set_font(struct vc_d
 		rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 		cols /= w;
 		rows /= h;
-		vc_resize(vc, cols, rows);
+		ret = vc_resize(vc, cols, rows);
+		if (ret)
+			goto err_out;
 	} else if (con_is_visible(vc)
 		   && vc->vc_mode == KD_TEXT) {
 		fbcon_clear_margins(vc, 0);
@@ -2447,6 +2455,21 @@ static int fbcon_do_set_font(struct vc_d
 	if (old_data && (--REFCOUNT(old_data) == 0))
 		kfree(old_data - FONT_EXTRA_WORDS * sizeof(int));
 	return 0;
+
+err_out:
+	p->fontdata = old_data;
+	vc->vc_font.data = (void *)old_data;
+
+	if (userfont) {
+		p->userfont = old_userfont;
+		REFCOUNT(data)--;
+	}
+
+	vc->vc_font.width = old_width;
+	vc->vc_font.height = old_height;
+	vc->vc_font.charcount = old_charcount;
+
+	return ret;
 }
 
 /*


