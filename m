Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BE45AEB1E
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239487AbiIFNza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238805AbiIFNxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:53:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89684804B7;
        Tue,  6 Sep 2022 06:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01F4ECE177D;
        Tue,  6 Sep 2022 13:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F614C433D6;
        Tue,  6 Sep 2022 13:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471633;
        bh=CRt/nAFidu2/Fa+kSY83hNUBSE8UekJvMXGOpiPP4Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zb8sqikqxkWaTRGEjUxkgMO5p7nFcWJk2Eult5obXZ3aL1NR3fiTYZMo5CIuSW+50
         J5bfcyspxVkeLfwss/Xw3qa8D5jo+L4BrtHGgylPwUKKwzyk0yPCKs0/fNFqkDQ6q+
         LW+DbG7XURvke60GXNqGEPevj1p/fPdlVIN9rZqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <yujie.liu@intel.com>,
        Heng Qi <hengqi@linux.alibaba.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 092/107] ip: fix triggering of icmp redirect
Date:   Tue,  6 Sep 2022 15:31:13 +0200
Message-Id: <20220906132825.720445776@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit eb55dc09b5dd040232d5de32812cc83001a23da6 upstream.

__mkroute_input() uses fib_validate_source() to trigger an icmp redirect.
My understanding is that fib_validate_source() is used to know if the src
address and the gateway address are on the same link. For that,
fib_validate_source() returns 1 (same link) or 0 (not the same network).
__mkroute_input() is the only user of these positive values, all other
callers only look if the returned value is negative.

Since the below patch, fib_validate_source() didn't return anymore 1 when
both addresses are on the same network, because the route lookup returns
RT_SCOPE_LINK instead of RT_SCOPE_HOST. But this is, in fact, right.
Let's adapat the test to return 1 again when both addresses are on the same
link.

CC: stable@vger.kernel.org
Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
Reported-by: kernel test robot <yujie.liu@intel.com>
Reported-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220829100121.3821-1-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_frontend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -389,7 +389,7 @@ static int __fib_validate_source(struct
 	dev_match = dev_match || (res.type == RTN_LOCAL &&
 				  dev == net->loopback_dev);
 	if (dev_match) {
-		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
+		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
 		return ret;
 	}
 	if (no_addr)
@@ -401,7 +401,7 @@ static int __fib_validate_source(struct
 	ret = 0;
 	if (fib_lookup(net, &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE) == 0) {
 		if (res.type == RTN_UNICAST)
-			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
+			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
 	}
 	return ret;
 


