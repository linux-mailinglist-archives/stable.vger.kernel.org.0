Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63883664941
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbjAJSTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239204AbjAJSTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:19:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7935558D30
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3FB961870
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9070C433EF;
        Tue, 10 Jan 2023 18:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374623;
        bh=YK/0UUlaxphr6J3a2Ao81kULz1wlUs1AxQF+lzCbuto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Slgw5DZ/JCFVYV5G5dkzwP9YdTZGzIhtQCsRMuaxNyuYdzRE0PeNLuDT+1COUpPmv
         Hn5oUuxAKRw2IjVB7YqRQKVfLJCBlIIRJo4+ns7Loc9X9oEyEzDVZNT5JPV82QC8ge
         cUlUm0lvZ9u0QjZafEznf0rrJ+FgV73JUdIwjdAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/159] selftests: net: fix cleanup_v6() for arp_ndisc_evict_nocarrier
Date:   Tue, 10 Jan 2023 19:03:46 +0100
Message-Id: <20230110180020.796803376@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 9c4d7f45d60745a1cea0e841fa5e3444c398d2f1 ]

The cleanup_v6() will cause the arp_ndisc_evict_nocarrier script exit
with 255 (No such file or directory), even the tests are good:

 # selftests: net: arp_ndisc_evict_nocarrier.sh
 # run arp_evict_nocarrier=1 test
 # RTNETLINK answers: File exists
 # ok
 # run arp_evict_nocarrier=0 test
 # RTNETLINK answers: File exists
 # ok
 # run all.arp_evict_nocarrier=0 test
 # RTNETLINK answers: File exists
 # ok
 # run ndisc_evict_nocarrier=1 test
 # ok
 # run ndisc_evict_nocarrier=0 test
 # ok
 # run all.ndisc_evict_nocarrier=0 test
 # ok
 not ok 1 selftests: net: arp_ndisc_evict_nocarrier.sh # exit=255

This is because it's trying to modify the parameter for ipv4 instead.

Also, tests for ipv6 (run_ndisc_evict_nocarrier_enabled() and
run_ndisc_evict_nocarrier_disabled() are working on veth1, reflect
this fact in cleanup_v6().

Fixes: f86ca07eb531 ("selftests: net: add arp_ndisc_evict_nocarrier")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
index b5af08af8559..b4ec1eeee6c9 100755
--- a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
+++ b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
@@ -24,8 +24,8 @@ cleanup_v6()
     ip netns del me
     ip netns del peer
 
-    sysctl -w net.ipv4.conf.veth0.ndisc_evict_nocarrier=1 >/dev/null 2>&1
-    sysctl -w net.ipv4.conf.all.ndisc_evict_nocarrier=1 >/dev/null 2>&1
+    sysctl -w net.ipv6.conf.veth1.ndisc_evict_nocarrier=1 >/dev/null 2>&1
+    sysctl -w net.ipv6.conf.all.ndisc_evict_nocarrier=1 >/dev/null 2>&1
 }
 
 create_ns()
-- 
2.35.1



