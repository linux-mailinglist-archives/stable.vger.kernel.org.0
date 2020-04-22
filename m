Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F24E1B3FE3
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgDVKlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbgDVKUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:20:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A1EC2076E;
        Wed, 22 Apr 2020 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550812;
        bh=lUJfySIV4iy9oc8egJOB4Qa52Ho6PfQJ47fWOfGD2pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjYvOcsDgjwWzzD0rH8vQLauinj1mZCYwm/9e4JgSocYuHSMlP2wE//pFsYVByGcB
         iTqEz9W3qbn+p8pz4s0CKmt9IsfuwJCJ2fQKfYF+zplewDbVSypqd937ZkMF3iDiWS
         H8OXiA/o7PBxg2K1LLaGYVk9vpXaZdu5VQEc1fM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrea Righi <righi.andrea@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Peter Rosin <peda@axentia.se>,
        Jani Nikula <jani.nikula@intel.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.4 103/118] fbdev: potential information leak in do_fb_ioctl()
Date:   Wed, 22 Apr 2020 11:57:44 +0200
Message-Id: <20200422095048.125647124@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d3d19d6fc5736a798b118971935ce274f7deaa82 upstream.

The "fix" struct has a 2 byte hole after ->ywrapstep and the
"fix = info->fix;" assignment doesn't necessarily clear it.  It depends
on the compiler.  The solution is just to replace the assignment with an
memcpy().

Fixes: 1f5e31d7e55a ("fbmem: don't call copy_from/to_user() with mutex held")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrea Righi <righi.andrea@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Peter Rosin <peda@axentia.se>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200113100132.ixpaymordi24n3av@kili.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/core/fbmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1110,7 +1110,7 @@ static long do_fb_ioctl(struct fb_info *
 		break;
 	case FBIOGET_FSCREENINFO:
 		lock_fb_info(info);
-		fix = info->fix;
+		memcpy(&fix, &info->fix, sizeof(fix));
 		if (info->flags & FBINFO_HIDE_SMEM_START)
 			fix.smem_start = 0;
 		unlock_fb_info(info);


