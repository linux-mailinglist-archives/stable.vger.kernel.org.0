Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644DF3C541D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245673AbhGLH5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242205AbhGLHwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33406610FB;
        Mon, 12 Jul 2021 07:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076195;
        bh=ZNQmPDaypOBZQ7wR67fztU/ke2WJJ/OsEPsCEOsz240=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4KLPS0vJwl//fCdjuco/4xeQTa6CVVC9M+oHI/rprlW8zFKdH3scWNXML9fZYmaG
         w/dcA2BRwxZ9tELPFGzj2eh1xuEMoJ8wt420xA5mZKlDLJy2Tz6ycIsUtUmj7o1ymi
         0VCfHon7bKr1zx8+50geuTta6baga3B7CRUTqjIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miao Wang <shankerwangmiao@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 539/800] net/ipv4: swap flow ports when validating source
Date:   Mon, 12 Jul 2021 08:09:22 +0200
Message-Id: <20210712061024.719091394@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 84bb707bd88d..647bceab56c2 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -371,6 +371,8 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 		fl4.flowi4_proto = 0;
 		fl4.fl4_sport = 0;
 		fl4.fl4_dport = 0;
+	} else {
+		swap(fl4.fl4_sport, fl4.fl4_dport);
 	}
 
 	if (fib_lookup(net, &fl4, &res, 0))
-- 
2.30.2



