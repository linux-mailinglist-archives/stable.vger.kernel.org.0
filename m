Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07AD69CEAB
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbjBTOBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjBTOBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1AD1F49E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94D49B80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD77C433D2;
        Mon, 20 Feb 2023 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901629;
        bh=QYOMXxW6MI0jTvO1e9bAtG5DCvXWueu5rx02ZljLFUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFPHpQxEkISrHqCkrCkNyJh+iIo9HRZZRMt+zQEKPrJ5NAOf0h8ElRHlHRVWkwbSH
         hNZp3dEefliVCfGFL+q+uN5FQzxqOEPEhHDjtES46c4a6B6EdNOhZVrlqL+bDAw5E9
         8K5oRU+l3wS6JK7TvaCDeqH66xkeNC0ryzGOmRig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miko Larsson <mikoxyzzz@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.com
Subject: [PATCH 6.1 090/118] net/usb: kalmia: Dont pass act_len in usb_bulk_msg error path
Date:   Mon, 20 Feb 2023 14:36:46 +0100
Message-Id: <20230220133603.996543754@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
@@ -65,8 +65,8 @@ kalmia_send_init_packet(struct usbnet *d
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
@@ -83,8 +83,8 @@ kalmia_send_init_packet(struct usbnet *d
 
 	if (status != 0)
 		netdev_err(dev->net,
-			"Error receiving init result. Status %i, length %i\n",
-			status, act_len);
+			"Error receiving init result. Status %i\n",
+			status);
 	else if (act_len != expected_len)
 		netdev_err(dev->net, "Unexpected init result length: %i\n",
 			act_len);


