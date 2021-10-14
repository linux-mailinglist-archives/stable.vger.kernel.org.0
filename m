Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1489042DD73
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhJNPHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233439AbhJNPGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC9C6120A;
        Thu, 14 Oct 2021 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223687;
        bh=RsL4ZYa4qQbh0UbeB0TEVBdhhViW5xlD3Tz4/lStPr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ii0YJ/uK3YelheOqeJRNp1+GJtjhfGhyaD+eYXMxMVvSBURcidKT/10KeywsoEL+y
         Smz9gDAWFOz4PlCdkceivmixwJn1Q6GoxyzZmUp5enV+CJD70/FJXSmTY4Pi+PiMpi
         h4LKoslqLwOMDpyO7/Akt1MUMzugd11X/5VC7QOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 08/30] netfilter: ip6_tables: zero-initialize fragment offset
Date:   Thu, 14 Oct 2021 16:54:13 +0200
Message-Id: <20211014145209.794451813@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
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
index de2cf3943b91..a579ea14a69b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -273,6 +273,7 @@ ip6t_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
+	acpar.fragoff = 0;
 	acpar.hotdrop = false;
 	acpar.state   = state;
 
-- 
2.33.0



