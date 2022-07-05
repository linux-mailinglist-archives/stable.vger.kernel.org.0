Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFFD566BE9
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiGEMKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiGEMIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5540CEC;
        Tue,  5 Jul 2022 05:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40A4E61967;
        Tue,  5 Jul 2022 12:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40095C341C7;
        Tue,  5 Jul 2022 12:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022921;
        bh=4Enehw5wGC95sMNR+U+t4HM8jXp329nqCaZZ6QrRrSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsRjIKMC3Zem2/fc5GqmyVic5li8Usmf9zCga/lf3bjf8IZrdchW8GfzLeIHqRdO+
         6PzI8RFYWMJyGHP7Bxbm9jZ1caqzQmMYQFPOGkleFFl68zIFxAyAUR6veGIHOIvbuY
         lbqYN8lyaJJWDDs2cjq0uj1rLl+tQ9KGI+kM/o/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, katrinzhou <katrinzhou@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 58/84] ipv6/sit: fix ipip6_tunnel_get_prl return value
Date:   Tue,  5 Jul 2022 13:58:21 +0200
Message-Id: <20220705115617.016648134@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: katrinzhou <katrinzhou@tencent.com>

[ Upstream commit adabdd8f6acabc0c3fdbba2e7f5a2edd9c5ef22d ]

When kcalloc fails, ipip6_tunnel_get_prl() should return -ENOMEM.
Move the position of label "out" to return correctly.

Addresses-Coverity: ("Unused value")
Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
Signed-off-by: katrinzhou <katrinzhou@tencent.com>
Reviewed-by: Eric Dumazet<edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220628035030.1039171-1-zys.zljxml@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 0be82586ce32..3c92e8cacbba 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -321,8 +321,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
 	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
@@ -338,7 +336,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 		}
 	}
 
-	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -350,7 +348,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 		if (kprl.addr != htonl(INADDR_ANY))
 			break;
 	}
-out:
+
 	rcu_read_unlock();
 
 	len = sizeof(*kp) * c;
@@ -359,7 +357,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 		ret = -EFAULT;
 
 	kfree(kp);
-
+out:
 	return ret;
 }
 
-- 
2.35.1



