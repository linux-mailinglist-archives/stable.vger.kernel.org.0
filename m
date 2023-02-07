Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC7168E003
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 19:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjBGSaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 13:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjBGSaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 13:30:01 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31F610DC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 10:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675794600; x=1707330600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RiQroxHsMesevYUDkYjoMfOm7jVhlZoKX6jWWO+I6PY=;
  b=R08XnB9VCpA+99/xH9fze9TNqVxt8UgipiugzLTCIR0nfaFHqiqikozV
   CaalHi9FYntjPc4lc1bD5kUeMn/n4XAsOkhBFCdetHnXWf++Ep2/zfT5C
   3aKa+beJiDcm8b6plsd1tfmb6WB1evluwwfSZXistqs2HMeLt74iWLqpS
   8=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="296302866"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 18:29:59 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id 4782EC0601;
        Tue,  7 Feb 2023 18:29:58 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 18:29:57 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.162.56)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Tue, 7 Feb 2023 18:29:57 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <dsahern@kernel.org>, <idosch@nvidia.com>, <kuba@kernel.org>,
        <patches@lists.linux.dev>, <sashal@kernel.org>,
        <shaoyi@amazon.com>, <stable@vger.kernel.org>
Subject: [PATCH 5.4 v2 2/2] ipv4: Fix incorrect route flushing when source address is deleted
Date:   Tue, 7 Feb 2023 18:28:20 +0000
Message-ID: <20230207182820.4959-2-shaoyi@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207182820.4959-1-shaoyi@amazon.com>
References: <Y+IckeUtbE/UfOz/@kroah.com>
 <20230207182820.4959-1-shaoyi@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D40UWC001.ant.amazon.com (10.43.162.149) To
 EX19D046UWB004.ant.amazon.com (10.13.139.164)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f96a3d74554df537b6db5c99c27c80e7afadc8d1 ]

Cited commit added the table ID to the FIB info structure, but did not
prevent structures with different table IDs from being consolidated.
This can lead to routes being flushed from a VRF when an address is
deleted from a different VRF.

Fix by taking the table ID into account when looking for a matching FIB
info. This is already done for FIB info structures backed by a nexthop
object in fib_find_info_nh().

Add test cases that fail before the fix:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [FAIL]
     TEST: Route in default VRF not removed                              [ OK ]
 RTNETLINK answers: File exists
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [FAIL]

 Tests passed:   6
 Tests failed:   2

And pass after:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]

 Tests passed:   8
 Tests failed:   0

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
 net/ipv4/fib_semantics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 908913d75847..f45b9daf62cf 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -420,6 +420,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    nfi->fib_type == fi->fib_type &&
+		    nfi->fib_tb_id == fi->fib_tb_id &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
 			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&
-- 
2.38.1

