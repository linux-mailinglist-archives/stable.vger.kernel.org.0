Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FDC1C1331
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgEAN14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729546AbgEAN1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68AE02166E;
        Fri,  1 May 2020 13:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339674;
        bh=t389B+7YVRykBZ82jpfWstK+R1RrjTgZegRMYVczFts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kedpyLis1MTixOliKfrPKSZozk0eBisds9FxD8lsTUoquWixZ9qUdyS90zkzPHW/E
         80AoQ6FIiJvRf7ahZZH2MN9rnoBayP77jWIfrI2+edhm5qyLfznsRA0mu4tPRTYBuo
         dWV2HkpB0rF6aolclB0tAjpgt1IxESRa0nqMUiIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 06/80] vti4: removed duplicate log message.
Date:   Fri,  1 May 2020 15:21:00 +0200
Message-Id: <20200501131515.061082404@linuxfoundation.org>
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

From: Jeremy Sowden <jeremy@azazel.net>

commit 01ce31c57b3f07c91c9d45bbaf126124cce83a5d upstream.

Removed info log-message if ipip tunnel registration fails during
module-initialization: it adds nothing to the error message that is
written on all failures.

Fixes: dd9ee3444014e ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_vti.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -696,10 +696,8 @@ static int __init vti_init(void)
 
 	msg = "ipip tunnel";
 	err = xfrm4_tunnel_register(&ipip_handler, AF_INET);
-	if (err < 0) {
-		pr_info("%s: cant't register tunnel\n",__func__);
+	if (err < 0)
 		goto xfrm_tunnel_failed;
-	}
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti_link_ops);


