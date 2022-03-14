Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED9F4D81D1
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbiCNL5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239835AbiCNL45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:56:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CACEDF8F;
        Mon, 14 Mar 2022 04:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C426EB80DE3;
        Mon, 14 Mar 2022 11:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DE1C340ED;
        Mon, 14 Mar 2022 11:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647258943;
        bh=YMYnOjNNfhNjUlC61X8qNNM2OgJ0OqDWeEDZ4qw2yJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjicIDP2evSBAD7a9eOVzznArgu3Mfq40MSfG0spC/ZfdFPxRjRKZvLetehzW6JTS
         hiLWY2jOiPBrumUME0wkTUgXcuo+mKoGhn7WyR1XGbO61/tNfnoXDNIoXsDuFFMh9e
         Wu5qkKbn92s6WbIeSei24iM8RRIinGtf3aZiJyLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
Subject: [PATCH 5.4 14/43] NFC: port100: fix use-after-free in port100_send_complete
Date:   Mon, 14 Mar 2022 12:53:25 +0100
Message-Id: <20220314112734.818860137@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit f80cfe2f26581f188429c12bd937eb905ad3ac7b ]

Syzbot reported UAF in port100_send_complete(). The root case is in
missing usb_kill_urb() calls on error handling path of ->probe function.

port100_send_complete() accesses devm allocated memory which will be
freed on probe failure. We should kill this urbs before returning an
error from probe function to prevent reported use-after-free

Fail log:

BUG: KASAN: use-after-free in port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
Read of size 1 at addr ffff88801bb59540 by task ksoftirqd/2/26
...
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1670

...

Allocated by task 1255:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
 alloc_dr drivers/base/devres.c:116 [inline]
 devm_kmalloc+0x96/0x1d0 drivers/base/devres.c:823
 devm_kzalloc include/linux/device.h:209 [inline]
 port100_probe+0x8a/0x1320 drivers/nfc/port100.c:1502

Freed by task 1255:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0xff/0x140 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 __cache_free mm/slab.c:3437 [inline]
 kfree+0xf8/0x2b0 mm/slab.c:3794
 release_nodes+0x112/0x1a0 drivers/base/devres.c:501
 devres_release_all+0x114/0x190 drivers/base/devres.c:530
 really_probe+0x626/0xcc0 drivers/base/dd.c:670

Reported-and-tested-by: syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
Fixes: 0347a6ab300a ("NFC: port100: Commands mechanism implementation")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20220308185007.6987-1-paskripkin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/port100.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 1caebefb25ff..2ae1474faede 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1609,7 +1609,9 @@ static int port100_probe(struct usb_interface *interface,
 	nfc_digital_free_device(dev->nfc_digital_dev);
 
 error:
+	usb_kill_urb(dev->in_urb);
 	usb_free_urb(dev->in_urb);
+	usb_kill_urb(dev->out_urb);
 	usb_free_urb(dev->out_urb);
 	usb_put_dev(dev->udev);
 
-- 
2.34.1



