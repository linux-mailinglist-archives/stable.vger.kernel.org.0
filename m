Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5AC6433F9
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiLETlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiLETkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548CE26114
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:38:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E414B61315
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03538C433D6;
        Mon,  5 Dec 2022 19:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269097;
        bh=TmrH8vevZUR1g+QQkcWHCKkH9Zte7T7ifldSnT+db+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfkCWGkNirXeW7cb+ZSGGukVi4qiSolnqyzxJrzfvTnDLAJQaCkASGK9Bbtv0hecP
         pH6J8AItU69vTbddx9Ufb69rQKO17QQk2b/5w9uIzNp18Zch/SZ0eoSxUzn01TnS7/
         V6LbJxA2CAavDswUMPNK8zYfAXIh8Gxn64Ix5+eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/120] selftests: net: add delete nexthop route warning test
Date:   Mon,  5 Dec 2022 20:10:47 +0100
Message-Id: <20221205190809.753631589@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 392baa339c6a42a2cb088e5e5df2b59b8f89be24 ]

Add a test which causes a WARNING on kernels which treat a
nexthop route like a normal route when comparing for deletion and a
device is specified. That is, a route is found but we hit a warning while
matching it. The warning is from fib_info_nh() in include/net/nexthop.h
because we run it on a fib_info with nexthop object. The call chain is:
 inet_rtm_delroute -> fib_table_delete -> fib_nh_match (called with a
nexthop fib_info and also with fc_oif set thus calling fib_info_nh on
the fib_info and triggering the warning).

Repro steps:
 $ ip nexthop add id 12 via 172.16.1.3 dev veth1
 $ ip route add 172.16.101.1/32 nhid 12
 $ ip route delete 172.16.101.1/32 dev veth1

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d5082d386eee ("ipv4: Fix route deletion when nexthop info is not specified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_nexthops.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index b5a69ad191b0..d1257a321ced 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1145,6 +1145,20 @@ ipv4_fcnal()
 	set +e
 	check_nexthop "dev veth1" ""
 	log_test $? 0 "Nexthops removed on admin down"
+
+	# nexthop route delete warning: route add with nhid and delete
+	# using device
+	run_cmd "$IP li set dev veth1 up"
+	run_cmd "$IP nexthop add id 12 via 172.16.1.3 dev veth1"
+	out1=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	run_cmd "$IP route add 172.16.101.1/32 nhid 12"
+	run_cmd "$IP route delete 172.16.101.1/32 dev veth1"
+	out2=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	[ $out1 -eq $out2 ]
+	rc=$?
+	log_test $rc 0 "Delete nexthop route warning"
+	run_cmd "$IP ip route delete 172.16.101.1/32 nhid 12"
+	run_cmd "$IP ip nexthop del id 12"
 }
 
 ipv4_grp_fcnal()
-- 
2.35.1



