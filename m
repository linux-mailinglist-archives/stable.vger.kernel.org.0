Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304B176DEC
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387914AbfGZP0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387894AbfGZP0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:26:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0205C218D4;
        Fri, 26 Jul 2019 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154780;
        bh=kQogq5q7TgVnT/79suhILfXBjUEJhKtEX/sKEyHCqPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RT0wlzP/GtmlHQpgOR1++aRA0nsLD7jELMd2G4JLcHXP8EsUoyLfx0R7xTd+BZdQN
         //3UMIJ7l72xAZJjoL3Q5DP86CVQDC4WsXqYfkgKayUR/IFiwWf7MYCkPB3Gt96ZQc
         TSt+e0Vz7Z0zllSC/CfXrWzejQnjc5AOcY23T9tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Donohue <linux-kernel@PaulSD.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 06/66] ipv6: rt6_check should return NULL if from is NULL
Date:   Fri, 26 Jul 2019 17:24:05 +0200
Message-Id: <20190726152302.607408339@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 49d05fe2c9d1b4a27761c9807fec39b8155bef9e ]

Paul reported that l2tp sessions were broken after the commit referenced
in the Fixes tag. Prior to this commit rt6_check returned NULL if the
rt6_info 'from' was NULL - ie., the dst_entry was disconnected from a FIB
entry. Restore that behavior.

Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
Reported-by: Paul Donohue <linux-kernel@PaulSD.com>
Tested-by: Paul Donohue <linux-kernel@PaulSD.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2215,7 +2215,7 @@ static struct dst_entry *rt6_check(struc
 {
 	u32 rt_cookie = 0;
 
-	if ((from && !fib6_get_cookie_safe(from, &rt_cookie)) ||
+	if (!from || !fib6_get_cookie_safe(from, &rt_cookie) ||
 	    rt_cookie != cookie)
 		return NULL;
 


