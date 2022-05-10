Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C4B521ADE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242802AbiEJOEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243931AbiEJOAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:00:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FF037015;
        Tue, 10 May 2022 06:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC6B5B81DB8;
        Tue, 10 May 2022 13:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30088C385A6;
        Tue, 10 May 2022 13:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189996;
        bh=P7kj9ewvd1CowtM7h8+FySFHobYb6HPBwxgsuhHBZXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtKjPZeH3g3IouuNME4/as/j3AP9MNk15catm0pNZMgt6P6n2sJw5c+Xq2G8U5h5s
         EdJLOr3B9QN9aLJQWfJsK6cqVtTCdsiVVSBJ/ixmKlr4lDWAqRrOkZ65tH2Gg26/sk
         7MtVHiazhJPMJwYwYYJ3DV84x+2XhE0dgU3wsvIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.17 096/140] mld: respect RCU rules in ip6_mc_source() and ip6_mc_msfilter()
Date:   Tue, 10 May 2022 15:08:06 +0200
Message-Id: <20220510130744.352198061@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit a9384a4c1d250cb40cebf50e41459426d160b08e upstream.

Whenever RCU protected list replaces an object,
the pointer to the new object needs to be updated
_before_ the call to kfree_rcu() or call_rcu()

Also ip6_mc_msfilter() needs to update the pointer
before releasing the mc_lock mutex.

Note that linux-5.13 was supporting kfree_rcu(NULL, rcu),
so this fix does not need the conditional test I was
forced to use in the equivalent patch for IPv4.

Fixes: 882ba1f73c06 ("mld: convert ipv6_mc_socklist->sflist to RCU")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mcast.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -460,10 +460,10 @@ int ip6_mc_source(int add, int omode, st
 				newpsl->sl_addr[i] = psl->sl_addr[i];
 			atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
 				   &sk->sk_omem_alloc);
-			kfree_rcu(psl, rcu);
 		}
+		rcu_assign_pointer(pmc->sflist, newpsl);
+		kfree_rcu(psl, rcu);
 		psl = newpsl;
-		rcu_assign_pointer(pmc->sflist, psl);
 	}
 	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
 	for (i = 0; i < psl->sl_count; i++) {
@@ -565,12 +565,12 @@ int ip6_mc_msfilter(struct sock *sk, str
 			       psl->sl_count, psl->sl_addr, 0);
 		atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
 			   &sk->sk_omem_alloc);
-		kfree_rcu(psl, rcu);
 	} else {
 		ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
 	}
-	mutex_unlock(&idev->mc_lock);
 	rcu_assign_pointer(pmc->sflist, newpsl);
+	mutex_unlock(&idev->mc_lock);
+	kfree_rcu(psl, rcu);
 	pmc->sfmode = gsf->gf_fmode;
 	err = 0;
 done:


