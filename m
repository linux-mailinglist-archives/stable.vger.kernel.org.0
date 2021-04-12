Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9DA35C076
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239828AbhDLJN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240446AbhDLJKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 991496127A;
        Mon, 12 Apr 2021 09:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218326;
        bh=1uZh46V5N4adN+fqP41ksnzPUDKliYjEvaV1AoFFZ6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQh3CYu8r/QDgyXFrGLYfNbEMK5gBHoEQ7SY9GWSbrxL41zbpW4nDU9zWt1TptuHs
         f8YYILMk82uN1S4365N1D4xJjXiEvcEMgB2qdaGiuS3xYuZBXSraHtyOdosvQ2nyo5
         vPpm6XQZyImsyjF2XTyDsOqOcsnKJz1l4kl9YuHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norman Maurer <norman_maurer@apple.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 155/210] net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);
Date:   Mon, 12 Apr 2021 10:41:00 +0200
Message-Id: <20210412084021.152574698@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
index 69ea76578abb..9d2a1a247cec 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2749,6 +2749,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
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



