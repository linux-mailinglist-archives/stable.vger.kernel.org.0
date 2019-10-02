Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34B1C91CF
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbfJBTIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35282 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729059AbfJBTIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-00035e-RL; Wed, 02 Oct 2019 20:08:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-0003bG-EA; Wed, 02 Oct 2019 20:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "Xin Long" <lucien.xin@gmail.com>,
        "Andrey Konovalov" <andreyknvl@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "WANG Cong" <xiyou.wangcong@gmail.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.784749873@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 18/87] igmp: acquire pmc lock for ip_mc_clear_src()
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

From: WANG Cong <xiyou.wangcong@gmail.com>

commit c38b7d327aafd1e3ad7ff53eefac990673b65667 upstream.

Andrey reported a use-after-free in add_grec():

        for (psf = *psf_list; psf; psf = psf_next) {
		...
                psf_next = psf->sf_next;

where the struct ip_sf_list's were already freed by:

 kfree+0xe8/0x2b0 mm/slub.c:3882
 ip_mc_clear_src+0x69/0x1c0 net/ipv4/igmp.c:2078
 ip_mc_dec_group+0x19a/0x470 net/ipv4/igmp.c:1618
 ip_mc_drop_socket+0x145/0x230 net/ipv4/igmp.c:2609
 inet_release+0x4e/0x1c0 net/ipv4/af_inet.c:411
 sock_release+0x8d/0x1e0 net/socket.c:597
 sock_close+0x16/0x20 net/socket.c:1072

This happens because we don't hold pmc->lock in ip_mc_clear_src()
and a parallel mr_ifc_timer timer could jump in and access them.

The RCU lock is there but it is merely for pmc itself, this
spinlock could actually ensure we don't access them in parallel.

Thanks to Eric and Long for discussion on this bug.

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/igmp.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1880,21 +1880,26 @@ static int ip_mc_add_src(struct in_devic
 
 static void ip_mc_clear_src(struct ip_mc_list *pmc)
 {
-	struct ip_sf_list *psf, *nextpsf;
+	struct ip_sf_list *psf, *nextpsf, *tomb, *sources;
 
-	for (psf = pmc->tomb; psf; psf = nextpsf) {
+	spin_lock_bh(&pmc->lock);
+	tomb = pmc->tomb;
+	pmc->tomb = NULL;
+	sources = pmc->sources;
+	pmc->sources = NULL;
+	pmc->sfmode = MCAST_EXCLUDE;
+	pmc->sfcount[MCAST_INCLUDE] = 0;
+	pmc->sfcount[MCAST_EXCLUDE] = 1;
+	spin_unlock_bh(&pmc->lock);
+
+	for (psf = tomb; psf; psf = nextpsf) {
 		nextpsf = psf->sf_next;
 		kfree(psf);
 	}
-	pmc->tomb = NULL;
-	for (psf = pmc->sources; psf; psf = nextpsf) {
+	for (psf = sources; psf; psf = nextpsf) {
 		nextpsf = psf->sf_next;
 		kfree(psf);
 	}
-	pmc->sources = NULL;
-	pmc->sfmode = MCAST_EXCLUDE;
-	pmc->sfcount[MCAST_INCLUDE] = 0;
-	pmc->sfcount[MCAST_EXCLUDE] = 1;
 }
 
 

