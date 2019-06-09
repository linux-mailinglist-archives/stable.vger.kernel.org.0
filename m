Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316143A9B3
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387676AbfFIQ7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387682AbfFIQ7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:59:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C6C8206C3;
        Sun,  9 Jun 2019 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099571;
        bh=zgiv+qFIzyKL+BVY8zd+kxmbe99pwOeqQq748lSnyHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVFGPokmA9RIUoCz4RuNj8N0yrEKy89LiXEJ0737nUjbJh9sE5/sgIGmxL11t+za5
         HNUFn7cmUXiDChK+d94qBvjGztRIVsWrgSB/+dLCkpd2Us6qghp0u5yAvt461fseo1
         hrpxMmqM2htLQfWIShW7pa5phVR7X0WjS3J3SYXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.4 086/241] fbdev: fix WARNING in __alloc_pages_nodemask bug
Date:   Sun,  9 Jun 2019 18:40:28 +0200
Message-Id: <20190609164150.256638981@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>

commit 8c40292be9169a9cbe19aadd1a6fc60cbd1af82f upstream.

Syzkaller hit 'WARNING in __alloc_pages_nodemask' bug.

WARNING: CPU: 1 PID: 1473 at mm/page_alloc.c:4377
__alloc_pages_nodemask+0x4da/0x2130
Kernel panic - not syncing: panic_on_warn set ...

Call Trace:
 alloc_pages_current+0xb1/0x1e0
 kmalloc_order+0x1f/0x60
 kmalloc_order_trace+0x1d/0x120
 fb_alloc_cmap_gfp+0x85/0x2b0
 fb_set_user_cmap+0xff/0x370
 do_fb_ioctl+0x949/0xa20
 fb_ioctl+0xdd/0x120
 do_vfs_ioctl+0x186/0x1070
 ksys_ioctl+0x89/0xa0
 __x64_sys_ioctl+0x74/0xb0
 do_syscall_64+0xc8/0x550
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

This is a warning about order >= MAX_ORDER and the order is from
userspace ioctl. Add flag __NOWARN to silence this warning.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/core/fbcmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/fbdev/core/fbcmap.c
+++ b/drivers/video/fbdev/core/fbcmap.c
@@ -94,6 +94,8 @@ int fb_alloc_cmap_gfp(struct fb_cmap *cm
 	int size = len * sizeof(u16);
 	int ret = -ENOMEM;
 
+	flags |= __GFP_NOWARN;
+
 	if (cmap->len != len) {
 		fb_dealloc_cmap(cmap);
 		if (!len)


