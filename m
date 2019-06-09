Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C3C3AA58
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731997AbfFIQvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731994AbfFIQvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:51:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F741205ED;
        Sun,  9 Jun 2019 16:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099100;
        bh=6Ajabuw9ON+eshjxs/JE69Gi3UxizKO+uTGIS/9UZe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkAl4slx/mw0L7RiMi38pUyDls72nZuf2RFrLt0ZMH1pwgho3tQpgXYzouK/+izGz
         HdyUFfiInPO/b1W86Jw0folFYjVtDpSz/IJrYiaZ2ksauqbWQlAcjK6KgR2LtCFXSn
         oLCnR4A5z3ojCHtgO1EHn6bIiVNL7jtjtRxwERXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        kbuild test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 10/83] ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
Date:   Sun,  9 Jun 2019 18:41:40 +0200
Message-Id: <20190609164128.423181141@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 903869bd10e6719b9df6718e785be7ec725df59f ]

ip_sf_list_clear_all() needs to be defined even if !CONFIG_IP_MULTICAST

Fixes: 3580d04aa674 ("ipv4/igmp: fix another memory leak in igmpv3_del_delrec()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/igmp.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -190,6 +190,17 @@ static void ip_ma_put(struct ip_mc_list
 	     pmc != NULL;					\
 	     pmc = rtnl_dereference(pmc->next_rcu))
 
+static void ip_sf_list_clear_all(struct ip_sf_list *psf)
+{
+	struct ip_sf_list *next;
+
+	while (psf) {
+		next = psf->sf_next;
+		kfree(psf);
+		psf = next;
+	}
+}
+
 #ifdef CONFIG_IP_MULTICAST
 
 /*
@@ -635,17 +646,6 @@ static void igmpv3_clear_zeros(struct ip
 	}
 }
 
-static void ip_sf_list_clear_all(struct ip_sf_list *psf)
-{
-	struct ip_sf_list *next;
-
-	while (psf) {
-		next = psf->sf_next;
-		kfree(psf);
-		psf = next;
-	}
-}
-
 static void kfree_pmc(struct ip_mc_list *pmc)
 {
 	ip_sf_list_clear_all(pmc->sources);


