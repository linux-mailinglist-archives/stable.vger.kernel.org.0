Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D70C91F3
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfJBTMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:12:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35402 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729107AbfJBTIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-00035i-3w; Wed, 02 Oct 2019 20:08:06 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-0003bV-HF; Wed, 02 Oct 2019 20:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "kbuild test robot" <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.259555730@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 21/87] ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 903869bd10e6719b9df6718e785be7ec725df59f upstream.

ip_sf_list_clear_all() needs to be defined even if !CONFIG_IP_MULTICAST

Fixes: 3580d04aa674 ("ipv4/igmp: fix another memory leak in igmpv3_del_delrec()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/igmp.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -192,6 +192,17 @@ static void ip_ma_put(struct ip_mc_list
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
@@ -614,17 +625,6 @@ static void igmpv3_clear_zeros(struct ip
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

