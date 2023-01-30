Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336696810F1
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbjA3OIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbjA3OIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6118303E7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7208161083
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8060FC433EF;
        Mon, 30 Jan 2023 14:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087715;
        bh=5CIZPaRHFqC6zIT38dP4x6YjQKG9pA4dgYNCRYj1dks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFdlggBGp08z7WGx4sDu95RKrvhuwbLDvuiV5NkH+cINjYgaWTnZZ3kVMqTan87I5
         j0XclopqbQ4n4R1PvSHqzSOpMRSf3Llezj2L3XXUfo8+j8jSu/+NBkp35rbxga41Id
         2UiOjQL7Ze58xtWQcdj/0EgbkndIsq0E3YsNreEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 270/313] ipv4: prevent potential spectre v1 gadget in fib_metrics_match()
Date:   Mon, 30 Jan 2023 14:51:45 +0100
Message-Id: <20230130134349.320776966@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 5e9398a26a92fc402d82ce1f97cc67d832527da0 ]

if (!type)
        continue;
    if (type > RTAX_MAX)
        return false;
    ...
    fi_val = fi->fib_metrics->metrics[type - 1];

@type being used as an array index, we need to prevent
cpu speculation or risk leaking kernel memory content.

Fixes: 5f9ae3d9e7e4 ("ipv4: do metrics match when looking up and deleting a route")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230120133140.3624204-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index ce9ff3c62e84..3bb890a40ed7 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/netlink.h>
 #include <linux/hash.h>
+#include <linux/nospec.h>
 
 #include <net/arp.h>
 #include <net/inet_dscp.h>
@@ -1022,6 +1023,7 @@ bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi)
 		if (type > RTAX_MAX)
 			return false;
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 			bool ecn_ca = false;
-- 
2.39.0



