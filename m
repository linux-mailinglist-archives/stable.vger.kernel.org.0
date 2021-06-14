Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F543A61E3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhFNKwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233344AbhFNKum (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB34E6140F;
        Mon, 14 Jun 2021 10:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667130;
        bh=tAgHRmkXbDK9L6KTY2aEI9h5uKtmlvcQL2UoUrvwWgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myWoaw1DnGnXpiaWYXcYZ4jirl+D0XZ4+OKjw3EfgRpFmu35Jwp8tkTfE6WJbnw4E
         kUZVNV+AWs/1/3uYcte1SOFJWr/s3Ee0AEhHdin2wiWYIsnHIhNZO1tJIJFc3oqsY6
         6drjOgJZluuBZL0jHY3Tb8/JhlD98WzburQr4S6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c3a706cec1ea99e1c693@syzkaller.appspotmail.com,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.4 39/84] drm: Fix use-after-free read in drm_getunique()
Date:   Mon, 14 Jun 2021 12:27:17 +0200
Message-Id: <20210614102647.698537554@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit b436acd1cf7fac0ba987abd22955d98025c80c2b upstream.

There is a time-of-check-to-time-of-use error in drm_getunique() due
to retrieving file_priv->master prior to locking the device's master
mutex.

An example can be seen in the crash report of the use-after-free error
found by Syzbot:
https://syzkaller.appspot.com/bug?id=148d2f1dfac64af52ffd27b661981a540724f803

In the report, the master pointer was used after being freed. This is
because another process had acquired the device's master mutex in
drm_setmaster_ioctl(), then overwrote fpriv->master in
drm_new_set_master(). The old value of fpriv->master was subsequently
freed before the mutex was unlocked.

To fix this, we lock the device's master mutex before retrieving the
pointer from from fpriv->master. This patch passes the Syzbot
reproducer test.

Reported-by: syzbot+c3a706cec1ea99e1c693@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210608110436.239583-1-desmondcheongzx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_ioctl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -118,17 +118,18 @@ int drm_getunique(struct drm_device *dev
 		  struct drm_file *file_priv)
 {
 	struct drm_unique *u = data;
-	struct drm_master *master = file_priv->master;
+	struct drm_master *master;
 
-	mutex_lock(&master->dev->master_mutex);
+	mutex_lock(&dev->master_mutex);
+	master = file_priv->master;
 	if (u->unique_len >= master->unique_len) {
 		if (copy_to_user(u->unique, master->unique, master->unique_len)) {
-			mutex_unlock(&master->dev->master_mutex);
+			mutex_unlock(&dev->master_mutex);
 			return -EFAULT;
 		}
 	}
 	u->unique_len = master->unique_len;
-	mutex_unlock(&master->dev->master_mutex);
+	mutex_unlock(&dev->master_mutex);
 
 	return 0;
 }


