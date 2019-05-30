Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352702F6D4
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfE3DJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727680AbfE3DJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A81192448E;
        Thu, 30 May 2019 03:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185778;
        bh=CbZArB9MKUxnFEC4rTaoIMLibYwBCdr6PxR0TOtiaPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpVaH83nR8iqvTq8dAVkSmPEmYAGhiaHePhwaEYhB25tMPC/Rv6sm/RcUVFDRAazt
         HdltDIcE/CXDE/lnugyymXdx8m+b4nN/Mx+WeelssgcaHjePvCgifvJkgjBxanArGJ
         DO0ox7pyHKASoUkTn1g49IfZiow7uo2gZI8hR+HY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Syzbot <syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.1 037/405] media: vivid: use vfree() instead of kfree() for dev->bitmap_cap
Date:   Wed, 29 May 2019 20:00:35 -0700
Message-Id: <20190530030542.645291906@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
@@ -1007,7 +1007,7 @@ int vivid_vid_cap_s_selection(struct fil
 		v4l2_rect_map_inside(&s->r, &dev->fmt_cap_rect);
 		if (dev->bitmap_cap && (compose->width != s->r.width ||
 					compose->height != s->r.height)) {
-			kfree(dev->bitmap_cap);
+			vfree(dev->bitmap_cap);
 			dev->bitmap_cap = NULL;
 		}
 		*compose = s->r;


