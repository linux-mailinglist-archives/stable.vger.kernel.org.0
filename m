Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6508566B24
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiGEMEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiGEMDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:03:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A6F1839B;
        Tue,  5 Jul 2022 05:03:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F8C2B817CC;
        Tue,  5 Jul 2022 12:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B6EC341C7;
        Tue,  5 Jul 2022 12:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022621;
        bh=r7xepGLdiPWpOMmZZ9U6vvtDMKUsAdJWX0tzRKZ46Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvarlCPxUQ6FLWe6KwHA+PmnYTN5A+8wcgN9S3Nxyi5l7xxd9JeJYJrHV69ckKZMa
         3EQeEkINAlkX+t2vqM0NUud/nbnWTbKtrHfgoPBKUx9shNMvTrnArWmKF9cu3jjIhf
         ra81tL/bqAtViSiQXnChoQ5rzytM4JDy99v8KNUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        David Forster <dforster@brocade.com>,
        Siwar Zitouni <siwar.zitouni@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 01/58] ipv6: take care of disable_policy when restoring routes
Date:   Tue,  5 Jul 2022 13:57:37 +0200
Message-Id: <20220705115610.282124720@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 3b0dc529f56b5f2328244130683210be98f16f7f upstream.

When routes corresponding to addresses are restored by
fixup_permanent_addr(), the dst_nopolicy parameter was not set.
The typical use case is a user that configures an address on a down
interface and then put this interface up.

Let's take care of this flag in addrconf_f6i_alloc(), so that every callers
benefit ont it.

CC: stable@kernel.org
CC: David Forster <dforster@brocade.com>
Fixes: df789fe75206 ("ipv6: Provide ipv6 version of "disable_policy" sysctl")
Reported-by: Siwar Zitouni <siwar.zitouni@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220623120015.32640-1-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    4 ----
 net/ipv6/route.c    |    9 ++++++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1102,10 +1102,6 @@ ipv6_add_addr(struct inet6_dev *idev, st
 		goto out;
 	}
 
-	if (net->ipv6.devconf_all->disable_policy ||
-	    idev->cnf.disable_policy)
-		f6i->dst_nopolicy = true;
-
 	neigh_parms_data_state_setall(idev->nd_parms);
 
 	ifa->addr = *cfg->pfx;
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4483,8 +4483,15 @@ struct fib6_info *addrconf_f6i_alloc(str
 	}
 
 	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
-	if (!IS_ERR(f6i))
+	if (!IS_ERR(f6i)) {
 		f6i->dst_nocount = true;
+
+		if (!anycast &&
+		    (net->ipv6.devconf_all->disable_policy ||
+		     idev->cnf.disable_policy))
+			f6i->dst_nopolicy = true;
+	}
+
 	return f6i;
 }
 


