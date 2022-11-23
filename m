Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518E763549E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiKWJJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiKWJIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:08:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899021025ED
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54C9461B10
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE2C433D6;
        Wed, 23 Nov 2022 09:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194526;
        bh=T/e3MNvNW8CQmNRDyQI97IB/PJdxQjND73c0YgecIrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+mYWM1Y3cYe9De1/ZrmhT2JOMUJYRtRtN1zfG7XTIgYeEbYgDY1z9koUW3ZiaWb/
         Re1uKME9qeSaY4QVcPQcOXj2Bij15vXDHmDQZj0A9+Tw1CkzQWCBvW6rHTnxfAvOMH
         TBt6wjp8P0MDD9MGM9fa2NsEdLpLr1ddp8wWNx2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 102/114] macvlan: enforce a consistent minimal mtu
Date:   Wed, 23 Nov 2022 09:51:29 +0100
Message-Id: <20221123084555.810110831@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit b64085b00044bdf3cd1c9825e9ef5b2e0feae91a upstream.

macvlan should enforce a minimal mtu of 68, even at link creation.

This patch avoids the current behavior (which could lead to crashes
in ipv6 stack if the link is brought up)

$ ip link add macvlan1 link eno1 mtu 8 type macvlan  # This should fail !
$ ip link sh dev macvlan1
5: macvlan1@eno1: <BROADCAST,MULTICAST> mtu 8 qdisc noop
    state DOWN mode DEFAULT group default qlen 1000
    link/ether 02:47:6c:24:74:82 brd ff:ff:ff:ff:ff:ff
$ ip link set macvlan1 mtu 67
Error: mtu less than device minimum.
$ ip link set macvlan1 mtu 68
$ ip link set macvlan1 mtu 8
Error: mtu less than device minimum.

Fixes: 91572088e3fd ("net: use core MTU range checking in core net infra")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1137,7 +1137,7 @@ void macvlan_common_setup(struct net_dev
 {
 	ether_setup(dev);
 
-	dev->min_mtu		= 0;
+	/* ether_setup() has set dev->min_mtu to ETH_MIN_MTU. */
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);


