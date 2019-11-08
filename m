Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34613F567F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391750AbfKHTJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391265AbfKHTJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE28620673;
        Fri,  8 Nov 2019 19:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240151;
        bh=bFVV/iIHpHr3hvUTYGoxW8Qv37Qz2Fo++BWXnU1I4B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uReeluiVI6mJtytiBbi+WcGBr+82VT2hD+23tKVb8IIrXabtnZB2oBZB1yoxhCw7E
         NhSFomFuvKGLqsKfzJzPPUsoHsJ2697mDkRahVuNUrv4jnYyrkRDRHEXM3W3ZkTu/s
         e6NEbG+KVludph1aCmPEkluU349CJqvi8ZNdRxDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 105/140] net/smc: fix closing of fallback SMC sockets
Date:   Fri,  8 Nov 2019 19:50:33 +0100
Message-Id: <20191108174911.545592682@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit f536dffc0b79738c3104af999318279dccbaa261 ]

For SMC sockets forced to fallback to TCP, the file is propagated
from the outer SMC to the internal TCP socket. When closing the SMC
socket, the internal TCP socket file pointer must be restored to the
original NULL value, otherwise memory leaks may show up (found with
CONFIG_DEBUG_KMEMLEAK).

The internal TCP socket is released in smc_clcsock_release(), which
calls __sock_release() function in net/socket.c. This calls the
needed iput(SOCK_INODE(sock)) only, if the file pointer has been reset
to the original NULL-value.

Fixes: 07603b230895 ("net/smc: propagate file from SMC to TCP socket")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -123,6 +123,12 @@ struct proto smc_proto6 = {
 };
 EXPORT_SYMBOL_GPL(smc_proto6);
 
+static void smc_restore_fallback_changes(struct smc_sock *smc)
+{
+	smc->clcsock->file->private_data = smc->sk.sk_socket;
+	smc->clcsock->file = NULL;
+}
+
 static int __smc_release(struct smc_sock *smc)
 {
 	struct sock *sk = &smc->sk;
@@ -141,6 +147,7 @@ static int __smc_release(struct smc_sock
 		}
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk);
+		smc_restore_fallback_changes(smc);
 	}
 
 	sk->sk_prot->unhash(sk);


