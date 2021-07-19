Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC693CDD7C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245327AbhGSO6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244217AbhGSO5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B233613BA;
        Mon, 19 Jul 2021 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708899;
        bh=H8+kQyVNP9FGrG3q1HJR1K8lV9WeNNhTvymHDFs212U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3SM4USHQs33B2MGKyPZLp5QDSqCERzKH82L1CGFl8BOH9Ke5uEa+5fjzr6sZoiSY
         xznCdy7uNK7AQiQZka7bzLdqHC7T7S62NzGL0MYydZp61f8jjOND6toH++fzC6aEEL
         tB7ojNHyPrB0qifaVo/0BbF1eZbaxP+qQABsB2Os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miao Wang <shankerwangmiao@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/421] net/ipv4: swap flow ports when validating source
Date:   Mon, 19 Jul 2021 16:49:18 +0200
Message-Id: <20210719144951.578463938@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miao Wang <shankerwangmiao@gmail.com>

[ Upstream commit c69f114d09891adfa3e301a35d9e872b8b7b5a50 ]

When doing source address validation, the flowi4 struct used for
fib_lookup should be in the reverse direction to the given skb.
fl4_dport and fl4_sport returned by fib4_rules_early_flow_dissect
should thus be swapped.

Fixes: 5a847a6e1477 ("net/ipv4: Initialize proto and ports in flow struct")
Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_frontend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b96aa88087be..70e5e9e5d835 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -353,6 +353,8 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 		fl4.flowi4_proto = 0;
 		fl4.fl4_sport = 0;
 		fl4.fl4_dport = 0;
+	} else {
+		swap(fl4.fl4_sport, fl4.fl4_dport);
 	}
 
 	if (fib_lookup(net, &fl4, &res, 0))
-- 
2.30.2



