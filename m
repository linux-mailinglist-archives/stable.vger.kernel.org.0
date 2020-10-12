Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BEA28B911
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390168AbgJLN5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389356AbgJLNnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:43:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFC5022247;
        Mon, 12 Oct 2020 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510217;
        bh=QLY7Q1tOegNshFUUkswr52kG9HLDZ6VMOE/Uq/ICdE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0TdF+Q3MSzmZ7FSWGrdckJkZZhsngRIhWFK1WlsiO40Po8fGU6bkOrkKkuQr/+tm
         fseZlHv26x5lkwT2NKCl7nWFQcy/H2l2u69WCe7nccLK2w8T/dmEn0Wh82vUGs5x/A
         U+kOolE6epq3d2rUBVnJ7MW2UqpbI+1YPNGA8ch4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 82/85] Input: ati_remote2 - add missing newlines when printing module parameters
Date:   Mon, 12 Oct 2020 15:27:45 +0200
Message-Id: <20201012132636.774955515@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
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

diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 305f0160506a..8a36d78fed63 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -68,7 +68,7 @@ static int ati_remote2_get_channel_mask(char *buffer,
 {
 	pr_debug("%s()\n", __func__);
 
-	return sprintf(buffer, "0x%04x", *(unsigned int *)kp->arg);
+	return sprintf(buffer, "0x%04x\n", *(unsigned int *)kp->arg);
 }
 
 static int ati_remote2_set_mode_mask(const char *val,
@@ -84,7 +84,7 @@ static int ati_remote2_get_mode_mask(char *buffer,
 {
 	pr_debug("%s()\n", __func__);
 
-	return sprintf(buffer, "0x%02x", *(unsigned int *)kp->arg);
+	return sprintf(buffer, "0x%02x\n", *(unsigned int *)kp->arg);
 }
 
 static unsigned int channel_mask = ATI_REMOTE2_MAX_CHANNEL_MASK;


