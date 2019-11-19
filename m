Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA37010190F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfKSFWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfKSFWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DD121939;
        Tue, 19 Nov 2019 05:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140960;
        bh=zubJqFSCl3jk3PoPLUGNliBu3gPSwgXG+N0VBbZMW4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jprjtI1mgovOpT1p27sq9C8LoQtaj+EsNRcDpQMfptdrgwyXus5wGD/bVRfyYPQvJ
         KqGzVwhW6GZFu4C8n0gP9b0ZEsTwoBVnm15zecdbkDEcyx/AUfgn1I6ZJp6LIB2LmB
         XWICx3qKY1ZgfcTUAdrHo+XsXobaqZI5MeVcGVOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8488cc4cf1c9e09b8b86@syzkaller.appspotmail.com,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 07/48] net/smc: fix fastopen for non-blocking connect()
Date:   Tue, 19 Nov 2019 06:19:27 +0100
Message-Id: <20191119050953.406107089@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit 8204df72bea1a7d83d0777add6da98a41dfbdc34 ]

FASTOPEN does not work with SMC-sockets. Since SMC allows fallback to
TCP native during connection start, the FASTOPEN setsockopts trigger
this fallback, if the SMC-socket is still in state SMC_INIT.
But if a FASTOPEN setsockopt is called after a non-blocking connect(),
this is broken, and fallback does not make sense.
This change complements
commit cd2063604ea6 ("net/smc: avoid fallback in case of non-blocking connect")
and fixes the syzbot reported problem "WARNING in smc_unhash_sk".

Reported-by: syzbot+8488cc4cf1c9e09b8b86@syzkaller.appspotmail.com
Fixes: e1bbdd570474 ("net/smc: reduce sock_put() for fallback sockets")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1731,7 +1731,7 @@ static int smc_setsockopt(struct socket
 	case TCP_FASTOPEN_KEY:
 	case TCP_FASTOPEN_NO_COOKIE:
 		/* option not supported by SMC */
-		if (sk->sk_state == SMC_INIT) {
+		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
 			smc_switch_to_fallback(smc);
 			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
 		} else {


