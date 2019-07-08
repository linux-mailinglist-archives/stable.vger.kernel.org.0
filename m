Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD25262396
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390285AbfGHPdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390272AbfGHPdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:33:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D12B216E3;
        Mon,  8 Jul 2019 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599988;
        bh=YfYnE2EjNzOFpBmQyvvAYXtKa4/nrf6T7RqUEnwwf8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZxLz+eZkGZh6xiJPM0vhh9eWdVNS1EqkEEVzFBzEuf1FrEa88mRJteXaJqu6KTM7
         0touDKqohWGOWKXFpt/oeMAFcVfyUzHsrEDFzOdE28UOYghDTSk9x+rX7wyBAVxfuq
         suNpQ962WBFu77tLpWzIp5MOJEvQOcCIZG2FskFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 58/96] crypto: cryptd - Fix skcipher instance memory leak
Date:   Mon,  8 Jul 2019 17:13:30 +0200
Message-Id: <20190708150529.641082612@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit 1a0fad630e0b7cff38e7691b28b0517cfbb0633f upstream.

cryptd_skcipher_free() fails to free the struct skcipher_instance
allocated in cryptd_create_skcipher(), leading to a memory leak.  This
is detected by kmemleak on bootup on ARM64 platforms:

 unreferenced object 0xffff80003377b180 (size 1024):
   comm "cryptomgr_probe", pid 822, jiffies 4294894830 (age 52.760s)
   backtrace:
     kmem_cache_alloc_trace+0x270/0x2d0
     cryptd_create+0x990/0x124c
     cryptomgr_probe+0x5c/0x1e8
     kthread+0x258/0x318
     ret_from_fork+0x10/0x1c

Fixes: 4e0958d19bd8 ("crypto: cryptd - Add support for skcipher")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/cryptd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -586,6 +586,7 @@ static void cryptd_skcipher_free(struct
 	struct skcipherd_instance_ctx *ctx = skcipher_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ctx->spawn);
+	kfree(inst);
 }
 
 static int cryptd_create_skcipher(struct crypto_template *tmpl,


