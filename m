Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9843A9B4
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbfFIQ7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733212AbfFIQ7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:59:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4808207E0;
        Sun,  9 Jun 2019 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099577;
        bh=uUxkPqFQilc1zz9Bg/0e7rKTxIztRsjn991NqXP2H+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMedhCNnKSB/qYuZpNtUmb0ZFUX/CFAGA1e3l23b0hmr/aWrX3VxOljJy2AY/o72L
         w1eig5zU0phdaFUVDRQGSqdSk5ltyzIhjrqN4qCrCatl2XF2h/dqW0H5is5uKkd8vs
         kXkK3sbOO+9TCWUj2dEQy6a3WfXXYaUupZN+NN4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Syzbot <syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.4 088/241] media: vivid: use vfree() instead of kfree() for dev->bitmap_cap
Date:   Sun,  9 Jun 2019 18:40:30 +0200
Message-Id: <20190609164150.313262931@linuxfoundation.org>
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

From: Alexander Potapenko <glider@google.com>

commit dad7e270ba712ba1c99cd2d91018af6044447a06 upstream.

syzkaller reported crashes on kfree() called from
vivid_vid_cap_s_selection(). This looks like a simple typo, as
dev->bitmap_cap is allocated with vzalloc() throughout the file.

Fixes: ef834f7836ec0 ("[media] vivid: add the video capture and output
parts")

Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Syzbot <syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/vivid/vivid-vid-cap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -993,7 +993,7 @@ int vivid_vid_cap_s_selection(struct fil
 		rect_map_inside(&s->r, &dev->fmt_cap_rect);
 		if (dev->bitmap_cap && (compose->width != s->r.width ||
 					compose->height != s->r.height)) {
-			kfree(dev->bitmap_cap);
+			vfree(dev->bitmap_cap);
 			dev->bitmap_cap = NULL;
 		}
 		*compose = s->r;


