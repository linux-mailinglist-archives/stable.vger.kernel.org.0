Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF8E4BE4BE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349535AbiBUJ17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349986AbiBUJ1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD62F1EEF9;
        Mon, 21 Feb 2022 01:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2D623CE0E79;
        Mon, 21 Feb 2022 09:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F754C340E9;
        Mon, 21 Feb 2022 09:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434665;
        bh=bN043WedEhBYdSu+Ret7cNF7R/i2stufqlZsoE2K6Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8264EGwY7Otw0s+ZiD2vk71qLcoJDW4np5BXsBeGwg90Oonn/5/0JTsYpiAE/E4y
         FdhccU83DdEW1oY5J2qQj1PIW3B+4GpFIBOrITvojEYGullZqhwa5hGtG3Gc0qb2VB
         ZJ3TDpZXDHgoNSCmJmA7nhEb2rScG8CdUax/bo3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Chen <yiche@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 080/196] selftests: netfilter: disable rp_filter on router
Date:   Mon, 21 Feb 2022 09:48:32 +0100
Message-Id: <20220221084933.610821514@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit bbe4c0896d25009a7c86285d2ab024eed4374eea upstream.

Some distros may enable rp_filter by default. After ns1 change addr to
10.0.2.99 and set default router to 10.0.2.1, while the connected router
address is still 10.0.1.1. The router will not reply the arp request
from ns1. Fix it by setting the router's veth0 rp_filter to 0.

Before the fix:
  # ./nft_fib.sh
  PASS: fib expression did not cause unwanted packet drops
  Netns nsrouter-HQkDORO2 fib counter doesn't match expected packet count of 1 for 1.1.1.1
  table inet filter {
          chain prerouting {
                  type filter hook prerouting priority filter; policy accept;
                  ip daddr 1.1.1.1 fib saddr . iif oif missing counter packets 0 bytes 0 drop
                  ip6 daddr 1c3::c01d fib saddr . iif oif missing counter packets 0 bytes 0 drop
          }
  }

After the fix:
  # ./nft_fib.sh
  PASS: fib expression did not cause unwanted packet drops
  PASS: fib expression did drop packets for 1.1.1.1
  PASS: fib expression did drop packets for 1c3::c01d

Fixes: 82944421243e ("selftests: netfilter: add fib test case")
Signed-off-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/netfilter/nft_fib.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -174,6 +174,7 @@ test_ping() {
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
 
 sleep 3
 


