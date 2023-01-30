Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562D1681241
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbjA3OTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbjA3OTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:19:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB7D38669
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:18:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70209CE1409
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB0FC433D2;
        Mon, 30 Jan 2023 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088285;
        bh=9bSnuSPJl9quzG4XE8YPlSI0noB9XRB6LHYE+i3XjRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtLHlgbWnXdnPr3/7c0ZjrgDfDgR7DWsRJnVuPUNFzR3B8h4gboJrtaxVJOwaTrS0
         YoJQNF9hRktfV2znP0ptsmZNYcXgPK37tX7IUV1+lE0yKe3QJ62pyDbvUmYn/ADO5A
         PmvUlOpVYvZRQzMV2vfNmF5eoJXDeYsUBKZNbp0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/204] ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
Date:   Mon, 30 Jan 2023 14:52:23 +0100
Message-Id: <20230130134324.374772073@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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
index 25ea6ac44db9..6a1427916c7d 100644
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



