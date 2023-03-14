Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D809B6B93DF
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjCNMeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCNMeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:34:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3451F5E5
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 05:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678797076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HbhFOMCQBCCU5HlpK+i5DLDhtUolKyI3cW+PZX4tqo8=;
        b=Dw+kkwR3qcGJ4BHp4EswuzG2czQ9T+BVML/bvcuhkZkbGbYJAKXFYjE6bC34692tLOKqJ8
        m3+Ph30HxTlcVpkOl78WLSupRFlOqTWeH/e+t7idA43Am27Mpo7zXjVicSP5fq22NxK4MS
        Tr6I8QlNeqhbigooQbSaS3vi//TeH9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-e6XR-hsROv2KE7AfBS2lNg-1; Tue, 14 Mar 2023 08:31:13 -0400
X-MC-Unique: e6XR-hsROv2KE7AfBS2lNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD53E85CCE1;
        Tue, 14 Mar 2023 12:31:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.195.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81436C15A0B;
        Tue, 14 Mar 2023 12:31:11 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] efi: sysfb_efi: Fix DMI quirks not working for simpledrm
Date:   Tue, 14 Mar 2023 13:31:02 +0100
Message-Id: <20230314123103.522115-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup
for all arches") moved the sysfb_apply_efi_quirks() call in sysfb_init()
from before the [sysfb_]parse_mode() call to after it.
But sysfb_apply_efi_quirks() modifies the global screen_info struct which
[sysfb_]parse_mode() parses, so doing it later is too late.

This has broken all DMI based quirks for correcting wrong firmware efifb
settings when simpledrm is used.

To fix this move the sysfb_apply_efi_quirks() call back to its old place
and split the new setup of the efifb_fwnode (which requires
the platform_device) into its own function and call that at
the place of the moved sysfb_apply_efi_quirks(pd) calls.

Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
Cc: stable@vger.kernel.org
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/firmware/efi/sysfb_efi.c  | 5 ++++-
 drivers/firmware/sysfb.c          | 4 +++-
 drivers/firmware/sysfb_simplefb.c | 2 +-
 include/linux/sysfb.h             | 9 +++++++--
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index f06fdacc9bc8..e76d6803bdd0 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -341,7 +341,7 @@ static const struct fwnode_operations efifb_fwnode_ops = {
 #ifdef CONFIG_EFI
 static struct fwnode_handle efifb_fwnode;
 
-__init void sysfb_apply_efi_quirks(struct platform_device *pd)
+__init void sysfb_apply_efi_quirks(void)
 {
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
 	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
@@ -355,7 +355,10 @@ __init void sysfb_apply_efi_quirks(struct platform_device *pd)
 		screen_info.lfb_height = temp;
 		screen_info.lfb_linelength = 4 * screen_info.lfb_width;
 	}
+}
 
+__init void sysfb_set_efifb_fwnode(struct platform_device *pd)
+{
 	if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI && IS_ENABLED(CONFIG_PCI)) {
 		fwnode_init(&efifb_fwnode, &efifb_fwnode_ops);
 		pd->dev.fwnode = &efifb_fwnode;
diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index 3fd3563d962b..3c197db42c9d 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -81,6 +81,8 @@ static __init int sysfb_init(void)
 	if (disabled)
 		goto unlock_mutex;
 
+	sysfb_apply_efi_quirks();
+
 	/* try to create a simple-framebuffer device */
 	compatible = sysfb_parse_mode(si, &mode);
 	if (compatible) {
@@ -107,7 +109,7 @@ static __init int sysfb_init(void)
 		goto unlock_mutex;
 	}
 
-	sysfb_apply_efi_quirks(pd);
+	sysfb_set_efifb_fwnode(pd);
 
 	ret = platform_device_add_data(pd, si, sizeof(*si));
 	if (ret)
diff --git a/drivers/firmware/sysfb_simplefb.c b/drivers/firmware/sysfb_simplefb.c
index ce9c007ed66f..82c64cb9f531 100644
--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -141,7 +141,7 @@ __init struct platform_device *sysfb_create_simplefb(const struct screen_info *s
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
-	sysfb_apply_efi_quirks(pd);
+	sysfb_set_efifb_fwnode(pd);
 
 	ret = platform_device_add_resources(pd, &res, 1);
 	if (ret)
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
index 8ba8b5be5567..c1ef5fc60a3c 100644
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -70,11 +70,16 @@ static inline void sysfb_disable(void)
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
-void sysfb_apply_efi_quirks(struct platform_device *pd);
+void sysfb_apply_efi_quirks(void);
+void sysfb_set_efifb_fwnode(struct platform_device *pd);
 
 #else /* CONFIG_EFI */
 
-static inline void sysfb_apply_efi_quirks(struct platform_device *pd)
+static inline void sysfb_apply_efi_quirks(void)
+{
+}
+
+static inline void sysfb_set_efifb_fwnode(struct platform_device *pd)
 {
 }
 
-- 
2.39.1

