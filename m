Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2436159D0
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiKBDSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiKBDSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4F1F5B4
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61CDA6177E
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F012EC433D6;
        Wed,  2 Nov 2022 03:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359122;
        bh=QTsPiAQBRNWC1LwypWCxasAUrTX0p/9OgrYLxochyJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lt2ldTg1VWPqvKtK27ADKUm/DQ0Dz3i7Ul2E/EOvC1hHJdqjbsDMItEbYGav7qJz
         zquNNZy0zpBemNVDKj7RityWWjQJmM+vDJ3sdiObahM0Ema64ATSIPCAIKtvBi5cVF
         jQU+nJsVxZqm9T5XrvVxI7UBOgKgtNSiQ0JMm8PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Julian Anastasov <ja@ssi.bg>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 80/91] nh: fix scope used to find saddr when adding non gw nh
Date:   Wed,  2 Nov 2022 03:34:03 +0100
Message-Id: <20221102022057.325119364@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit bac0f937c343d651874f83b265ca8f5070ed4f06 ]

As explained by Julian, fib_nh_scope is related to fib_nh_gw4, but
fib_info_update_nhc_saddr() needs the scope of the route, which is
the scope "before" fib_nh_scope, ie fib_nh_scope - 1.

This patch fixes the problem described in commit 747c14307214 ("ip: fix
dflt addr selection for connected nexthop").

Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
Link: https://lore.kernel.org/netdev/6c8a44ba-c2d5-cdf-c5c7-5baf97cba38@ssi.bg/
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 2a17dc9413ae..7a0102a4b1de 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1346,7 +1346,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 	if (!err) {
 		nh->nh_flags = fib_nh->fib_nh_flags;
 		fib_info_update_nhc_saddr(net, &fib_nh->nh_common,
-					  fib_nh->fib_nh_scope);
+					  !fib_nh->fib_nh_scope ? 0 : fib_nh->fib_nh_scope - 1);
 	} else {
 		fib_nh_release(net, fib_nh);
 	}
-- 
2.35.1



