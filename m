Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E1F4417E0
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbhKAJkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233630AbhKAJho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD7961350;
        Mon,  1 Nov 2021 09:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758791;
        bh=iSymP04eayXhdaeGBYoXyAWFkq35uLJ1B/yaG+QOIgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHtgPPp9ayEdVUc0WfnMDGHg/MW4pYPZC0vZHeqD84iCiL0XZ2RxZYQFZlx7NRu6a
         PO9bGK5/XKEKe3CngCF6qZgHFUMoSz4uZM9tCHbUICv54rV+ilKsRkgYC2xoDx+kpQ
         nd7sODQui2QFV3Qn/fneqtgmCkFUANYec8bTDM3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 60/77] net/tls: Fix flipped sign in async_wait.err assignment
Date:   Mon,  1 Nov 2021 10:17:48 +0100
Message-Id: <20211101082524.264945476@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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


