Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6956810F0
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbjA3OIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbjA3OIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67B23B0F3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70EAC61088
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF3AC4339B;
        Mon, 30 Jan 2023 14:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087712;
        bh=9bSnuSPJl9quzG4XE8YPlSI0noB9XRB6LHYE+i3XjRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+JBmbXwUlQln7ALipwgVkB7PyN9N+ZeE1CSfeFQN5HcF6ANhwgJp40uptKLHTn/j
         1FdSJq1DPkcX/oPMe5VIIYKZVqRIc//0hnplF6In08NRNNm4T9mVEqHKU/6B8p/+oQ
         Om+ZZDw7OQNE7ofKUhycOtrOY27xHmgn7CaQaY04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 269/313] ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
Date:   Mon, 30 Jan 2023 14:51:44 +0100
Message-Id: <20230130134349.273284813@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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



