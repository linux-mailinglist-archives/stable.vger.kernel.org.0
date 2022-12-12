Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9735464A0BA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiLLN3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiLLN3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:29:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560915FDC
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:29:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0758CB80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1F1C433D2;
        Mon, 12 Dec 2022 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851767;
        bh=bjKzL0ABmnz7AqXAK9DkHcuh9Yodcz4M6I1m/3Xyyj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaQ0n5Lp1uC1gK/8ZC6G+3qLtWjqP5QR3p9EUBwxdByzAf0xxiPPAXRsM6mi3InXs
         aETDPExDyKLGm6ggyjngpPcTKMdISyN6RW3pqEUr9vpGrP73DxBShmbjOC/rDicwmU
         mdvsXD1RptXiQA81SvjVPk/Rsxz0KA0ldIUXE/eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com,
        Wei Chen <harperchen1110@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 058/123] can: af_can: fix NULL pointer dereference in can_rcv_filter
Date:   Mon, 12 Dec 2022 14:17:04 +0100
Message-Id: <20221212130929.364766608@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 0acc442309a0a1b01bcdaa135e56e6398a49439c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/af_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -680,7 +680,7 @@ static int can_rcv(struct sk_buff *skb,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
@@ -706,7 +706,7 @@ static int canfd_rcv(struct sk_buff *skb
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;


