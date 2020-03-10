Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B3917F7C8
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgCJMmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgCJMmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:42:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE8B24693;
        Tue, 10 Mar 2020 12:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844131;
        bh=Esomg4B0Q+sp4mv1ro05B9Kx8R2xCyYhuc4bhG0TRp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdUO59ZMiaQUgeKzcpLsx3v0j/PShWNNOM2qbm4RdOkCVXp3KBSynRpeGwy+Y2sEJ
         /5MT0eOBDKwdEWiX9BbXgqu0uyFzh8mgULM0QMcx5UEyTjcEeDD/rPFhoN2oYXQvCs
         vAKKRc0XDm1EcQ4h03TlqcjSi9VWnIsXdhd/Stog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 15/72] ipv6: Fix route replacement with dev-only route
Date:   Tue, 10 Mar 2020 13:38:28 +0100
Message-Id: <20200310123605.319045287@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Poirier <bpoirier@cumulusnetworks.com>

[ Upstream commit e404b8c7cfb31654c9024d497cec58a501501692 ]

After commit 27596472473a ("ipv6: fix ECMP route replacement") it is no
longer possible to replace an ECMP-able route by a non ECMP-able route.
For example,
	ip route add 2001:db8::1/128 via fe80::1 dev dummy0
	ip route replace 2001:db8::1/128 dev dummy0
does not work as expected.

Tweak the replacement logic so that point 3 in the log of the above commit
becomes:
3. If the new route is not ECMP-able, and no matching non-ECMP-able route
exists, replace matching ECMP-able route (if any) or add the new route.

We can now summarize the entire replace semantics to:
When doing a replace, prefer replacing a matching route of the same
"ECMP-able-ness" as the replace argument. If there is no such candidate,
fallback to the first route found.

Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -780,8 +780,7 @@ static int fib6_add_rt2node(struct fib6_
 					found++;
 					break;
 				}
-				if (rt_can_ecmp)
-					fallback_ins = fallback_ins ?: ins;
+				fallback_ins = fallback_ins ?: ins;
 				goto next_iter;
 			}
 
@@ -821,7 +820,9 @@ next_iter:
 	}
 
 	if (fallback_ins && !found) {
-		/* No ECMP-able route found, replace first non-ECMP one */
+		/* No matching route with same ecmp-able-ness found, replace
+		 * first matching route
+		 */
 		ins = fallback_ins;
 		iter = *ins;
 		found++;


