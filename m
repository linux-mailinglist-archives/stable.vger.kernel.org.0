Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF4842DCF9
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhJNPDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233225AbhJNPCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7502461151;
        Thu, 14 Oct 2021 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223553;
        bh=Qxx686P8vUb6GPouCQmVlT+kTMmeQTNFJe7SNq54ACk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdzKDotauReBoq9q9CEDKsBFz3VOHg/Mo7cxc51hSKQXGCwjFxN+bkXlIvhClkroI
         aonZ4o+eL8hfPDBXT35+vXJSSl5Up9T0BYgQiF8vmym8oXwFz0PLMbWTLfcGr5G2cR
         idmZYkeUOfONXFzPWBGKquw9IJf3LS8u2MewQLDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/16] netfilter: ip6_tables: zero-initialize fragment offset
Date:   Thu, 14 Oct 2021 16:54:07 +0200
Message-Id: <20211014145207.463875310@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
References: <20211014145207.314256898@linuxfoundation.org>
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
index 8bb543b0e775..41268612bdd4 100644
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



