Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57412649373
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 10:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLKJxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 04:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLKJxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 04:53:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AEA1180C
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 01:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9874FB80915
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 09:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94ECC433EF;
        Sun, 11 Dec 2022 09:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670752412;
        bh=KnYUJyPEVRqIrRTyo5/jP+P/qNe9YGT/Tl0l6oitg80=;
        h=Subject:To:Cc:From:Date:From;
        b=xFS76ASbsuhHWh8e8Nez1CU9myVHTRkiiKH8hwBxPUFXTORSxRWCaLqdcxA6vsUDx
         /uvncg/B/yiHeBvXRBCgPgQonoYIpQdFfSrV/d/pFJ7qIF48+aCDxT4iEllGUhMiEe
         V1jj88Bg5WuIkSbqwWvackuJwscl42LROaznQiuo=
Subject: FAILED: patch "[PATCH] can: af_can: fix NULL pointer dereference in can_rcv_filter" failed to apply to 6.0-stable tree
To:     socketcan@hartkopp.net, harperchen1110@gmail.com,
        mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Dec 2022 10:53:16 +0100
Message-ID: <1670752396189186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0acc442309a0 ("can: af_can: fix NULL pointer dereference in can_rcv_filter")
fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
467ef4c7b9d1 ("can: skb: add skb CAN frame data length helpers")
96a7457a14d9 ("can: skb: unify skb CAN frame identification helpers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0acc442309a0a1b01bcdaa135e56e6398a49439c Mon Sep 17 00:00:00 2001
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 6 Dec 2022 21:12:59 +0100
Subject: [PATCH] can: af_can: fix NULL pointer dereference in can_rcv_filter

Analogue to commit 8aa59e355949 ("can: af_can: fix NULL pointer
dereference in can_rx_register()") we need to check for a missing
initialization of ml_priv in the receive path of CAN frames.

Since commit 4e096a18867a ("net: introduce CAN specific pointer in the
struct net_device") the check for dev->type to be ARPHRD_CAN is not
sufficient anymore since bonding or tun netdevices claim to be CAN
devices but do not initialize ml_priv accordingly.

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Reported-by: syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20221206201259.3028-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 27dcdcc0b808..c69168f11e44 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -677,7 +677,7 @@ static void can_receive(struct sk_buff *skb, struct net_device *dev)
 static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 		   struct packet_type *pt, struct net_device *orig_dev)
 {
-	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_can_skb(skb)))) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || !can_is_can_skb(skb))) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 
@@ -692,7 +692,7 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 		     struct packet_type *pt, struct net_device *orig_dev)
 {
-	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_canfd_skb(skb)))) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || !can_is_canfd_skb(skb))) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 
@@ -707,7 +707,7 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 static int canxl_rcv(struct sk_buff *skb, struct net_device *dev,
 		     struct packet_type *pt, struct net_device *orig_dev)
 {
-	if (unlikely(dev->type != ARPHRD_CAN || (!can_is_canxl_skb(skb)))) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || !can_is_canxl_skb(skb))) {
 		pr_warn_once("PF_CAN: dropped non conform CAN XL skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 

