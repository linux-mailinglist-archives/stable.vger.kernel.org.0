Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5973FDA60
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244971AbhIAMcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244761AbhIAMbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA196610A1;
        Wed,  1 Sep 2021 12:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499428;
        bh=iFG2hhXMkqgI+AgC85Z5sKXg1Dvw7eyDMrwI/JpE+Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpMZL80j81ouTK4BViYM9Gy8jwO2nEYE2gzh0B1cErCq/AaR9xBC8NzZRaeJiKrc2
         XM6hzxOuLdKxU2XiT5/ZHUYxEKMbCeJLfOuq00YFMG95ORB55yCiMawIQiZy6e6bAh
         vyJOE/3huuhOtNJlJ+mBCJx0bEh+QOI6SVy5y+no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        syzbot+e5fd3e65515b48c02a30@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dhaval Giani <dhaval.giani@oracle.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.19 30/33] fbmem: add margin check to fb_check_caps()
Date:   Wed,  1 Sep 2021 14:28:19 +0200
Message-Id: <20210901122251.776826620@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

commit a49145acfb975d921464b84fe00279f99827d816 upstream.

A fb_ioctl() FBIOPUT_VSCREENINFO call with invalid xres setting
or yres setting in struct fb_var_screeninfo will result in a
KASAN: vmalloc-out-of-bounds failure in bitfill_aligned() as
the margins are being cleared. The margins are cleared in
chunks and if the xres setting or yres setting is a value of
zero upto the chunk size, the failure will occur.

Add a margin check to validate xres and yres settings.

Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reported-by: syzbot+e5fd3e65515b48c02a30@syzkaller.appspotmail.com
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dhaval Giani <dhaval.giani@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1594149963-13801-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -991,6 +991,10 @@ fb_set_var(struct fb_info *info, struct
 			goto done;
 		}
 
+		/* bitfill_aligned() assumes that it's at least 8x8 */
+		if (var->xres < 8 || var->yres < 8)
+			return -EINVAL;
+
 		ret = info->fbops->fb_check_var(var, info);
 
 		if (ret)


