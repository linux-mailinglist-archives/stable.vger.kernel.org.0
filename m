Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2683A4BDBF5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244345AbiBUJuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352887AbiBUJsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CE6193EC;
        Mon, 21 Feb 2022 01:20:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4659608C4;
        Mon, 21 Feb 2022 09:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8152C340E9;
        Mon, 21 Feb 2022 09:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435258;
        bh=bN043WedEhBYdSu+Ret7cNF7R/i2stufqlZsoE2K6Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teak/tgj4gnJFFmOuILb/GUQNQXIw0/Ealqsu06K4E6zZgE2juWcJqnW16nIgtkGA
         K2hn5DmHQNNTTyh9VjWj89iGMX2tI/L43I9xPWzkt32zchSvapHCklUA5bYwZffJBu
         NIoJ4leV38dQSCyXPpU7fRpCtz0y+eAop2ksECjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Chen <yiche@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.16 100/227] selftests: netfilter: disable rp_filter on router
Date:   Mon, 21 Feb 2022 09:48:39 +0100
Message-Id: <20220221084938.206979851@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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
 


