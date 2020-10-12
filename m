Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D1128B812
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389718AbgJLNtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731955AbgJLNsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59D4E21BE5;
        Mon, 12 Oct 2020 13:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510502;
        bh=Whn8XnJvOHsttyDLbBYWnTyVKBIF5HdEn0aFsAE4mug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Js5KdabllyK/v7ynPHErE7PM3/MdcYDDIih4LbyrWJ4OhZ4PDFgNOoLj3Q3sJ7eKp
         1/VAAdEWxSK7MBY5UY79cG/QgrZaLREul+MkcwK9aMa6Xk32TJZ4mQUdxQwm8g9M9X
         Uh38DJOqoeUoxB60rOEjuadp79WoJtlDKzZZUUDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.8 120/124] Input: ati_remote2 - add missing newlines when printing module parameters
Date:   Mon, 12 Oct 2020 15:32:04 +0200
Message-Id: <20201012133152.663019341@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

commit 37bd9e803daea816f2dc2c8f6dc264097eb3ebd2 upstream.

When I cat some module parameters by sysfs, it displays as follows. It's
better to add a newline for easy reading.

root@syzkaller:~# cat /sys/module/ati_remote2/parameters/mode_mask
0x1froot@syzkaller:~# cat /sys/module/ati_remote2/parameters/channel_mask
0xffffroot@syzkaller:~#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20200720092148.9320-1-wangxiongfeng2@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/misc/ati_remote2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -68,7 +68,7 @@ static int ati_remote2_get_channel_mask(
 {
 	pr_debug("%s()\n", __func__);
 
-	return sprintf(buffer, "0x%04x", *(unsigned int *)kp->arg);
+	return sprintf(buffer, "0x%04x\n", *(unsigned int *)kp->arg);
 }
 
 static int ati_remote2_set_mode_mask(const char *val,
@@ -84,7 +84,7 @@ static int ati_remote2_get_mode_mask(cha
 {
 	pr_debug("%s()\n", __func__);
 
-	return sprintf(buffer, "0x%02x", *(unsigned int *)kp->arg);
+	return sprintf(buffer, "0x%02x\n", *(unsigned int *)kp->arg);
 }
 
 static unsigned int channel_mask = ATI_REMOTE2_MAX_CHANNEL_MASK;


