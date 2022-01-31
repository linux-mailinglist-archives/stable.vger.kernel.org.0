Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1744A4262
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240716AbiAaLLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376987AbiAaLJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC02C061777;
        Mon, 31 Jan 2022 03:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE9D2B82A74;
        Mon, 31 Jan 2022 11:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAE1C340E8;
        Mon, 31 Jan 2022 11:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627166;
        bh=rzVO/2az8f+goj1WhpUhD/OCjQLJr0nUHjFRc4YWh50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Bph26F41TfSnzYw23FKKA4VPFRAUUSlGoQERZPo6WMB3QNr0yBKc0/AGy2VRR8nJ
         eimDSrKjOmz8UxGQ3PjCH+QQr/XQFcTDACE0lsPVXZgeLAVVWexoA6tAFn+7a2dOz4
         1BqHXx/5zXWQK6gdvDyDOFUo9EEsztun0BnyegOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/100] ipv4: remove sparse error in ip_neigh_gw4()
Date:   Mon, 31 Jan 2022 11:56:56 +0100
Message-Id: <20220131105223.645251314@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3c42b2019863b327caa233072c50739d4144dd16 ]

./include/net/route.h:373:48: warning: incorrect type in argument 2 (different base types)
./include/net/route.h:373:48:    expected unsigned int [usertype] key
./include/net/route.h:373:48:    got restricted __be32 [usertype] daddr

Fixes: 5c9f7c1dfc2e ("ipv4: Add helpers for neigh lookup for nexthop")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220127013404.1279313-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/route.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/route.h b/include/net/route.h
index ff021cab657e5..a07c277cd33e8 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -369,7 +369,7 @@ static inline struct neighbour *ip_neigh_gw4(struct net_device *dev,
 {
 	struct neighbour *neigh;
 
-	neigh = __ipv4_neigh_lookup_noref(dev, daddr);
+	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)daddr);
 	if (unlikely(!neigh))
 		neigh = __neigh_create(&arp_tbl, &daddr, dev, false);
 
-- 
2.34.1



