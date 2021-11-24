Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367FE45BD4A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbhKXMhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:37:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244362AbhKXMe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:34:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73EFC6104F;
        Wed, 24 Nov 2021 12:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756479;
        bh=ZAXKUZhFRF1nagWsA+OWUgnFNSdRaSN6Mqo5cD9laDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3YLkPh4mFsqalV4MocnYNF2aOLVVbO3pcT3Gsk2Ih1e/siD25he+grhFSH5Il2s9
         8LypG5IM3rZByVqRLeBCoOkW1tjw2luz3E4jyXk4wFm50hlEjml792VBEFUI7QcZE0
         PRD/R7wFxjPF3M0XpRPexihez2oyt4DnpbH0JU6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        Antonio Quartulli <a@unstable.cc>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 100/251] gre/sit: Dont generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
Date:   Wed, 24 Nov 2021 12:55:42 +0100
Message-Id: <20211124115713.726859933@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

[ Upstream commit 61e18ce7348bfefb5688a8bcd4b4d6b37c0f9b2a ]

When addr_gen_mode is set to IN6_ADDR_GEN_MODE_NONE, the link-local addr
should not be generated. But it isn't the case for GRE (as well as GRE6)
and SIT tunnels. Make it so that tunnels consider the addr_gen_mode,
especially for IN6_ADDR_GEN_MODE_NONE.

Do this in add_v4_addrs() to cover both GRE and SIT only if the addr
scope is link.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Acked-by: Antonio Quartulli <a@unstable.cc>
Link: https://lore.kernel.org/r/20211020200618.467342-1-ssuryaextr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e47d5047d5373..178a3b26f9d2c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2996,6 +2996,9 @@ static void sit_add_v4_addrs(struct inet6_dev *idev)
 	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr, 4);
 
 	if (idev->dev->flags&IFF_POINTOPOINT) {
+		if (idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_NONE)
+			return;
+
 		addr.s6_addr32[0] = htonl(0xfe800000);
 		scope = IFA_LINK;
 		plen = 64;
-- 
2.33.0



