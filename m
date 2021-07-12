Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701893C4691
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhGLG1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234968AbhGLG0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:26:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 975C561185;
        Mon, 12 Jul 2021 06:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070983;
        bh=QJqzqIAWCexZAdOP2HAWcadMXl6T9vzUx8zGz8HtyX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toaTDVhRo33j+TFbSUWrVr4N/6E+KvyQvvUp6v5rMiu5k7XNC/iYlWDI2PoqkKyZ+
         Zp+9XECqQZhyFkwCyAkGxrS6rOLoajeTIuiFA+IV0c50YYzxxR7cZtdMcIlxuHnvcy
         M0GCGP3a1y5N27XecY5w/Cv7qElCWFHMOFH9+tBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miao Wang <shankerwangmiao@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 225/348] net/ipv4: swap flow ports when validating source
Date:   Mon, 12 Jul 2021 08:10:09 +0200
Message-Id: <20210712060731.736246547@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 2ce191019526..b875b98820ed 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -381,6 +381,8 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 		fl4.flowi4_proto = 0;
 		fl4.fl4_sport = 0;
 		fl4.fl4_dport = 0;
+	} else {
+		swap(fl4.fl4_sport, fl4.fl4_dport);
 	}
 
 	if (fib_lookup(net, &fl4, &res, 0))
-- 
2.30.2



