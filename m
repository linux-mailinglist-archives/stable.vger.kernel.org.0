Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5232595DB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbgIAP4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731831AbgIAPos (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A2F206FA;
        Tue,  1 Sep 2020 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975087;
        bh=NkA8PEf4GzDYWrPWLhgilQx3bxTCKVY7CDrjO5GtJRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/AVI4iSEhwCpcqNyMp8tiuuBVtgA0TLM/TCKo22QUN82tpqIhxa6PfxhMw2iTCMP
         dGboiqE27ciOjPCgY5JsgJ1h3BdRcVAoR8daQkDCbzp1fnNCbrZ+rvh7WbG6AEXeQc
         oiQImvZGOmcN6ZFaXQUP+dzzJa070tdNeGZkl5f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Caleb Jorden <caljorden@hotmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.8 204/255] crypto: af_alg - Work around empty control messages without MSG_MORE
Date:   Tue,  1 Sep 2020 17:11:00 +0200
Message-Id: <20200901151010.473261674@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit c195d66a8a75c60515819b101975f38b7ec6577f upstream.

The iwd daemon uses libell which sets up the skcipher operation with
two separate control messages.  As the first control message is sent
without MSG_MORE, it is interpreted as an empty request.

While libell should be fixed to use MSG_MORE where appropriate, this
patch works around the bug in the kernel so that existing binaries
continue to work.

We will print a warning however.

A separate issue is that the new kernel code no longer allows the
control message to be sent twice within the same request.  This
restriction is obviously incompatible with what iwd was doing (first
setting an IV and then sending the real control message).  This
patch changes the kernel so that this is explicitly allowed.

Reported-by: Caleb Jorden <caljorden@hotmail.com>
Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/af_alg.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/rwsem.h>
+#include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/security.h>
 
@@ -847,9 +848,15 @@ int af_alg_sendmsg(struct socket *sock,
 	}
 
 	lock_sock(sk);
-	if (ctx->init && (init || !ctx->more)) {
-		err = -EINVAL;
-		goto unlock;
+	if (ctx->init && !ctx->more) {
+		if (ctx->used) {
+			err = -EINVAL;
+			goto unlock;
+		}
+
+		pr_info_once(
+			"%s sent an empty control message without MSG_MORE.\n",
+			current->comm);
 	}
 	ctx->init = true;
 


