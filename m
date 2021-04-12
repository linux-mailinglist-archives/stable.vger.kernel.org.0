Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF5535BD6E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhDLIvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238234AbhDLItN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8066361289;
        Mon, 12 Apr 2021 08:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217298;
        bh=nmGxfUVjxpNBVS0ZjOMpSec1WFygo0WZh0t/PjVLAzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktKNhrRvdaKqTSv6c1wlSxNk42f6qInLEkY64dStY0Mp9m95E1Fkv4poxU/8XYowk
         AbDN6AhmGWrr/03s0sSaKTIJjAaX6ZZiQZyx+tdeErKuXl06wFTD7ol58WtPjfKjlK
         eLYYIZZBjbkZQUvtJtjiYnlCG4QRvGAykX/8ezr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norman Maurer <norman_maurer@apple.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/111] net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);
Date:   Mon, 12 Apr 2021 10:40:53 +0200
Message-Id: <20210412084006.768391473@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norman Maurer <norman_maurer@apple.com>

[ Upstream commit 98184612aca0a9ee42b8eb0262a49900ee9eef0d ]

Support for UDP_GRO was added in the past but the implementation for
getsockopt was missed which did lead to an error when we tried to
retrieve the setting for UDP_GRO. This patch adds the missing switch
case for UDP_GRO

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Norman Maurer <norman_maurer@apple.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 994a150ae3e9..24841a9e9966 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2692,6 +2692,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		val = up->gso_size;
 		break;
 
+	case UDP_GRO:
+		val = up->gro_enabled;
+		break;
+
 	/* The following two cannot be changed on UDP sockets, the return is
 	 * always 0 (which corresponds to the full checksum coverage of UDP). */
 	case UDPLITE_SEND_CSCOV:
-- 
2.30.2



