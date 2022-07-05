Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFED6566E01
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiGEMa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237680AbiGEMZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F89D63;
        Tue,  5 Jul 2022 05:18:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0072CE1B22;
        Tue,  5 Jul 2022 12:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4E8C341C7;
        Tue,  5 Jul 2022 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023491;
        bh=gJPHiYJw2eD9q/XdjDFanrKWV7ZlkQz5rUWrohNBK+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lG3w1PXaVRCraj3hDfUN9UZ6LNbsW1jZC54Ja/exrZnsVCAZktB1/SzLC+YLZ04JZ
         y75pttEMRuG1UMmf+njrHWBBN4mr8pFNaM2KKo0IXvDm+YP9uCL/bDzJyNtoXoef4k
         avecZjzNhWXr2NKSg6JkJDo0Wr57PnsPmrldSuHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, katrinzhou <katrinzhou@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 077/102] ipv6/sit: fix ipip6_tunnel_get_prl return value
Date:   Tue,  5 Jul 2022 13:58:43 +0200
Message-Id: <20220705115620.595403664@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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
@@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct n
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
 	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
@@ -341,7 +339,7 @@ static int ipip6_tunnel_get_prl(struct n
 		}
 	}
 
-	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -353,7 +351,7 @@ static int ipip6_tunnel_get_prl(struct n
 		if (kprl.addr != htonl(INADDR_ANY))
 			break;
 	}
-out:
+
 	rcu_read_unlock();
 
 	len = sizeof(*kp) * c;
@@ -362,7 +360,7 @@ out:
 		ret = -EFAULT;
 
 	kfree(kp);
-
+out:
 	return ret;
 }
 


