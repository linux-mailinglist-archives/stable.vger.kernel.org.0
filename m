Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E4F29B5F3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901179AbgJ0PSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794813AbgJ0PSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B75C72224A;
        Tue, 27 Oct 2020 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811884;
        bh=5a+DCJKtBG8G1Ol7P11ykdRfcDzfQXtZ8zNxZhg3XCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alL6JwETDWdPnCB6oCMu5shzZhH1kjWuZkP/3nRyHDNb9tSQwlj6f32GxzmzV7HM6
         5vqqCRxPVXaCdsJnX3+gDf3fPizEoAM/FKEhIvZNb+vZcng7/osQc4TXPTxFsaZhrH
         EgpeEqWLSjMMK6D9AJgRSVeFrlbZXzyVmSq+kK6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 017/757] net/tls: sendfile fails with ktls offload
Date:   Tue, 27 Oct 2020 14:44:27 +0100
Message-Id: <20201027135451.332460669@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>

[ Upstream commit ea1dd3e9d080c961b9a451130b61c72dc9a5397b ]

At first when sendpage gets called, if there is more data, 'more' in
tls_push_data() gets set which later sets pending_open_record_frags, but
when there is no more data in file left, and last time tls_push_data()
gets called, pending_open_record_frags doesn't get reset. And later when
2 bytes of encrypted alert comes as sendmsg, it first checks for
pending_open_record_frags, and since this is set, it creates a record with
0 data bytes to encrypt, meaning record length is prepend_size + tag_size
only, which causes problem.
 We should set/reset pending_open_record_frags based on more bit.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -418,14 +418,14 @@ static int tls_push_data(struct sock *sk
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
-	int more = flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE);
 	struct tls_record_info *record = ctx->open_record;
 	int tls_push_record_flags;
 	struct page_frag *pfrag;
 	size_t orig_size = size;
 	u32 max_open_record_len;
-	int copy, rc = 0;
+	bool more = false;
 	bool done = false;
+	int copy, rc = 0;
 	long timeo;
 
 	if (flags &
@@ -492,9 +492,8 @@ handle_error:
 		if (!size) {
 last_record:
 			tls_push_record_flags = flags;
-			if (more) {
-				tls_ctx->pending_open_record_frags =
-						!!record->num_frags;
+			if (flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE)) {
+				more = true;
 				break;
 			}
 
@@ -526,6 +525,8 @@ last_record:
 		}
 	} while (!done);
 
+	tls_ctx->pending_open_record_frags = more;
+
 	if (orig_size - size > 0)
 		rc = orig_size - size;
 


