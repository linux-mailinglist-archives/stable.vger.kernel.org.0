Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38811C132E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgEAN1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729524AbgEAN1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 219DD20757;
        Fri,  1 May 2020 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339667;
        bh=XMuA9rMJ/mUO09Xunuab3qn9TuUgvQQ5WmIVH/TUMYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Iz3PZc/1jCgnPcm17AFsY5bjKIdTGcJZYDsD0N2dwM3XSIBrxCWNbR66zP2LoQqn
         emIScGEmNmsI76MM/31qG0ddWppX81Sg3Xn2O8AxNJa9mNb63yGEbMAC1Gpm5/W8+6
         j0b61TPTg4Skwlirxm9JMlzouZsb2Df+0+7gfs04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 03/80] net: ipv4: avoid unused variable warning for sysctl
Date:   Fri,  1 May 2020 15:20:57 +0200
Message-Id: <20200501131514.590273014@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 773daa3caf5d3f87fdb1ab43e9c1b367a38fa394 upstream.

The newly introudced ip_min_valid_pmtu variable is only used when
CONFIG_SYSCTL is set:

net/ipv4/route.c:135:12: error: 'ip_min_valid_pmtu' defined but not used [-Werror=unused-variable]

This moves it to the other variables like it, to avoid the harmless
warning.

Fixes: c7272c2f1229 ("net: ipv4: don't allow setting net.ipv4.route.min_pmtu below 68")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/route.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -131,8 +131,6 @@ static int ip_rt_min_advmss __read_mostl
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
 
-static int ip_min_valid_pmtu __read_mostly	= IPV4_MIN_MTU;
-
 /*
  *	Interface to generic destination cache.
  */
@@ -2712,6 +2710,7 @@ void ip_rt_multicast_event(struct in_dev
 static int ip_rt_gc_interval __read_mostly  = 60 * HZ;
 static int ip_rt_gc_min_interval __read_mostly	= HZ / 2;
 static int ip_rt_gc_elasticity __read_mostly	= 8;
+static int ip_min_valid_pmtu __read_mostly	= IPV4_MIN_MTU;
 
 static int ipv4_sysctl_rtcache_flush(struct ctl_table *__ctl, int write,
 					void __user *buffer,


