Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FC655E20B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbiF0Lic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236527AbiF0Lhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DB06560;
        Mon, 27 Jun 2022 04:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FD9360A10;
        Mon, 27 Jun 2022 11:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357C3C36AE3;
        Mon, 27 Jun 2022 11:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329639;
        bh=klJ26jnLWH9oFW4gAZy/aelKxwmR4wrpLRbrkGf00zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyBoZPbufhi9FHLaF0/oZmh4zepKBUC4xMHmd3ZMSFLwgaUWKwt4YcnujDNp/fcDF
         hMORkAqgLVPUJ/TU4kJU/fgqlhHU5sbjFEtkrHynYKRN2kSd5XKOHhuA47oTz52QLW
         E8AGxAgewV7zz/xsaGMPM+dbPkmqWWqOaacs9lK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jie2x Zhou <jie2x.zhou@intel.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/135] selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh
Date:   Mon, 27 Jun 2022 13:21:11 +0200
Message-Id: <20220627111940.014952326@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie2x Zhou <jie2x.zhou@intel.com>

[ Upstream commit 5d79d8af8dec58bf709b3124d09d9572edd9c617 ]

Before change:
make -C netfilter
 TEST: performance
   net,port                                                      [SKIP]
   perf not supported
   port,net                                                      [SKIP]
   perf not supported
   net6,port                                                     [SKIP]
   perf not supported
   port,proto                                                    [SKIP]
   perf not supported
   net6,port,mac                                                 [SKIP]
   perf not supported
   net6,port,mac,proto                                           [SKIP]
   perf not supported
   net,mac                                                       [SKIP]
   perf not supported

After change:
   net,mac                                                       [ OK ]
     baseline (drop from netdev hook):               2061098pps
     baseline hash (non-ranged entries):             1606741pps
     baseline rbtree (match on first field only):    1191607pps
     set with  1000 full, ranged entries:            1639119pps
ok 8 selftests: netfilter: nft_concat_range.sh

Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with range concatenation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jie2x Zhou <jie2x.zhou@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/netfilter/nft_concat_range.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index b5eef5ffb58e..af3461cb5c40 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -31,7 +31,7 @@ BUGS="flush_remove_add reload"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
-	../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+	../../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
 	pktgen/pktgen_bench_xmit_mode_netif_receive.sh"
 
 # Definition of set types:
-- 
2.35.1



