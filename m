Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A613589920
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbiHDIQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 04:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239323AbiHDIQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 04:16:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E89965818
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 01:16:32 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lz1g15XRNzWf16;
        Thu,  4 Aug 2022 16:12:29 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 16:16:30 +0800
Received: from mdc.huawei.com (10.175.112.208) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 16:16:30 +0800
From:   Chen Jun <chenjun102@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <xuqiang36@huawei.com>
Subject: [PATCH stable 4.9 3/4] fbcon: Disallow setting font bigger than screen size
Date:   Thu, 4 Aug 2022 08:14:08 +0000
Message-ID: <20220804081409.121787-4-chenjun102@huawei.com>
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

commit 65a01e601dbba8b7a51a2677811f70f783766682 upstream.

Prevent that users set a font size which is bigger than the physical screen.
It's unlikely this may happen (because screens are usually much larger than the
fonts and each font char is limited to 32x32 pixels), but it may happen on
smaller screens/LCD displays.

Signed-off-by: Helge Deller <deller@gmx.de>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v4.14+
Link: https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
Signed-off-by: Chen Jun <chenjun102@huawei.com>
---
 drivers/video/console/fbcon.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 510bc3f51dcc..e9eb8aaa2040 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2428,6 +2428,11 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font, unsigne
 	if (charcount != 256 && charcount != 512)
 		return -EINVAL;
 
+	/* font bigger than screen resolution ? */
+	if (w > FBCON_SWAP(info->var.rotate, info->var.xres, info->var.yres) ||
+	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
+		return -EINVAL;
+
 	/* Make sure drawing engine can handle the font */
 	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
 	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
-- 
2.17.1

