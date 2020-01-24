Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C916A147D56
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732386AbgAXJ7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730321AbgAXJ7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:59:47 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86E2120709;
        Fri, 24 Jan 2020 09:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859986;
        bh=QnEa+vSgf5Jh0i2HRuY+b4bB7/qWVP0+qEgoEZtn1A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHru3/5nwWk1ZnoV1c9Dj5x/4360HmP6fd+4J7j21qCa1vnEAtRjymUupxEbm8fd1
         vgGjPWyhWhDL2X9L+R8/xs1LoODU6tlo72r4t8TLgR7aFN24ubCkqZqI5bjlLnL0SN
         oS3RSThAe07ARU8xizGQK3ClRskQeEtjuZtSNAbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George Wilkie <gwilkie@vyatta.att-mail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 231/343] mpls: fix warning with multi-label encap
Date:   Fri, 24 Jan 2020 10:30:49 +0100
Message-Id: <20200124092950.547467709@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Wilkie <gwilkie@vyatta.att-mail.com>

[ Upstream commit 2f3f7d1fa0d1039b24a55d127ed190f196fc3e79 ]

If you configure a route with multiple labels, e.g.
  ip route add 10.10.3.0/24 encap mpls 16/100 via 10.10.2.2 dev ens4
A warning is logged:
  kernel: [  130.561819] netlink: 'ip': attribute type 1 has an invalid
  length.

This happens because mpls_iptunnel_policy has set the type of
MPLS_IPTUNNEL_DST to fixed size NLA_U32.
Change it to a minimum size.
nla_get_labels() does the remaining validation.

Fixes: e3e4712ec096 ("mpls: ip tunnel support")
Signed-off-by: George Wilkie <gwilkie@vyatta.att-mail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/mpls_iptunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index 6e558a419f603..6c01166f972b9 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -28,7 +28,7 @@
 #include "internal.h"
 
 static const struct nla_policy mpls_iptunnel_policy[MPLS_IPTUNNEL_MAX + 1] = {
-	[MPLS_IPTUNNEL_DST]	= { .type = NLA_U32 },
+	[MPLS_IPTUNNEL_DST]	= { .len = sizeof(u32) },
 	[MPLS_IPTUNNEL_TTL]	= { .type = NLA_U8 },
 };
 
-- 
2.20.1



