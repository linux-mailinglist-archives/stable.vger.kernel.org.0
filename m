Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D98273069
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgIUREr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbgIUQfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:35:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94575239D3;
        Mon, 21 Sep 2020 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706099;
        bh=/6ABPznMbPJMPHwQ9dNfrnIj4B/bBpl7xDMTEHxTExI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uj5XvRwlyklPYQhHQmjF45ss2yNmN8kel3E/ClQJ6lhHndLjhf8SM6EmGV2tDEUPl
         DBRiP9+cdKJ2NaQEvkC/77bDsY7kUVBWIHEJRBRKpvXA63EaVlrV3MZqu0LjwXDbx2
         8OjMU7GIp0g2q0XeQZtGwiIjYVW7lI0frn1P2LiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+69fbd3e01470f169c8c4@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4.9 39/70] video: fbdev: fix OOB read in vga_8planes_imageblit()
Date:   Mon, 21 Sep 2020 18:27:39 +0200
Message-Id: <20200921162036.902193432@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit bd018a6a75cebb511bb55a0e7690024be975fe93 upstream.

syzbot is reporting OOB read at vga_8planes_imageblit() [1], for
"cdat[y] >> 4" can become a negative value due to "const char *cdat".

[1] https://syzkaller.appspot.com/bug?id=0d7a0da1557dcd1989e00cb3692b26d4173b4132

Reported-by: syzbot <syzbot+69fbd3e01470f169c8c4@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/90b55ec3-d5b0-3307-9f7c-7ff5c5fd6ad3@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/vga16fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/vga16fb.c
+++ b/drivers/video/fbdev/vga16fb.c
@@ -1122,7 +1122,7 @@ static void vga_8planes_imageblit(struct
         char oldop = setop(0);
         char oldsr = setsr(0);
         char oldmask = selectmask();
-        const char *cdat = image->data;
+	const unsigned char *cdat = image->data;
 	u32 dx = image->dx;
         char __iomem *where;
         int y;


