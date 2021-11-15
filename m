Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B8A450D9D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbhKOR74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239196AbhKOR5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:57:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4730763331;
        Mon, 15 Nov 2021 17:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997691;
        bh=FC60KiVY7CgR/RBg4YFGKdpFPrhy50AdvTksaDfEXaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2fOgOiNG0PxUkDqjhNLKDFNTB3gWo9TV+L5jKR2g4Qhg0F9ExVzlikAwsI58WNV8
         LCk/VcWRTRDtxY8WLnGuCwMsABZTb2wAyh5LOGGKQszLdgxB3T+gqZN7maS9TPID7R
         AWPljYSmGAoT+r51MJYPzHBvvF98+Y5VwhdSFYh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        Antonio Quartulli <a@unstable.cc>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/575] gre/sit: Dont generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
Date:   Mon, 15 Nov 2021 17:59:25 +0100
Message-Id: <20211115165352.036074088@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 884d430e23cb3..29526937077b3 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3097,6 +3097,9 @@ static void sit_add_v4_addrs(struct inet6_dev *idev)
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



