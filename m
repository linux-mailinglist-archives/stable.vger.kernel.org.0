Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A17C111F2A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfLCWpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728739AbfLCWpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B826207DD;
        Tue,  3 Dec 2019 22:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413102;
        bh=c6CoG+ElvzE2nJ6/nYqSH5WvSz4hUr4TXIojSkX6nYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzBFtC8VIbdP4pKXUMVYUqBkrtwrubvoBQBXFSEiNTxd9LIR4u396dFr0xll7Y+ce
         8UFmp4+fn7buo0kov4ytXW5Nh9Yci6pskyAxNq9XNt06yiXE/Os0PA8uPpyQq3TIRS
         FFW3cxm4XqSsl4/LCt1Ics9wrM0nwOcxT1M+BoF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 126/135] net/tls: remove the dead inplace_crypto code
Date:   Tue,  3 Dec 2019 23:36:06 +0100
Message-Id: <20191203213045.019713052@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 9e5ffed37df68d0ccfb2fdc528609e23a1e70ebe ]

Looks like when BPF support was added by commit d3b18ad31f93
("tls: add bpf support to sk_msg handling") and
commit d829e9c4112b ("tls: convert to generic sk_msg interface")
it broke/removed the support for in-place crypto as added by
commit 4e6d47206c32 ("tls: Add support for inplace records
encryption").

The inplace_crypto member of struct tls_rec is dead, inited
to zero, and sometimes set to zero again. It used to be
set to 1 when record was allocated, but the skmsg code doesn't
seem to have been written with the idea of in-place crypto
in mind.

Since non trivial effort is required to bring the feature back
and we don't really have the HW to measure the benefit just
remove the left over support for now to avoid confusing readers.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h |    1 -
 net/tls/tls_sw.c  |    6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -121,7 +121,6 @@ struct tls_rec {
 	struct list_head list;
 	int tx_ready;
 	int tx_flags;
-	int inplace_crypto;
 
 	struct sk_msg msg_plaintext;
 	struct sk_msg msg_encrypted;
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -705,8 +705,7 @@ static int tls_push_record(struct sock *
 	}
 
 	i = msg_pl->sg.start;
-	sg_chain(rec->sg_aead_in, 2, rec->inplace_crypto ?
-		 &msg_en->sg.data[i] : &msg_pl->sg.data[i]);
+	sg_chain(rec->sg_aead_in, 2, &msg_pl->sg.data[i]);
 
 	i = msg_en->sg.end;
 	sk_msg_iter_var_prev(i);
@@ -971,8 +970,6 @@ alloc_encrypted:
 			if (ret)
 				goto fallback_to_reg_send;
 
-			rec->inplace_crypto = 0;
-
 			num_zc++;
 			copied += try_to_copy;
 
@@ -1171,7 +1168,6 @@ alloc_payload:
 
 		tls_ctx->pending_open_record_frags = true;
 		if (full_record || eor || sk_msg_full(msg_pl)) {
-			rec->inplace_crypto = 0;
 			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
 						  record_type, &copied, flags);
 			if (ret) {


