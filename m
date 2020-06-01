Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013301EACE6
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgFASMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731274AbgFASMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72EF2068D;
        Mon,  1 Jun 2020 18:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035168;
        bh=+6uWsY7u/0ao6fwktwEQt/Lkr+S2jHqRI6sY4YA+hgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGAAOVetQGrgDJnFjR59dKL+gXxnHqymD+lcTUVd5u0zXR54edbp4MvdDt6J+wi5K
         utHqvforjarYeak4aPrW/tLDz0tAndw1lu0TTSpeneAlz26WkrL7sh4sGrRttDJcWM
         T9cihtjz5HXIVDyK4XdWZ9dYUjbH82zScm0X8Q1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 038/177] net/tls: free record only on encryption error
Date:   Mon,  1 Jun 2020 19:52:56 +0200
Message-Id: <20200601174052.161084901@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

commit 635d9398178659d8ddba79dd061f9451cec0b4d1 upstream.

We cannot free record on any transient error because it leads to
losing previos data. Check socket error to know whether record must
be freed or not.

Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tls/tls_sw.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -800,9 +800,10 @@ static int bpf_exec_tx_verdict(struct sk
 	psock = sk_psock_get(sk);
 	if (!psock || !policy) {
 		err = tls_push_record(sk, flags, record_type);
-		if (err && err != -EINPROGRESS) {
+		if (err && sk->sk_err == EBADMSG) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
+			err = -sk->sk_err;
 		}
 		if (psock)
 			sk_psock_put(sk, psock);
@@ -828,9 +829,10 @@ more_data:
 	switch (psock->eval) {
 	case __SK_PASS:
 		err = tls_push_record(sk, flags, record_type);
-		if (err && err != -EINPROGRESS) {
+		if (err && sk->sk_err == EBADMSG) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
+			err = -sk->sk_err;
 			goto out_err;
 		}
 		break;


