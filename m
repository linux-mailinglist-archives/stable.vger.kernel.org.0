Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32250565751
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiGDNcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbiGDNcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:32:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CD511474
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0FD261548
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E809DC341C7;
        Mon,  4 Jul 2022 13:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656941391;
        bh=veJLiPLbZ+9/VTi14sMmQA1olVlBV+7u+lBAp59h6ww=;
        h=Subject:To:Cc:From:Date:From;
        b=r0d6BY0jAbCOdlbpT3B/6C7uRUeHe5ulKc2bqqIoJbr10AZZ/p5x5PpaB1fOgTrlw
         6QbBkdfe/TkpElbTjkkQvh5G6aNvj104JitpteQqCehS/JY9Rf/UvyCWISH2Sz8bGN
         Mp3bYyJln9IY7T1biZyI7THktMyr+VdthiLMzKBQ=
Subject: FAILED: patch "[PATCH] ipv6/sit: fix ipip6_tunnel_get_prl return value" failed to apply to 4.14-stable tree
To:     katrinzhou@tencent.com, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 15:29:38 +0200
Message-ID: <1656941378166222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From adabdd8f6acabc0c3fdbba2e7f5a2edd9c5ef22d Mon Sep 17 00:00:00 2001
From: katrinzhou <katrinzhou@tencent.com>
Date: Tue, 28 Jun 2022 11:50:30 +0800
Subject: [PATCH] ipv6/sit: fix ipip6_tunnel_get_prl return value

When kcalloc fails, ipip6_tunnel_get_prl() should return -ENOMEM.
Move the position of label "out" to return correctly.

Addresses-Coverity: ("Unused value")
Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
Signed-off-by: katrinzhou <katrinzhou@tencent.com>
Reviewed-by: Eric Dumazet<edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220628035030.1039171-1-zys.zljxml@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index c0b138c20992..6bcd5e419a08 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
 	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
@@ -341,7 +339,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		}
 	}
 
-	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -353,7 +351,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		if (kprl.addr != htonl(INADDR_ANY))
 			break;
 	}
-out:
+
 	rcu_read_unlock();
 
 	len = sizeof(*kp) * c;
@@ -362,7 +360,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		ret = -EFAULT;
 
 	kfree(kp);
-
+out:
 	return ret;
 }
 

