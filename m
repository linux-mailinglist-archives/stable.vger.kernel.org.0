Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B02C2EE82
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732205AbfE3DU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732199AbfE3DU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:27 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B290A24937;
        Thu, 30 May 2019 03:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186426;
        bh=VPQvvo3SHXkAvfMTpOO34xbhbXNiy6XSCXnSvFBY4f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hT60qDdmq+bsePlh16gfK2aB58oHV3LcgOrIAedBmtgzCgFqpcu+dN0cAi9hNsmVg
         YVfDcf1oafHL6Qgr3eRyIpSnVLfc/8L0S8FgbUEjfYTp+bxzJgbg6vhhhV51Jaj5Er
         n+RggXBpUss9cPMF5xnGLyddQH010lwnihhWScPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Syzbot <syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.9 017/128] media: vivid: use vfree() instead of kfree() for dev->bitmap_cap
Date:   Wed, 29 May 2019 20:05:49 -0700
Message-Id: <20190530030437.846627438@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
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
@@ -984,7 +984,7 @@ int vivid_vid_cap_s_selection(struct fil
 		v4l2_rect_map_inside(&s->r, &dev->fmt_cap_rect);
 		if (dev->bitmap_cap && (compose->width != s->r.width ||
 					compose->height != s->r.height)) {
-			kfree(dev->bitmap_cap);
+			vfree(dev->bitmap_cap);
 			dev->bitmap_cap = NULL;
 		}
 		*compose = s->r;


