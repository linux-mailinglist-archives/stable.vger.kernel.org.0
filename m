Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844566433FA
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiLETlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiLETku (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D51C26113
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:38:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 538FFB81157
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4E3C433D7;
        Mon,  5 Dec 2022 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269100;
        bh=uTDg7YtXDbWEuM4Be5wIs5Io+dHomryNNX79hA1hcOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq/2iyiNJdGXykpbtJyzCxIDLWlAQGD7SH5dOusYJlDNJoB87ohPglSRpPjG80Lap
         jBeQCzUPvv3oQyM+Tt3/F8UvEF0+kB2FvNseEWA/ItpeQ677ssub5dM/KAaC5olivH
         RQ/H5Dm4U86ZZTlmOAj38P4QEy+xL6UXgjJ6HeGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/120] selftests: net: fix nexthop warning cleanup double ip typo
Date:   Mon,  5 Dec 2022 20:10:48 +0100
Message-Id: <20221205190809.780614248@linuxfoundation.org>
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

[ Upstream commit 692930cc435099580a4b9e32fa781b0688c18439 ]

I made a stupid typo when adding the nexthop route warning selftest and
added both $IP and ip after it (double ip) on the cleanup path. The
error doesn't show up when running the test, but obviously it doesn't
cleanup properly after it.

Fixes: 392baa339c6a ("selftests: net: add delete nexthop route warning test")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d5082d386eee ("ipv4: Fix route deletion when nexthop info is not specified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_nexthops.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index d1257a321ced..4afc4b20c546 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1157,8 +1157,8 @@ ipv4_fcnal()
 	[ $out1 -eq $out2 ]
 	rc=$?
 	log_test $rc 0 "Delete nexthop route warning"
-	run_cmd "$IP ip route delete 172.16.101.1/32 nhid 12"
-	run_cmd "$IP ip nexthop del id 12"
+	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
+	run_cmd "$IP nexthop del id 12"
 }
 
 ipv4_grp_fcnal()
-- 
2.35.1



