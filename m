Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB2538AA2A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhETLKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236335AbhETLIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:08:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7039613DC;
        Thu, 20 May 2021 10:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505170;
        bh=hs+EqPyCDyqCDKC+REF6QbabERUgprgunsI+jUv/DwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHe+llIpmUfrCL7r+a+VcU+HB98SAOccnjxpA62BlxEwjRkJIpTnKMeyvObPWOgc8
         1hOD914INSm2h3qHpAArncplFEkM6w8bacUwTzMKh6j2iMcviAJ9YQK11jXXud/4bK
         SzIrAn8CimC7mDLLmKcA4941+gzmLCXCXKghvJpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+47fa9c9c648b765305b9@syzkaller.appspotmail.com,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Phillip Potter <phil@philpotter.co.uk>
Subject: [PATCH 4.4 014/190] fbdev: zero-fill colormap in fbcmap.c
Date:   Thu, 20 May 2021 11:21:18 +0200
Message-Id: <20210520092102.645060439@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

commit 19ab233989d0f7ab1de19a036e247afa4a0a1e9c upstream.

Use kzalloc() rather than kmalloc() for the dynamically allocated parts
of the colormap in fb_alloc_cmap_gfp, to prevent a leak of random kernel
data to userspace under certain circumstances.

Fixes a KMSAN-found infoleak bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=741578659feabd108ad9e06696f0c1f2e69c4b6e

Reported-by: syzbot+47fa9c9c648b765305b9@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210331220719.1499743-1-phil@philpotter.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/video/fbdev/core/fbcmap.c
+++ b/drivers/video/fbdev/core/fbcmap.c
@@ -101,17 +101,17 @@ int fb_alloc_cmap_gfp(struct fb_cmap *cm
 		if (!len)
 			return 0;
 
-		cmap->red = kmalloc(size, flags);
+		cmap->red = kzalloc(size, flags);
 		if (!cmap->red)
 			goto fail;
-		cmap->green = kmalloc(size, flags);
+		cmap->green = kzalloc(size, flags);
 		if (!cmap->green)
 			goto fail;
-		cmap->blue = kmalloc(size, flags);
+		cmap->blue = kzalloc(size, flags);
 		if (!cmap->blue)
 			goto fail;
 		if (transp) {
-			cmap->transp = kmalloc(size, flags);
+			cmap->transp = kzalloc(size, flags);
 			if (!cmap->transp)
 				goto fail;
 		} else {


