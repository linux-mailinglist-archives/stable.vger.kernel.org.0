Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5452014B63C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgA1ODh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbgA1ODh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F2DD24691;
        Tue, 28 Jan 2020 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220217;
        bh=YMLFAG4IzFk7w7pAcWRjtZubbB+Sd1vhE6LDzldamo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYoJMNPJRaMFwfOoftNj/8/w8qSHT0ypW1L/pFWVx8HFn3QQko+Ic56oU8RTdsKo9
         E7TCiiE0xIScIghRjb6hk4DyulPL6ZpzISnlUp1ueWuZJy0EXuPrINKgEWi7pxH9Tm
         RjqdxlogHt0AiL3c72E4nM93Wvcb4taa572dQ/q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mallesham Jatharakonda 
        <mallesham.jatharakonda@oneconvergence.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 063/104] net/tls: fix async operation
Date:   Tue, 28 Jan 2020 15:00:24 +0100
Message-Id: <20200128135826.241608399@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

commit db885e66d268884dc72967279b7e84f522556abc upstream.

Mallesham reports the TLS with async accelerator was broken by
commit d10523d0b3d7 ("net/tls: free the record on encryption error")
because encryption can return -EINPROGRESS in such setups, which
should not be treated as an error.

The error is also present in the BPF path (likely copied from there).

Reported-by: Mallesham Jatharakonda <mallesham.jatharakonda@oneconvergence.com>
Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tls/tls_sw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -793,7 +793,7 @@ static int bpf_exec_tx_verdict(struct sk
 	psock = sk_psock_get(sk);
 	if (!psock || !policy) {
 		err = tls_push_record(sk, flags, record_type);
-		if (err) {
+		if (err && err != -EINPROGRESS) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 		}
@@ -819,7 +819,7 @@ more_data:
 	switch (psock->eval) {
 	case __SK_PASS:
 		err = tls_push_record(sk, flags, record_type);
-		if (err < 0) {
+		if (err && err != -EINPROGRESS) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 			goto out_err;


