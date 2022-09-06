Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD385AEAB9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiIFNul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239473AbiIFNta (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:49:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D872A948;
        Tue,  6 Sep 2022 06:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18BCC61548;
        Tue,  6 Sep 2022 13:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB15C433C1;
        Tue,  6 Sep 2022 13:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471558;
        bh=7wlCsrVRDBxNF3WWLtS5SZ44/JlKUKUftG/22O5o1qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7vOJAzGtTlx6ffnWe4xrChrymiNdDMCDWB8Nby96TRBbCc2xHPHFFaJOcx+5jXnc
         hNNaCVsn9FqQMZJUl6uxiGpqddO/+65VjNN3yaM9XxI8N5ZK1f5QSsjZ5hr1E98Nz+
         4F6Ndc3YLcvQnADDZuUbHia4d3D2fsDjQ6nw7ppo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+14b0e8f3fd1612e35350@syzkaller.appspotmail.com,
        stable <stable@kernel.org>,
        Khalid Masum <khalid.masum.92@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 035/107] vt: Clear selection before changing the font
Date:   Tue,  6 Sep 2022 15:30:16 +0200
Message-Id: <20220906132823.277462179@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 566f9c9f89337792070b5a6062dff448b3e7977f upstream.

When changing the console font with ioctl(KDFONTOP) the new font size
can be bigger than the previous font. A previous selection may thus now
be outside of the new screen size and thus trigger out-of-bounds
accesses to graphics memory if the selection is removed in
vc_do_resize().

Prevent such out-of-memory accesses by dropping the selection before the
various con_font_set() console handlers are called.

Reported-by: syzbot+14b0e8f3fd1612e35350@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Tested-by: Khalid Masum <khalid.masum.92@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Link: https://lore.kernel.org/r/YuV9apZGNmGfjcor@p100
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4662,9 +4662,11 @@ static int con_font_set(struct vc_data *
 	console_lock();
 	if (vc->vc_mode != KD_TEXT)
 		rc = -EINVAL;
-	else if (vc->vc_sw->con_font_set)
+	else if (vc->vc_sw->con_font_set) {
+		if (vc_is_sel(vc))
+			clear_selection();
 		rc = vc->vc_sw->con_font_set(vc, &font, op->flags);
-	else
+	} else
 		rc = -ENOSYS;
 	console_unlock();
 	kfree(font.data);
@@ -4691,9 +4693,11 @@ static int con_font_default(struct vc_da
 		console_unlock();
 		return -EINVAL;
 	}
-	if (vc->vc_sw->con_font_default)
+	if (vc->vc_sw->con_font_default) {
+		if (vc_is_sel(vc))
+			clear_selection();
 		rc = vc->vc_sw->con_font_default(vc, &font, s);
-	else
+	} else
 		rc = -ENOSYS;
 	console_unlock();
 	if (!rc) {


