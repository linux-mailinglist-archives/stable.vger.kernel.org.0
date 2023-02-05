Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4AB68AE6F
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 06:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjBEFbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 00:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBEFbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 00:31:38 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1A51F5DA
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 21:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675575097; x=1707111097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XkbPWjDO/QtZNr0E3SDhaSmquDn0r6FIVKgJTahd54g=;
  b=MBhMbjS1QivuT1ulbPjhoyA6x/N0w4kLQ9xf4g2WCL3fJB2Xyl/0Sm1B
   iEBOF4qR3mzLfwmDFBRzhegFGBf4kFf48xYubAqRYns1BcTwLSbFEV+Br
   GF1LN5+mrZFr4zJk6Yr2RrFF/OsHRrzD1+lrmWfhZ+F2UTX0mZzznP6+C
   g=;
X-IronPort-AV: E=Sophos;i="5.97,274,1669075200"; 
   d="scan'208";a="260155441"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 05:31:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com (Postfix) with ESMTPS id D4641A27CE;
        Sun,  5 Feb 2023 05:31:33 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Sun, 5 Feb 2023 05:31:32 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.160.120)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Sun, 5 Feb 2023 05:31:32 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <dsahern@kernel.org>, <idosch@nvidia.com>, <kuba@kernel.org>,
        <patches@lists.linux.dev>, <sashal@kernel.org>,
        <stable@vger.kernel.org>, Shaoying Xu <shaoyi@amazon.com>
Subject: Re: [PATCH 5.4 60/67] ipv4: Fix incorrect route flushing when source address is deleted 
Date:   Sun, 5 Feb 2023 05:30:58 +0000
Message-ID: <20230205053100.15903-1-shaoyi@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130920.482075438@linuxfoundation.org>
References: <20221212130920.482075438@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D41UWB004.ant.amazon.com (10.43.161.135) To
 EX19D046UWB004.ant.amazon.com (10.13.139.164)
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Dec 2022 14:17:35 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> From: Ido Schimmel <idosch@nvidia.com>
> 
> [ Upstream commit f96a3d74554df537b6db5c99c27c80e7afadc8d1 ]
> 
> Cited commit added the table ID to the FIB info structure, but did not
> prevent structures with different table IDs from being consolidated.
> This can lead to routes being flushed from a VRF when an address is
> deleted from a different VRF.
> 
> Fix by taking the table ID into account when looking for a matching FIB
> info. This is already done for FIB info structures backed by a nexthop
> object in fib_find_info_nh().
> 
> Add test cases that fail before the fix:
> 
>  # ./fib_tests.sh -t ipv4_del_addr
> 
>  IPv4 delete address route tests
>      Regular FIB info
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
>      Identical FIB info with different table ID
>      TEST: Route removed from VRF when source address deleted            [FAIL]
>      TEST: Route in default VRF not removed                              [ OK ]
>  RTNETLINK answers: File exists
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [FAIL]
> 
>  Tests passed:   6
>  Tests failed:   2
> 
> And pass after:
> 
>  # ./fib_tests.sh -t ipv4_del_addr
> 
>  IPv4 delete address route tests
>      Regular FIB info
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
>      Identical FIB info with different table ID
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
> 
>  Tests passed:   8
>  Tests failed:   0
> 
> Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ipv4/fib_semantics.c                 |    1 +
>  tools/testing/selftests/net/fib_tests.sh | 1727 ----------------------
>  2 files changed, 1 insertion(+), 1727 deletions(-)
>  delete mode 100755 tools/testing/selftests/net/fib_tests.sh

Hi Greg,

Sorry for last unclear message without context. I found this commit deleted
the whole fib_tests.sh that causes new failure in kselftests run. Looking at
the upstream patch [1] and given the context that ipv4_del_addr test is not
available to kernel 5.4, I added the revert patch and new backport of this
commit to resolve the potential mistake.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f96a3d74554df537b6db5c99c27c80e7afadc8d1

Thanks,
Shaoying

Ido Schimmel (1):
  ipv4: Fix incorrect route flushing when source address is deleted

Shaoying Xu (1):
  Revert "ipv4: Fix incorrect route flushing when source address is
    deleted"

 tools/testing/selftests/net/fib_tests.sh | 1727 ++++++++++++++++++++++
 1 file changed, 1727 insertions(+)
 create mode 100755 tools/testing/selftests/net/fib_tests.sh

-- 
2.38.1

