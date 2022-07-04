Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E09564EC7
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 09:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiGDHgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 03:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiGDHgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 03:36:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7469FC3
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 00:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07AB60FA4
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 07:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA41C341D1;
        Mon,  4 Jul 2022 07:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656920163;
        bh=Piu+qIEuW6cAJs8II5JtZ15AF7dEH/IneDZmD/WkXfE=;
        h=Subject:To:Cc:From:Date:From;
        b=G5yFM98i6ze11QECZtJUK3Yki/1eVgPBOyik7b+u2X3+AxiD10fP84KOCVbnPK7hb
         20EC6On7yGWDtPC9ltTnSQNCqIDCExiFs8S0FKAnpYo4n4iUOX9wLvQrGtlSQoydlt
         vjCHl3+MnDJ26ie4NDsr54K3e5yOKF1Yu6cZ08jI=
Subject: FAILED: patch "[PATCH] ipv6: take care of disable_policy when restoring routes" failed to apply to 4.14-stable tree
To:     nicolas.dichtel@6wind.com, dforster@brocade.com,
        dsahern@kernel.org, kuba@kernel.org, siwar.zitouni@6wind.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 09:36:00 +0200
Message-ID: <1656920160168123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b0dc529f56b5f2328244130683210be98f16f7f Mon Sep 17 00:00:00 2001
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 23 Jun 2022 14:00:15 +0200
Subject: [PATCH] ipv6: take care of disable_policy when restoring routes

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

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1b1932502e9e..5864cbc30db6 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1109,10 +1109,6 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 		goto out;
 	}
 
-	if (net->ipv6.devconf_all->disable_policy ||
-	    idev->cnf.disable_policy)
-		f6i->dst_nopolicy = true;
-
 	neigh_parms_data_state_setall(idev->nd_parms);
 
 	ifa->addr = *cfg->pfx;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d25dc83bac62..828355710c57 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4569,8 +4569,15 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
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
 

