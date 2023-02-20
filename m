Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3FC69CC56
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjBTNjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjBTNjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:39:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432811C330
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D66A360E9E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E813BC433EF;
        Mon, 20 Feb 2023 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900351;
        bh=x/C2/aEnXLov8gi5+SSH/+uIM06q0NoA3tH4t1jt48w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXuA4arQ2oaaaoHRvyBL6EcfgGZgyeqa/vukvSRTs5LxJiMSFNvYUJJJEcIc1zq5w
         dBhVMXJBuf9rcdZawiIFKJvX8q5i8sPL+2b42EphNCjfmlbkICgVPI68dWSbFzf9IO
         qBzgASBVJyZGsD9U8dWiWA22m1qyLVoXHhCeEb8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miko Larsson <mikoxyzzz@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.com
Subject: [PATCH 4.14 46/53] net/usb: kalmia: Dont pass act_len in usb_bulk_msg error path
Date:   Mon, 20 Feb 2023 14:36:12 +0100
Message-Id: <20230220133549.815747228@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miko Larsson <mikoxyzzz@gmail.com>

commit c68f345b7c425b38656e1791a0486769a8797016 upstream.

syzbot reported that act_len in kalmia_send_init_packet() is
uninitialized when passing it to the first usb_bulk_msg error path. Jiri
Pirko noted that it's pointless to pass it in the error path, and that
the value that would be printed in the second error path would be the
value of act_len from the first call to usb_bulk_msg.[1]

With this in mind, let's just not pass act_len to the usb_bulk_msg error
paths.

1: https://lore.kernel.org/lkml/Y9pY61y1nwTuzMOa@nanopsycho/

Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B3730")
Reported-and-tested-by: syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.com
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/kalmia.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -69,8 +69,8 @@ kalmia_send_init_packet(struct usbnet *d
 		init_msg, init_msg_len, &act_len, KALMIA_USB_TIMEOUT);
 	if (status != 0) {
 		netdev_err(dev->net,
-			"Error sending init packet. Status %i, length %i\n",
-			status, act_len);
+			"Error sending init packet. Status %i\n",
+			status);
 		return status;
 	}
 	else if (act_len != init_msg_len) {
@@ -87,8 +87,8 @@ kalmia_send_init_packet(struct usbnet *d
 
 	if (status != 0)
 		netdev_err(dev->net,
-			"Error receiving init result. Status %i, length %i\n",
-			status, act_len);
+			"Error receiving init result. Status %i\n",
+			status);
 	else if (act_len != expected_len)
 		netdev_err(dev->net, "Unexpected init result length: %i\n",
 			act_len);


