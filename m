Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B65EA461
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbiIZLpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbiIZLoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:44:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E03B72844;
        Mon, 26 Sep 2022 03:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D2B0B8085B;
        Mon, 26 Sep 2022 10:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97706C433C1;
        Mon, 26 Sep 2022 10:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189186;
        bh=UwzIwLl/LbNa756QIwWB/0/t/ekD+jEtKmOLe+CjEkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v25K6Bi+26tWMVllpmVpUcyYE3PymCUnTlPwjGSnwMfHiGcAYh/qwEI/bE+37K+Iv
         4rQgEW5yTON5JoBQ6zchQInie4RkTtLa3wnLoPYzZisjapD3sQjc8Mk5BPVHzS5Hq3
         1LELy/XbJUiqclHqGvX5IszLhA0/WIhU+kr4+F5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shigeru Yoshida <syoshida@redhat.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 070/207] batman-adv: Fix hang up with small MTU hard-interface
Date:   Mon, 26 Sep 2022 12:10:59 +0200
Message-Id: <20220926100809.727360886@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit b1cb8a71f1eaec4eb77051590f7f561f25b15e32 ]

The system hangs up when batman-adv soft-interface is created on
hard-interface with small MTU.  For example, the following commands
create batman-adv soft-interface on dummy interface with zero MTU:

  # ip link add name dummy0 type dummy
  # ip link set mtu 0 dev dummy0
  # ip link set up dev dummy0
  # ip link add name bat0 type batadv
  # ip link set dev dummy0 master bat0

These commands cause the system hang up with the following messages:

  [   90.578925][ T6689] batman_adv: bat0: Adding interface: dummy0
  [   90.580884][ T6689] batman_adv: bat0: The MTU of interface dummy0 is too small (0) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
  [   90.586264][ T6689] batman_adv: bat0: Interface activated: dummy0
  [   90.590061][ T6689] batman_adv: bat0: Forced to purge local tt entries to fit new maximum fragment MTU (-320)
  [   90.595517][ T6689] batman_adv: bat0: Forced to purge local tt entries to fit new maximum fragment MTU (-320)
  [   90.598499][ T6689] batman_adv: bat0: Forced to purge local tt entries to fit new maximum fragment MTU (-320)

This patch fixes this issue by returning error when enabling
hard-interface with small MTU size.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/hard-interface.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index b8f8da7ee3de..41c1ad33d009 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -10,6 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
 #include <linux/container_of.h>
+#include <linux/errno.h>
 #include <linux/gfp.h>
 #include <linux/if.h>
 #include <linux/if_arp.h>
@@ -700,6 +701,9 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 	int max_header_len = batadv_max_header_len();
 	int ret;
 
+	if (hard_iface->net_dev->mtu < ETH_MIN_MTU + max_header_len)
+		return -EINVAL;
+
 	if (hard_iface->if_status != BATADV_IF_NOT_IN_USE)
 		goto out;
 
-- 
2.35.1



