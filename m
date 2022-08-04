Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0DF589922
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 10:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbiHDIQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 04:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbiHDIQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 04:16:44 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF58E66102
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 01:16:32 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Lz1jN6yQnzmVBZ;
        Thu,  4 Aug 2022 16:14:32 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 16:16:30 +0800
Received: from mdc.huawei.com (10.175.112.208) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 16:16:30 +0800
From:   Chen Jun <chenjun102@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <xuqiang36@huawei.com>
Subject: [PATCH stable 4.9 4/4] fbcon: Prevent that screen size is smaller than font size
Date:   Thu, 4 Aug 2022 08:14:09 +0000
Message-ID: <20220804081409.121787-5-chenjun102@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220804081409.121787-1-chenjun102@huawei.com>
References: <20220804081409.121787-1-chenjun102@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream.

We need to prevent that users configure a screen size which is smaller than the
currently selected font size. Otherwise rendering chars on the screen will
access memory outside the graphics memory region.

This patch adds a new function fbcon_modechange_possible() which
implements this check and which later may be extended with other checks
if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
for a too small screen size.

Signed-off-by: Helge Deller <deller@gmx.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v5.4+
Link: https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
[sudip: adjust context]
Signed-off-by: Chen Jun <chenjun102@huawei.com>
---
 drivers/video/console/fbcon.c    | 28 ++++++++++++++++++++++++++++
 drivers/video/fbdev/core/fbmem.c | 10 +++++++---
 include/linux/fbcon.h            | 12 ++++++++++++
 3 files changed, 47 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/fbcon.h

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index e9eb8aaa2040..2097670b22f7 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2689,6 +2689,34 @@ static void fbcon_set_all_vcs(struct fb_info *info)
 		fbcon_modechanged(info);
 }
 
+/* let fbcon check if it supports a new screen resolution */
+int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screeninfo *var)
+{
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct vc_data *vc;
+	unsigned int i;
+
+	WARN_CONSOLE_UNLOCKED();
+
+	if (!ops)
+		return 0;
+
+	/* prevent setting a screen size which is smaller than font size */
+	for (i = first_fb_vc; i <= last_fb_vc; i++) {
+		vc = vc_cons[i].d;
+		if (!vc || vc->vc_mode != KD_TEXT ||
+			   registered_fb[con2fb_map[i]] != info)
+			continue;
+
+		if (vc->vc_font.width  > FBCON_SWAP(var->rotate, var->xres, var->yres) ||
+		    vc->vc_font.height > FBCON_SWAP(var->rotate, var->yres, var->xres))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fbcon_modechange_possible);
+
 static int fbcon_mode_deleted(struct fb_info *info,
 			      struct fb_videomode *mode)
 {
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 90d918c78f04..b13f6f02633d 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/efi.h>
 #include <linux/fb.h>
+#include <linux/fbcon.h>
 #include <linux/overflow.h>
 
 #include <asm/fb.h>
@@ -1142,9 +1143,12 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			console_unlock();
 			return -ENODEV;
 		}
-		info->flags |= FBINFO_MISC_USEREVENT;
-		ret = fb_set_var(info, &var);
-		info->flags &= ~FBINFO_MISC_USEREVENT;
+		ret = fbcon_modechange_possible(info, &var);
+		if (!ret) {
+			info->flags |= FBINFO_MISC_USEREVENT;
+			ret = fb_set_var(info, &var);
+			info->flags &= ~FBINFO_MISC_USEREVENT;
+		}
 		unlock_fb_info(info);
 		console_unlock();
 		if (!ret && copy_to_user(argp, &var, sizeof(var)))
diff --git a/include/linux/fbcon.h b/include/linux/fbcon.h
new file mode 100644
index 000000000000..f3da28242ef4
--- /dev/null
+++ b/include/linux/fbcon.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_FBCON_H
+#define _LINUX_FBCON_H
+
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE
+int  fbcon_modechange_possible(struct fb_info *info,
+			       struct fb_var_screeninfo *var);
+#else
+static inline int  fbcon_modechange_possible(struct fb_info *info,
+				struct fb_var_screeninfo *var) { return 0; }
+#endif
+
+#endif /* _LINUX_FBCON_H */
-- 
2.17.1

