Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38F5689647
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjBCKaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjBCK37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:29:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C96A429A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A278961E93
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85880C433EF;
        Fri,  3 Feb 2023 10:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420153;
        bh=LAsH34jvqhWeJgceykPfVWPNk4MKY4rdBQryX2RmVxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqEqNpDHGbiL/tN8/2JBQ+tOVvCYsG3JQdKpKq65obOBxTOSVYbimX0SwEDJWmCC+
         vkNskCar8nix9KaAjtUEWp/rJ/nz0P1kk9lQJChnbwqcUakwZ03WFpUW27PXZFfMZm
         JxAFHZWvvWwk0cUYk0ADlukv0vxmpw/HFo0dV9P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/134] ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
Date:   Fri,  3 Feb 2023 11:13:15 +0100
Message-Id: <20230203101027.902187182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1d1d63b612801b3f0a39b7d4467cad0abd60e5c8 ]

if (!type)
		continue;
	if (type > RTAX_MAX)
		return -EINVAL;
	...
	metrics[type - 1] = val;

@type being used as an array index, we need to prevent
cpu speculation or risk leaking kernel memory content.

Fixes: 6cf9dfd3bd62 ("net: fib: move metrics parsing to a helper")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230120133040.3623463-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/metrics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
index 3205d5f7c8c9..4966ac2aaf87 100644
--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/netlink.h>
+#include <linux/nospec.h>
 #include <linux/rtnetlink.h>
 #include <linux/types.h>
 #include <net/ip.h>
@@ -28,6 +29,7 @@ static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
 			return -EINVAL;
 		}
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 
-- 
2.39.0



