Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA063DF55
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiK3SqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiK3Spz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:45:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3446E900E5
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:45:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C7D61D70
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9159C433D6;
        Wed, 30 Nov 2022 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833949;
        bh=dFKG4d4GyPk4MtCSrEG1TjKp8KZ+TzLZS0mbkwVpKNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlxL/RQVDUmxysqU8Dm+kzJj3UQT+zIYClvIc9G+mhfYdovI95PujXGdRb9Sk2JBT
         trg6gh1gpRQ0PM/lq4zpqshwmPWoMPSxJHgGY77gQ6Npeckf9cXAbRxkvAOpE8tuwe
         bCeafA44aVjyEOqxlRQp8rnL2ZwCdkpKKw2V95Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 073/289] selftests: mptcp: fix mibit vs mbit mix up
Date:   Wed, 30 Nov 2022 19:20:58 +0100
Message-Id: <20221130180545.796202217@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 3de88b95c4d436d78afc0266a0bed76c35ddeb62 ]

The estimated time was supposing the rate was expressed in mibit
(bit * 1024^2) but it is in mbit (bit * 1000^2).

This makes the threshold higher but in a more realistic way to avoid
false positives reported by CI instances.

Before this patch, the thresholds were at 7561/4005ms and now they are
at 7906/4178ms.

While at it, also fix a typo in the linked comment, spotted by Mat.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/310
Fixes: 1a418cb8e888 ("mptcp: simult flow self-tests")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index ffa13a957a36..40aeb5a71a2a 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -247,9 +247,10 @@ run_test()
 	tc -n $ns2 qdisc add dev ns2eth1 root netem rate ${rate1}mbit $delay1
 	tc -n $ns2 qdisc add dev ns2eth2 root netem rate ${rate2}mbit $delay2
 
-	# time is measured in ms, account for transfer size, affegated link speed
+	# time is measured in ms, account for transfer size, aggregated link speed
 	# and header overhead (10%)
-	local time=$((size * 8 * 1000 * 10 / (( $rate1 + $rate2) * 1024 *1024 * 9) ))
+	#              ms    byte -> bit   10%        mbit      -> kbit -> bit  10%
+	local time=$((1000 * size  *  8  * 10 / ((rate1 + rate2) * 1000 * 1000 * 9) ))
 
 	# mptcp_connect will do some sleeps to allow the mp_join handshake
 	# completion (see mptcp_connect): 200ms on each side, add some slack
-- 
2.35.1



