Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FE086A27
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404740AbfHHTNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405089AbfHHTJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F6921743;
        Thu,  8 Aug 2019 19:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291362;
        bh=Xx7s67zyV53WglYQfrR46qMMLjYFs3VfRWZ/rxu84qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJdfrfNurpMRdYjYtgJqNhNvped2SNpb04WCK+h4Bba1r3oL5SCOCrnCZTuTyzGui
         TkEYFEgAoqtX81LYWP/PnHEihd6JXUdLPHHGewE9O2H46cPPdFD4tt4dbv2Vf34VOG
         CInFYpEOcYjN8uRsfLS9AULAkHh99M1ULYOLNx9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+92209502e7aab127c75f@syzkaller.appspotmail.com,
        syzbot+b972214bb803a343f4fe@syzkaller.appspotmail.com,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 31/45] net/smc: do not schedule tx_work in SMC_CLOSED state
Date:   Thu,  8 Aug 2019 21:05:17 +0200
Message-Id: <20190808190455.513332863@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit f9cedf1a9b1cdcfb0c52edb391d01771e43994a4 ]

The setsockopts options TCP_NODELAY and TCP_CORK may schedule the
tx worker. Make sure the socket is not yet moved into SMC_CLOSED
state (for instance by a shutdown SHUT_RDWR call).

Reported-by: syzbot+92209502e7aab127c75f@syzkaller.appspotmail.com
Reported-by: syzbot+b972214bb803a343f4fe@syzkaller.appspotmail.com
Fixes: 01d2f7e2cdd31 ("net/smc: sockopts TCP_NODELAY and TCP_CORK")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1680,14 +1680,18 @@ static int smc_setsockopt(struct socket
 		}
 		break;
 	case TCP_NODELAY:
-		if (sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) {
+		if (sk->sk_state != SMC_INIT &&
+		    sk->sk_state != SMC_LISTEN &&
+		    sk->sk_state != SMC_CLOSED) {
 			if (val && !smc->use_fallback)
 				mod_delayed_work(system_wq, &smc->conn.tx_work,
 						 0);
 		}
 		break;
 	case TCP_CORK:
-		if (sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) {
+		if (sk->sk_state != SMC_INIT &&
+		    sk->sk_state != SMC_LISTEN &&
+		    sk->sk_state != SMC_CLOSED) {
 			if (!val && !smc->use_fallback)
 				mod_delayed_work(system_wq, &smc->conn.tx_work,
 						 0);


