Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4B7566ACF
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiGEMCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiGEMBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:01:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408701835F;
        Tue,  5 Jul 2022 05:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2879B817D3;
        Tue,  5 Jul 2022 12:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5A9C36AE3;
        Tue,  5 Jul 2022 12:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022480;
        bh=FnF83P0Me1TTViQOm7a/P8GEvR4lEBNIGtf5qJLmVJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkvKMPcU+7u83dyBUR+GG6Fv5byeba0LX9cZgjCtUp2YjmXW4VmkL2q0Bdn89OQ01
         P41ySJLYWEVDmbBbhhb6asLbUtprG0v6gSlhd1g0OOONwIU651PBdSJRYdN6OnhhXR
         ekVvykQWmgp05oQ+uYbboKw24ttQsRI22SwSc2J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, katrinzhou <katrinzhou@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 21/29] ipv6/sit: fix ipip6_tunnel_get_prl return value
Date:   Tue,  5 Jul 2022 13:58:09 +0200
Message-Id: <20220705115606.969644195@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
References: <20220705115606.333669144@linuxfoundation.org>
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

commit adabdd8f6acabc0c3fdbba2e7f5a2edd9c5ef22d upstream.

When kcalloc fails, ipip6_tunnel_get_prl() should return -ENOMEM.
Move the position of label "out" to return correctly.

Addresses-Coverity: ("Unused value")
Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
Signed-off-by: katrinzhou <katrinzhou@tencent.com>
Reviewed-by: Eric Dumazet<edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220628035030.1039171-1-zys.zljxml@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -308,8 +308,6 @@ static int ipip6_tunnel_get_prl(struct i
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
 	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
@@ -325,7 +323,7 @@ static int ipip6_tunnel_get_prl(struct i
 		}
 	}
 
-	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -337,7 +335,7 @@ static int ipip6_tunnel_get_prl(struct i
 		if (kprl.addr != htonl(INADDR_ANY))
 			break;
 	}
-out:
+
 	rcu_read_unlock();
 
 	len = sizeof(*kp) * c;
@@ -346,7 +344,7 @@ out:
 		ret = -EFAULT;
 
 	kfree(kp);
-
+out:
 	return ret;
 }
 


