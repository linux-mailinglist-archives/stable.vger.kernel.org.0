Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC08FD1887
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 21:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbfJITLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 15:11:15 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:47187 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731743AbfJITLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 15:11:11 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M3Upe-1iHjOl3o5S-000eI9; Wed, 09 Oct 2019 21:11:05 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Yan, Zheng" <zyan@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v6 07/43] ceph: fix compat_ioctl for ceph_dir_operations
Date:   Wed,  9 Oct 2019 21:10:07 +0200
Message-Id: <20191009191044.308087-7-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7W6XauET3AbuBxFZSMsMMQ6FckF/PqX6UCoZ0636GkXwX1Y3vhl
 F5pZo2Tdv9ccXuGFKDbatg3idUQlOfnVdGV1MqrPsoxTarqSwSZiSg3nnsHhTpyOBTp1j+z
 5qEFufcDrhD7Q/AWIOFRwi1W1AAOENXFTdDym8PHZ0UBdt85kJ6UISjW+JTbcj6LBSRn5Vi
 wfltRDX28iQelblD8M3bg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6nVuoYemKGc=:u8DjLT9sJqHQIOC8or8pHu
 dMxtm9JYzJs3CwtLNUWgd7NpqlUDmdRaKX+4BI6Z0is25N0w4NoQCeQ5oSvUxVVRzsFiUpA7S
 0L5MfF8KSTzOxCRFNCmJUfmJFQD6v3ffxGrVmJerVbmKNuXVlddW+yOkqec6y2TUQChmu5NZd
 eRVfnqkUMqMaOGYUtuCj8+0UbCbhtryW08eSnSEYKokqJOkdFzuFFH3omX9DNGCJn9CoHAT6r
 qsAumB+ltwQAHDXxfrW1QublECT7J0D0nIaaoEQkfRTTyMGbwZiG1QftKJIQ0fA+BstWVjSqg
 uJa4tpkK3GaIdNLFfK5zomPlpBiPhv1f+h0gMWYNt6ag6gHqtN6WxqHQCy6KQcb9Z7pdOVNmo
 ND4Olt3QrfJM70RrNwRJ5KU0JXboZ5jnxVgLe43A/Hswdk03U5AiSWozZsi1MzDHZCmPTwC+o
 YZOuxINRbwKOQHGiOXJf31IFoer/oJjjSTI1JBf4vb2VyQcf7xrXg/xt0I3G7lbFYBgpyV279
 6qg5qmNC4mfirlpC+TT7dRmUyrzrBfHIFX2SRGOqWD343jXqkKHBlLxJE/1XEBaL6GSFrJwPc
 WJpZFxpO3HeZH63TWxgf1FX2TXdZ8gF9g/aXN9fktPDlAYbPoCETKm/CwzlQZ9U08weecZZ44
 eFRi1Cf8lTl72ti+J+a9FytZw+hzhcnW2UzuANcMuE4yQ9aCOQRb+MWI+HWHtckkjFaEajtuv
 ZsCSNX/AYBTjUVF/W0zzEid4XOWIYaISfnSLbk79Ivxo+rQlHtrzlwma25pRq9auM8Q9rDfBe
 iTpPQCyB3xLGGTjwHgMlYn3rTGSu6rvWNWR3r95DTE3RhUo3InG6yTkTHFJBfpTA70nKWTWhc
 l0yAP52a9viwO+vEy4iQ==
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
index d277f71abe0b..9e8e4bfe1d50 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2162,7 +2162,7 @@ const struct file_operations ceph_file_fops = {
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.unlocked_ioctl = ceph_ioctl,
-	.compat_ioctl	= ceph_ioctl,
+	.compat_ioctl = ceph_compat_ioctl,
 	.fallocate	= ceph_fallocate,
 	.copy_file_range = ceph_copy_file_range,
 };
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f98d9247f9cb..87bf9db76f98 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -6,6 +6,7 @@
 
 #include <asm/unaligned.h>
 #include <linux/backing-dev.h>
+#include <linux/compat.h>
 #include <linux/completion.h>
 #include <linux/exportfs.h>
 #include <linux/fs.h>
@@ -1123,6 +1124,15 @@ extern void ceph_readdir_cache_release(struct ceph_readdir_cache_control *ctl);
 
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

