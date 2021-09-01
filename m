Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA603FD9AB
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244244AbhIAM2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244225AbhIAM2O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:28:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 437C960ED4;
        Wed,  1 Sep 2021 12:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499237;
        bh=EdaVfwVqQySnlK3kfvV6DheWXtvvGB/RNn59vXK5RCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsYnOWbSFuwebANHhCZC72R+QXa1WZrDaUNsuYjCNr6wqJ8f8WwuH2QBAQqq+He5M
         YKrohshZCaE8lYwStjTnNK8rRQpoEVA7jNAyXpYEtyDTE/P06I7cBlbamcDd0JRkff
         fPTNGDhR/4sySWgWadCu+596ZiEKRtQFRkfr/fbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        syzbot+e5fd3e65515b48c02a30@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dhaval Giani <dhaval.giani@oracle.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.9 14/16] fbmem: add margin check to fb_check_caps()
Date:   Wed,  1 Sep 2021 14:26:40 +0200
Message-Id: <20210901122249.363523730@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
References: <20210901122248.920548099@linuxfoundation.org>
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
@@ -1001,6 +1001,10 @@ fb_set_var(struct fb_info *info, struct
 			goto done;
 		}
 
+		/* bitfill_aligned() assumes that it's at least 8x8 */
+		if (var->xres < 8 || var->yres < 8)
+			return -EINVAL;
+
 		ret = info->fbops->fb_check_var(var, info);
 
 		if (ret)


