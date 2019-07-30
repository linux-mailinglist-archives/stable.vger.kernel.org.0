Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2443C7B34B
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 21:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfG3T22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 15:28:28 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:33433 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfG3T22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 15:28:28 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MfpjF-1iYSFh2Mgb-00gKk2; Tue, 30 Jul 2019 21:28:20 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, "Yan, Zheng" <zyan@redhat.com>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH v5 07/29] ceph: fix compat_ioctl for ceph_dir_operations
Date:   Tue, 30 Jul 2019 21:25:18 +0200
Message-Id: <20190730192552.4014288-8-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190730192552.4014288-1-arnd@arndb.de>
References: <20190730192552.4014288-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:OFNJPOAxGGQ88UZpH506xX65QSClANbkeR8AXnNFg+lHh90Gp1y
 Km41PW8pur9V06yneCdcMZ9hh6d7J9oJdH/kEeWqHVzsG8RfrRQSupk+d4DtS4KyFBYLPBk
 rLbLRcJlpLJWSeIcWqGypgZFvJWpty+odggTjE26mYnYSO+ZtQlFYfaJz+zO9Ttf4G3JFIk
 GArX7xpL2XyXJhbP6c1FA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7ixz1WNaE9E=:uKu7zALGZzh9Pb/581lnUp
 nEk/LWN5HTdg5wgAzCfGiVw/W98p50xEGd/MYkeFR/+jqdAlXWazfuGBWuoHj/4eQJfnvWJ5r
 4mVE7cUYfbuFFpZ+Vp+MldVtItnygDJl4pYCuOWCGYep5VqwG1vaLk4kGIj91MRla4R3f//mN
 Ao3WW5mslyMD18Z+FIV50rXswB9VoGR4WQw7RTJUHetuBsHa07aPDlSRcY/uP2lOEkmZ2p2kN
 YFsUfeib4Gt9qLDT4OI0fyD7SvU9ZELhn5Q+RJk1rv4DxktrrUern2aMCavVNcat0Izyxz5jq
 GMZzq2Gc9G3qdZ5NGD9I2nQA1qYLsPlr1ZOybe2mG6r69qiwGnCV/aEFfehF147d8NBcZkIb3
 aQn1oI+qSDtExttzQKmjqV8Cr9PvYZTBV5+kXOQa5HjTdQj+ECe82bjd/+/D4fByztqZlwqjJ
 yQWn6RZ4myWQG6fv/KYq0Ws3eHzP/9STmpTiTh4zQzz+GWGVHzFcIqvkP5VA5rr75q95jzPn7
 394M+z/wTyOYXLfcXkUOAxu/+lXElKeFl6hsPOtRAxIMidDR1Z/OJV5ACHotfEjWCHTQns1H4
 qhefIVICQQS3pBpDC9mbTC83KPjxxgwOMdmWfzc0d5sS2vlzQRcDh+o9GP6ad992ZzONHzn+f
 9bot1snjzctzXYFC/KfkjepJfrF4h+GLon35W3nYgIqFb8ZzPKescF3M7t1zHlnqoJ2JrpJIz
 Mx8EeqifWwxcXLRP7OQCYd9H/5ANh8rYYo1wNg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ceph_ioctl function is used both for files and directories, but only
the files support doing that in 32-bit compat mode.

For consistency, add the same compat handler to the dir operations
as well, and use a handler that applies the appropriate compat_ptr()
conversion.

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ceph/dir.c   |  1 +
 fs/ceph/file.c  |  2 +-
 fs/ceph/super.h | 10 ++++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 4ca0b8ff9a72..401c17d36b71 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1808,6 +1808,7 @@ const struct file_operations ceph_dir_fops = {
 	.open = ceph_open,
 	.release = ceph_release,
 	.unlocked_ioctl = ceph_ioctl,
+	.compat_ioctl = ceph_compat_ioctl,
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
 	.flock = ceph_flock,
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 685a03cc4b77..99712b6b1ad5 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2138,7 +2138,7 @@ const struct file_operations ceph_file_fops = {
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.unlocked_ioctl = ceph_ioctl,
-	.compat_ioctl	= ceph_ioctl,
+	.compat_ioctl = ceph_compat_ioctl,
 	.fallocate	= ceph_fallocate,
 	.copy_file_range = ceph_copy_file_range,
 };
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d2352fd95dbc..0aebccd48fa0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -6,6 +6,7 @@
 
 #include <asm/unaligned.h>
 #include <linux/backing-dev.h>
+#include <linux/compat.h>
 #include <linux/completion.h>
 #include <linux/exportfs.h>
 #include <linux/fs.h>
@@ -1108,6 +1109,15 @@ extern void ceph_readdir_cache_release(struct ceph_readdir_cache_control *ctl);
 
 /* ioctl.c */
 extern long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static inline long
+ceph_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+#ifdef CONFIG_COMPAT
+	return ceph_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+#else
+	return -ENOTTY;
+#endif
+}
 
 /* export.c */
 extern const struct export_operations ceph_export_ops;
-- 
2.20.0

