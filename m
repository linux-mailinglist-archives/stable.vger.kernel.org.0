Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D212F7950
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbhAOMer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:34:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387525AbhAOMeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:34:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5400923884;
        Fri, 15 Jan 2021 12:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714045;
        bh=ePc4RHuz3oSByRJOaZyYHMVIKa+viM/GlSRP+QYhTUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iungp3SUUxLkT7iseH52AnyUZUOAm6sxbLlWD+xRqSNYinjg/yOoHlPVSgZ0NFvUK
         CtWLToE9qrZDhwjN2K7AMjpAlWmTPZgNGU5fTH19QAkPF3PQhEbgvQAlAnbMaM6Nfa
         xmjPE5PmZtlN1yaAjvjdACb0nxnTLaXWb9wAMWm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 22/62] chtls: Remove invalid set_tcb call
Date:   Fri, 15 Jan 2021 13:27:44 +0100
Message-Id: <20210115121959.484272920@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 827d329105bfde6701f0077e34a09c4a86e27145 ]

At the time of SYN_RECV, connection information is not
initialized at FW, updating tcb flag over uninitialized
connection causes adapter crash. We don't need to
update the flag during SYN_RECV state, so avoid this.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1941,9 +1941,6 @@ static void chtls_abort_req_rss(struct s
 	int queue = csk->txq_idx;
 
 	if (is_neg_adv(req->status)) {
-		if (sk->sk_state == TCP_SYN_RECV)
-			chtls_set_tcb_tflag(sk, 0, 0);
-
 		kfree_skb(skb);
 		return;
 	}


