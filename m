Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5374CF84E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238538AbiCGJwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240577AbiCGJvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:51:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9638E657B5;
        Mon,  7 Mar 2022 01:44:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7607F60F62;
        Mon,  7 Mar 2022 09:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0D8C340F3;
        Mon,  7 Mar 2022 09:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646292;
        bh=+NzAtLObj6uMrptvGTkHCHEAmFeyo5+8E9Db1t+8QB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ly+GesbPd56nSVAIawB0oPXncZYME1Zipc1Kxrn67yCNf+POamLBDDObyZ3mvCBCI
         R8bY2XqnqfWhMUhvi7bRuoMvuwsAV5XfkLlRzRTa+QjAWU4+d4146Oe1yT8OYbxCiv
         gkWebhqyzv+T31HHUot5P+yMz5hFCu/lyCzDcc3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 196/262] selftests: mlxsw: tc_police_scale: Make test more robust
Date:   Mon,  7 Mar 2022 10:19:00 +0100
Message-Id: <20220307091708.140705665@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

commit dc9752075341e7beb653e37c6f4a3723074dc8bc upstream.

The test adds tc filters and checks how many of them were offloaded by
grepping for 'in_hw'.

iproute2 commit f4cd4f127047 ("tc: add skip_hw and skip_sw to control
action offload") added offload indication to tc actions, producing the
following output:

 $ tc filter show dev swp2 ingress
 ...
 filter protocol ipv6 pref 1000 flower chain 0 handle 0x7c0
   eth_type ipv6
   dst_ip 2001:db8:1::7bf
   skip_sw
   in_hw in_hw_count 1
         action order 1:  police 0x7c0 rate 10Mbit burst 100Kb mtu 2Kb action drop overhead 0b
         ref 1 bind 1
         not_in_hw
         used_hw_stats immediate

The current grep expression matches on both 'in_hw' and 'not_in_hw',
resulting in incorrect results.

Fix that by using JSON output instead.

Fixes: 5061e773264b ("selftests: mlxsw: Add scale test for tc-police")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
@@ -60,7 +60,8 @@ __tc_police_test()
 
 	tc_police_rules_create $count $should_fail
 
-	offload_count=$(tc filter show dev $swp1 ingress | grep in_hw | wc -l)
+	offload_count=$(tc -j filter show dev $swp1 ingress |
+			jq "[.[] | select(.options.in_hw == true)] | length")
 	((offload_count == count))
 	check_err_fail $should_fail $? "tc police offload count"
 }


