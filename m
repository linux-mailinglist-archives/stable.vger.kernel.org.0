Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512EA64335C
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiLETgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbiLETfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:35:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9572A705
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:31:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3983B61311
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D46BC433C1;
        Mon,  5 Dec 2022 19:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268718;
        bh=hwYidHPCzTgJK51GDBttOt8ki5q0kTNGGRIqxrrJo8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fg6qhi3VranK7Qg+KzGuEakCr2t67tJrXc3SaHLVjGXnb9mjss6Sb0kVi6BBM6FtN
         vGeLGmvag43Ob3tZoM7z8GbRB49D+DMuWTqrrT4RP3nhhxN2G9EegPV7CHvYzjcABp
         ifQ0m3xsSQeAeBuLCvMy95z3TuzLRLPnndNonRk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gwangun Jung <exsociety@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 80/92] ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference
Date:   Mon,  5 Dec 2022 20:10:33 +0100
Message-Id: <20221205190806.120069157@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 61b91eb33a69c3be11b259c5ea484505cd79f883 ]

Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
    fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
    fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
    inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874

Separate nexthop objects are mutually exclusive with the legacy
multipath spec. Fix fib_nh_match to return if the config for the
to be deleted route contains a multipath spec while the fib_info
is using a nexthop object.

Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Fixes: 6bf92d70e690 ("net: ipv4: fix route with nexthop object delete warning")
Reported-by: Gwangun Jung <exsociety@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d5082d386eee ("ipv4: Fix route deletion when nexthop info is not specified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c                    | 8 ++++----
 tools/testing/selftests/net/fib_nexthops.sh | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3824b7abecf7..f62b1739f63b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -887,13 +887,13 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
+	/* cannot match on nexthop object attributes */
+	if (fi->nh)
+		return 1;
+
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
 
-		/* cannot match on nexthop object attributes */
-		if (fi->nh)
-			return 1;
-
 		nh = fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(net, cfg->fc_encap_type,
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 56d90335605d..050c1e0f1b0f 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -945,6 +945,11 @@ ipv4_fcnal()
 	log_test $rc 0 "Delete nexthop route warning"
 	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
 	run_cmd "$IP nexthop del id 12"
+
+	run_cmd "$IP nexthop add id 21 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
+	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
+	log_test $? 2 "Delete multipath route with only nh id based entry"
 }
 
 ipv4_grp_fcnal()
-- 
2.35.1



