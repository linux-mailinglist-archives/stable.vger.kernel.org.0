Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7B9627F65
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237554AbiKNM6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237610AbiKNM6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:58:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE8411A3D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04178CE0FEE
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93D5C433D6;
        Mon, 14 Nov 2022 12:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430724;
        bh=dNQfRiqTqqFK6rGFyhBXQa9aLwkqh/0KfhUx3q3zvmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx8VU9VKyqgw40MCAeioW9VolLumtgyTUu+5vC3eY8MBcogRnb5qlEQ77zMF4WkIx
         qs2kF/Sqs55dTST5/v+jYuCq6L/xJbeWdwjYVE53xZlwIJ6WVbDqq+8Ossi9uOXOTQ
         kCbTQk2K+zW7e4XQ4PjkU86VcoF+xleamkXjHJ74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 112/131] can: j1939: j1939_send_one(): fix missing CAN header initialization
Date:   Mon, 14 Nov 2022 13:46:21 +0100
Message-Id: <20221114124453.447149229@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

commit 3eb3d283e8579a22b81dd2ac3987b77465b2a22f upstream.

The read access to struct canxl_frame::len inside of a j1939 created
skbuff revealed a missing initialization of reserved and later filled
elements in struct can_frame.

This patch initializes the 8 byte CAN header with zero.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/linux-can/20221104052235.GA6474@pengutronix.de
Reported-by: syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20221104075000.105414-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -332,6 +332,9 @@ int j1939_send_one(struct j1939_priv *pr
 	/* re-claim the CAN_HDR from the SKB */
 	cf = skb_push(skb, J1939_CAN_HDR);
 
+	/* initialize header structure */
+	memset(cf, 0, J1939_CAN_HDR);
+
 	/* make it a full can frame again */
 	skb_put(skb, J1939_CAN_FTR + (8 - dlc));
 


