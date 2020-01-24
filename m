Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B68148048
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbgAXLJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731391AbgAXLJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:09:31 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 012FD20663;
        Fri, 24 Jan 2020 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864170;
        bh=WGMkkEwBEFh8uETLno4+HXpzwOrbp4/bVvc4bg1aMgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFV0Gk7BviwF6yYHpSRlIUsTqGgoTm85F/kvnutVPLf5cGvDQ6cjsewAmVhoUHBSC
         Ubg4NhPgUkVw9P1WPzXoKtiKmcac/Ty/qdhiECGlRwuVIRN3YboSHfzjNnOPb3dqdQ
         nqcEMzAjllTcTcQ/Au2UgMMV/LXkOZWyGoUjlwQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Syromiatnikov <esyr@redhat.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 178/639] net/smc: original socket family in inet_sock_diag
Date:   Fri, 24 Jan 2020 10:25:48 +0100
Message-Id: <20200124093109.468776492@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 232dc8ef647658a5352da807d9e994e0e03b43cd ]

Commit ed75986f4aae ("net/smc: ipv6 support for smc_diag.c") changed the
value of the diag_family field. The idea was to indicate the family of
the IP address in the inet_diag_sockid field. But the change makes it
impossible to distinguish an inet_sock_diag response message from SMC
sock_diag response. This patch restores the original behaviour and sends
AF_SMC as value of the diag_family field.

Fixes: ed75986f4aae ("net/smc: ipv6 support for smc_diag.c")
Reported-by: Eugene Syromiatnikov <esyr@redhat.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_diag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index dbf64a93d68ad..371b4cf31fcd2 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -38,6 +38,7 @@ static void smc_diag_msg_common_fill(struct smc_diag_msg *r, struct sock *sk)
 {
 	struct smc_sock *smc = smc_sk(sk);
 
+	r->diag_family = sk->sk_family;
 	if (!smc->clcsock)
 		return;
 	r->id.idiag_sport = htons(smc->clcsock->sk->sk_num);
@@ -45,14 +46,12 @@ static void smc_diag_msg_common_fill(struct smc_diag_msg *r, struct sock *sk)
 	r->id.idiag_if = smc->clcsock->sk->sk_bound_dev_if;
 	sock_diag_save_cookie(sk, r->id.idiag_cookie);
 	if (sk->sk_protocol == SMCPROTO_SMC) {
-		r->diag_family = PF_INET;
 		memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
 		memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
 		r->id.idiag_src[0] = smc->clcsock->sk->sk_rcv_saddr;
 		r->id.idiag_dst[0] = smc->clcsock->sk->sk_daddr;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (sk->sk_protocol == SMCPROTO_SMC6) {
-		r->diag_family = PF_INET6;
 		memcpy(&r->id.idiag_src, &smc->clcsock->sk->sk_v6_rcv_saddr,
 		       sizeof(smc->clcsock->sk->sk_v6_rcv_saddr));
 		memcpy(&r->id.idiag_dst, &smc->clcsock->sk->sk_v6_daddr,
-- 
2.20.1



