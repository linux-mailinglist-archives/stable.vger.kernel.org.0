Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC3F18B745
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgCSNP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbgCSNP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:15:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0F7420724;
        Thu, 19 Mar 2020 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623756;
        bh=l5cFa6Emn1btZwMRpEet7GN0OLXU861N0lQ98ZxATI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeTQwJ6Ar+wFSmHT7JQ2TdxuqNOylhej7IcizGYhvJkKsmx8qPuTflhL8StHhKdpr
         YQBFEfOvG/CZtsxYWdr38VzGY4ujon5/ffRLpcZK3p0GeVJbcoM6hL/i30ImFuzHr5
         CL5b1hBv6vY9yHM3e9y38WlAjOWUsAiez4eQVgPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 35/99] ipvlan: egress mcast packets are not exceptional
Date:   Thu, 19 Mar 2020 14:03:13 +0100
Message-Id: <20200319123952.429268161@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit cccc200fcaf04cff4342036a72e51d6adf6c98c1 upstream.

Currently, if IPv6 is enabled on top of an ipvlan device in l3
mode, the following warning message:

 Dropped {multi|broad}cast of type= [86dd]

is emitted every time that a RS is generated and dmseg is soon
filled with irrelevant messages. Replace pr_warn with pr_debug,
to preserve debuggability, without scaring the sysadmin.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ipvlan/ipvlan_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -451,8 +451,8 @@ static int ipvlan_process_outbound(struc
 
 	/* In this mode we dont care about multicast and broadcast traffic */
 	if (is_multicast_ether_addr(ethh->h_dest)) {
-		pr_warn_ratelimited("Dropped {multi|broad}cast of type= [%x]\n",
-				    ntohs(skb->protocol));
+		pr_debug_ratelimited("Dropped {multi|broad}cast of type=[%x]\n",
+				     ntohs(skb->protocol));
 		kfree_skb(skb);
 		goto out;
 	}


