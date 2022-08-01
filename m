Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6935868DF
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiHALyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbiHALxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:53:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A85BC9C;
        Mon,  1 Aug 2022 04:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76D79B80E8F;
        Mon,  1 Aug 2022 11:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A1EC433D6;
        Mon,  1 Aug 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354616;
        bh=ZgTX1xYORGpaMshMzsAcx77X/gR0/NHi1txnd9buRYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnvTIQBYfn3d9hqOTuzg9UbRzvTV5LTMDySGvXZvdkbiqtjALGKht7vJLd2E66avz
         ubYgo5Yp0jvob17Go4BSv0mJ/KT7h9/k6m9t+NpMCnNzZr1sY4mwkhPOc9yFdnn4kd
         k3GsXjggDNgJftiZzh6VVitb4VT71pNoj4VxRoSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/65] igmp: Fix data-races around sysctl_igmp_qrv.
Date:   Mon,  1 Aug 2022 13:46:41 +0200
Message-Id: <20220801114134.714482596@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
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

[ Upstream commit 8ebcc62c738f68688ee7c6fec2efe5bc6d3d7e60 ]

While reading sysctl_igmp_qrv, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

This test can be packed into a helper, so such changes will be in the
follow-up series after net is merged into net-next.

  qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);

Fixes: a9fe8e29945d ("ipv4: implement igmp_qrv sysctl to tune igmp robustness variable")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 428cc3a4c36f..c71b863093ac 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -827,7 +827,7 @@ static void igmp_ifc_event(struct in_device *in_dev)
 	struct net *net = dev_net(in_dev->dev);
 	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev))
 		return;
-	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv);
+	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv));
 	igmp_ifc_start_timer(in_dev, 1);
 }
 
@@ -1009,7 +1009,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		 * received value was zero, use the default or statically
 		 * configured value.
 		 */
-		in_dev->mr_qrv = ih3->qrv ?: net->ipv4.sysctl_igmp_qrv;
+		in_dev->mr_qrv = ih3->qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		in_dev->mr_qi = IGMPV3_QQIC(ih3->qqic)*HZ ?: IGMP_QUERY_INTERVAL;
 
 		/* RFC3376, 8.3. Query Response Interval:
@@ -1189,7 +1189,7 @@ static void igmpv3_add_delrec(struct in_device *in_dev, struct ip_mc_list *im,
 	pmc->interface = im->interface;
 	in_dev_hold(in_dev);
 	pmc->multiaddr = im->multiaddr;
-	pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+	pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 	pmc->sfmode = im->sfmode;
 	if (pmc->sfmode == MCAST_INCLUDE) {
 		struct ip_sf_list *psf;
@@ -1240,9 +1240,11 @@ static void igmpv3_del_delrec(struct in_device *in_dev, struct ip_mc_list *im)
 			swap(im->tomb, pmc->tomb);
 			swap(im->sources, pmc->sources);
 			for (psf = im->sources; psf; psf = psf->sf_next)
-				psf->sf_crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+				psf->sf_crcount = in_dev->mr_qrv ?:
+					READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		} else {
-			im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+			im->crcount = in_dev->mr_qrv ?:
+				READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		}
 		in_dev_put(pmc->interface);
 		kfree_pmc(pmc);
@@ -1349,7 +1351,7 @@ static void igmp_group_added(struct ip_mc_list *im)
 	if (in_dev->dead)
 		return;
 
-	im->unsolicit_count = net->ipv4.sysctl_igmp_qrv;
+	im->unsolicit_count = READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev)) {
 		spin_lock_bh(&im->lock);
 		igmp_start_timer(im, IGMP_INITIAL_REPORT_DELAY);
@@ -1363,7 +1365,7 @@ static void igmp_group_added(struct ip_mc_list *im)
 	 * IN() to IN(A).
 	 */
 	if (im->sfmode == MCAST_EXCLUDE)
-		im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		im->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 
 	igmp_ifc_event(in_dev);
 #endif
@@ -1754,7 +1756,7 @@ static void ip_mc_reset(struct in_device *in_dev)
 
 	in_dev->mr_qi = IGMP_QUERY_INTERVAL;
 	in_dev->mr_qri = IGMP_QUERY_RESPONSE_INTERVAL;
-	in_dev->mr_qrv = net->ipv4.sysctl_igmp_qrv;
+	in_dev->mr_qrv = READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 }
 #else
 static void ip_mc_reset(struct in_device *in_dev)
@@ -1888,7 +1890,7 @@ static int ip_mc_del1_src(struct ip_mc_list *pmc, int sfmode,
 #ifdef CONFIG_IP_MULTICAST
 		if (psf->sf_oldin &&
 		    !IGMP_V1_SEEN(in_dev) && !IGMP_V2_SEEN(in_dev)) {
-			psf->sf_crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+			psf->sf_crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 			psf->sf_next = pmc->tomb;
 			pmc->tomb = psf;
 			rv = 1;
@@ -1952,7 +1954,7 @@ static int ip_mc_del_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 		/* filter mode change */
 		pmc->sfmode = MCAST_INCLUDE;
 #ifdef CONFIG_IP_MULTICAST
-		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
@@ -2131,7 +2133,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 #ifdef CONFIG_IP_MULTICAST
 		/* else no filters; keep old mode for reports */
 
-		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
-- 
2.35.1



