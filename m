Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FA744188A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhKAJtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234222AbhKAJrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A32613D0;
        Mon,  1 Nov 2021 09:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759045;
        bh=iSymP04eayXhdaeGBYoXyAWFkq35uLJ1B/yaG+QOIgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSmg2U9peoVewmOKiCzrgk6BD9Z2Y4ahfnGSrtRKgQ0WDcmOtdgLuOqir2MSk8AjV
         f1nB0son8mgdwXSr1R6QzVLsNCeEHydOcQiBzdYEjBn4vLqn1nfiwVMzryD/SfaFOF
         tqONECKpAwj+oL7kzeKCOfVpbw3ttjQ/Kr0uZqnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 091/125] net/tls: Fix flipped sign in async_wait.err assignment
Date:   Mon,  1 Nov 2021 10:17:44 +0100
Message-Id: <20211101082550.322947855@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit 1d9d6fd21ad4a28b16ed9ee5432ae738b9dc58aa upstream.

sk->sk_err contains a positive number, yet async_wait.err wants the
opposite.  Fix the missed sign flip, which Jakub caught by inspection.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -459,7 +459,7 @@ static void tls_encrypt_done(struct cryp
 
 		/* If err is already set on socket, return the same code */
 		if (sk->sk_err) {
-			ctx->async_wait.err = sk->sk_err;
+			ctx->async_wait.err = -sk->sk_err;
 		} else {
 			ctx->async_wait.err = err;
 			tls_err_abort(sk, err);


