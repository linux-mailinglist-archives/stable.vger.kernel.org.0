Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6055C42DCD6
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhJNPCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231817AbhJNPAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8CDB610D1;
        Thu, 14 Oct 2021 14:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223507;
        bh=Gx3xEh8JO3e1CawjKkN9jI/dAj0HL0xZ0aKWmSuBrJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kdc5WPQmfaaIp0QngHjTktuziMsM/p8TCDk3KNrmE8jijIcKn7/60MlK4E3rgGlRH
         Z9zv8to3cVmXxm+6dwJkpMVagNE2CW5k3x3nRbyNkmcA16w8UKq8yvpQW1HwyEdA2M
         YxnWCJ5lZSptRQQ+tstuNBsW8z9Ltu3tN0uT1SfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/12] netfilter: ip6_tables: zero-initialize fragment offset
Date:   Thu, 14 Oct 2021 16:54:03 +0200
Message-Id: <20211014145206.673259193@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
References: <20211014145206.566123760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 310e2d43c3ad429c1fba4b175806cf1f55ed73a6 ]

ip6tables only sets the `IP6T_F_PROTO` flag on a rule if a protocol is
specified (`-p tcp`, for example).  However, if the flag is not set,
`ip6_packet_match` doesn't call `ipv6_find_hdr` for the skb, in which
case the fragment offset is left uninitialized and a garbage value is
passed to each matcher.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6_tables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index dd0c1073dc8e..d93490ac8275 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -276,6 +276,7 @@ ip6t_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
+	acpar.fragoff = 0;
 	acpar.hotdrop = false;
 	acpar.state   = state;
 
-- 
2.33.0



