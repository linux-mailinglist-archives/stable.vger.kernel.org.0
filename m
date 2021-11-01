Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4DA44170A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhKAJcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232626AbhKAJaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E0461166;
        Mon,  1 Nov 2021 09:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758618;
        bh=xV6huBq/8AAwUIXxkZGe2Hy8XE+oBm9XoPD/WP7bLAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGLl/Zw1F0x5B8AEmAx7hZSZmDNKFS6vprZHO7LTjC1rg4hpm86XdBl0i2e6aOTpI
         hOaXCBHNs7EEp+dJbM7zBuD/l9nLtyanoe76wSf9TCF7XbfFdUL33dQWAdNOdNvi9J
         JbT4IeE9ufdjyXoM5ibKlwKFP0zIwLwoDwjYEBlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 38/51] net/tls: Fix flipped sign in async_wait.err assignment
Date:   Mon,  1 Nov 2021 10:17:42 +0100
Message-Id: <20211101082509.577418454@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
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
@@ -456,7 +456,7 @@ static void tls_encrypt_done(struct cryp
 
 		/* If err is already set on socket, return the same code */
 		if (sk->sk_err) {
-			ctx->async_wait.err = sk->sk_err;
+			ctx->async_wait.err = -sk->sk_err;
 		} else {
 			ctx->async_wait.err = err;
 			tls_err_abort(sk, err);


