Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949941EAA54
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgFASG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgFASG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:06:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 824C4207D0;
        Mon,  1 Jun 2020 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034818;
        bh=oUUrow9BaLigfYLgQvV/CONmfTcm9hlUNd3VeXm6wCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OD53EG6kOA3xY1bnTzxCXtM+k7pvtTNURJe8/MqZbe601eMt/croMZ2iB2wNvt5CH
         RHhecZwv0c1lfrUmVn+DtH0I5moXwS6XGzBtV2jLnaa6Vhg0kIAYUQbT1PNxmf2q/0
         5USkoJsH73IaUoHuY1HDUan7TVCiq11o+fyc1dvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 027/142] net/tls: fix encryption error checking
Date:   Mon,  1 Jun 2020 19:53:05 +0200
Message-Id: <20200601174040.718668506@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

commit a7bff11f6f9afa87c25711db8050c9b5324db0e2 upstream.

bpf_exec_tx_verdict() can return negative value for copied
variable. In that case this value will be pushed back to caller
and the real error code will be lost. Fix it using signed type and
checking for positive value.

Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tls/tls_sw.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -781,7 +781,7 @@ static int tls_push_record(struct sock *
 
 static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 			       bool full_record, u8 record_type,
-			       size_t *copied, int flags)
+			       ssize_t *copied, int flags)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
@@ -917,7 +917,8 @@ int tls_sw_sendmsg(struct sock *sk, stru
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool eor = !(msg->msg_flags & MSG_MORE);
-	size_t try_to_copy, copied = 0;
+	size_t try_to_copy;
+	ssize_t copied = 0;
 	struct sk_msg *msg_pl, *msg_en;
 	struct tls_rec *rec;
 	int required_size;
@@ -1126,7 +1127,7 @@ send_end:
 
 	release_sock(sk);
 	mutex_unlock(&tls_ctx->tx_lock);
-	return copied ? copied : ret;
+	return copied > 0 ? copied : ret;
 }
 
 static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
@@ -1140,7 +1141,7 @@ static int tls_sw_do_sendpage(struct soc
 	struct sk_msg *msg_pl;
 	struct tls_rec *rec;
 	int num_async = 0;
-	size_t copied = 0;
+	ssize_t copied = 0;
 	bool full_record;
 	int record_room;
 	int ret = 0;
@@ -1242,7 +1243,7 @@ wait_for_memory:
 	}
 sendpage_end:
 	ret = sk_stream_error(sk, flags, ret);
-	return copied ? copied : ret;
+	return copied > 0 ? copied : ret;
 }
 
 int tls_sw_sendpage_locked(struct sock *sk, struct page *page,


