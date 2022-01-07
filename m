Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C1487884
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbiAGNsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238971AbiAGNsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:48:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AE9C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 05:48:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5780EB825E9
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B9AC36AE0;
        Fri,  7 Jan 2022 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641563298;
        bh=dT/uxzOCRCSyw/WS3f6GF/K00Ew2mYSvM5Jo8QDcnUo=;
        h=Subject:To:Cc:From:Date:From;
        b=cIzFUC8WYqXan8dHcAOEPCV2AxJIFCm8pC99WirckSDnKnFXMLkm5Tj8CesPM6h+/
         Z2y5VHrdHNzRv6X+ZhgckjjOVJAfueKigvrb0ww1SNVbqrGGZpe32L/i2y2q0PMMK6
         OAkyNLbJdIbNfJkrvrkl6KcfmxQPmtErKa4cOi0Q=
Subject: FAILED: patch "[PATCH] ipv4: Check attribute length for RTA_FLOW in multipath route" failed to apply to 4.14-stable tree
To:     dsahern@kernel.org, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:48:02 +0100
Message-ID: <164156328232160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 664b9c4b7392ce723b013201843264bf95481ce5 Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@kernel.org>
Date: Thu, 30 Dec 2021 17:36:32 -0700
Subject: [PATCH] ipv4: Check attribute length for RTA_FLOW in multipath route

Make sure RTA_FLOW is at least 4B before using.

Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f1caa2c1c041..36bc429f1635 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -731,8 +731,13 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 			}
 
 			nla = nla_find(attrs, attrlen, RTA_FLOW);
-			if (nla)
+			if (nla) {
+				if (nla_len(nla) < sizeof(u32)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_FLOW");
+					return -EINVAL;
+				}
 				fib_cfg.fc_flow = nla_get_u32(nla);
+			}
 
 			fib_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
 			nla = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
@@ -963,8 +968,14 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
 			nla = nla_find(attrs, attrlen, RTA_FLOW);
-			if (nla && nla_get_u32(nla) != nh->nh_tclassid)
-				return 1;
+			if (nla) {
+				if (nla_len(nla) < sizeof(u32)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_FLOW");
+					return -EINVAL;
+				}
+				if (nla_get_u32(nla) != nh->nh_tclassid)
+					return 1;
+			}
 #endif
 		}
 

