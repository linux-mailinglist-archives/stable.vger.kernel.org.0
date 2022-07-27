Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB07583069
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242625AbiG0Rhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242349AbiG0RhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:37:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F939643C;
        Wed, 27 Jul 2022 09:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A387061617;
        Wed, 27 Jul 2022 16:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1E9C433D6;
        Wed, 27 Jul 2022 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940601;
        bh=WdxCw2olUIbPbEhWpLrHE/nPCFE4jkTx5PM6zSS/rEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyyc0rPsb4Z5PO1vFqtmx6wbhb5ZG1bXNmEPcItDduz7LmV+ool4y+kPfw9KMAq9y
         3ZOXJTeYTf4eAl8iWKbrCA3iFeMTIHJzed0wh5i+0sCk59R5OGVO4UlUXCp4LARchC
         MqRlcLdpkHe1yxCdWjVMlK0pF+zRE2cKmcMiPW3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 064/158] igmp: Fix data-races around sysctl_igmp_max_msf.
Date:   Wed, 27 Jul 2022 18:12:08 +0200
Message-Id: <20220727161024.071332877@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 6ae0f2e553737b8cce49a1372573c81130ffa80e ]

While reading sysctl_igmp_max_msf, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c        | 2 +-
 net/ipv4/ip_sockglue.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index d07d290bf0b9..655d2ab946e0 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2384,7 +2384,7 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 	}
 	/* else, add a new source to the filter */
 
-	if (psl && psl->sl_count >= net->ipv4.sysctl_igmp_max_msf) {
+	if (psl && psl->sl_count >= READ_ONCE(net->ipv4.sysctl_igmp_max_msf)) {
 		err = -ENOBUFS;
 		goto done;
 	}
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index d497d525dea3..a8a323ecbb54 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -782,7 +782,7 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
 	err = -ENOBUFS;
 	if (gsf->gf_numsrc >= 0x1ffffff ||
-	    gsf->gf_numsrc > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+	    gsf->gf_numsrc > READ_ONCE(sock_net(sk)->ipv4.sysctl_igmp_max_msf))
 		goto out_free_gsf;
 
 	err = -EINVAL;
@@ -832,7 +832,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
 	err = -ENOBUFS;
-	if (n > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+	if (n > READ_ONCE(sock_net(sk)->ipv4.sysctl_igmp_max_msf))
 		goto out_free_gsf;
 	err = set_mcast_msfilter(sk, gf32->gf_interface, n, gf32->gf_fmode,
 				 &gf32->gf_group, gf32->gf_slist_flex);
@@ -1244,7 +1244,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		}
 		/* numsrc >= (1G-4) overflow in 32 bits */
 		if (msf->imsf_numsrc >= 0x3ffffffcU ||
-		    msf->imsf_numsrc > net->ipv4.sysctl_igmp_max_msf) {
+		    msf->imsf_numsrc > READ_ONCE(net->ipv4.sysctl_igmp_max_msf)) {
 			kfree(msf);
 			err = -ENOBUFS;
 			break;
-- 
2.35.1



