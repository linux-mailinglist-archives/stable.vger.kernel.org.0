Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BD5642518
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 09:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiLEIy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 03:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiLEIxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 03:53:51 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7095F7678;
        Mon,  5 Dec 2022 00:52:57 -0800 (PST)
Received: from dggpemm500013.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NQck06QY8z15N6H;
        Mon,  5 Dec 2022 16:52:08 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Dec 2022 16:52:55 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenzhongjin@huawei.com>, <daniel@ffwll.ch>, <deller@gmx.de>,
        <sam@ravnborg.org>, <tzimmermann@suse.de>,
        <geert+renesas@glider.be>,
        <syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com>
Subject: [PATCH] fbcon: Fix memleak when fbcon_set_font() fails
Date:   Mon, 5 Dec 2022 16:49:59 +0800
Message-ID: <20221205084959.147904-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzkaller reported a memleak:
https://syzkaller.appspot.com/bug?id=7cc8bce62e201c60e36ef0133dab7f6b8afbc626

BUG: memory leak
unreferenced object 0xffff888111648000 (size 18448):
  backtrace:
    [<ffffffff8250c359>] kmalloc
    [<ffffffff8250c359>] fbcon_set_font+0x1a9/0x470
    [<ffffffff8262cd59>] con_font_set
    [<ffffffff8262cd59>] con_font_op+0x3a9/0x600
    ...

It's because when fbcon_do_set_font() fails in fbcon_set_font(), it
return error directly and doesn't free allocated memory 'new_data'.

Reported-by: syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 drivers/video/fbdev/core/fbcon.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index c0143d38df83..edb01d200b5b 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2480,7 +2480,7 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font,
 	int w = font->width;
 	int h = font->height;
 	int size;
-	int i, csum;
+	int i, csum, ret;
 	u8 *new_data, *data = font->data;
 	int pitch = PITCH(font->width);
 
@@ -2539,7 +2539,11 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font,
 			break;
 		}
 	}
-	return fbcon_do_set_font(vc, font->width, font->height, charcount, new_data, 1);
+
+	ret = fbcon_do_set_font(vc, font->width, font->height, charcount, new_data, 1);
+	if (ret && i > last_fb_vc)
+		kfree(new_data - FONT_EXTRA_WORDS * sizeof(int));
+	return ret;
 }
 
 static int fbcon_set_def_font(struct vc_data *vc, struct console_font *font, char *name)
-- 
2.17.1

