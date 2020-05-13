Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044231D0F33
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbgEMJqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732622AbgEMJqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5359320769;
        Wed, 13 May 2020 09:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363183;
        bh=6ztlRlz7oiWaw7gMJj+ZOGLSCzvFoCC7WQl3BbDZwrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4xUdgL9QKisyTCGxsB06C/Y5vwKlebgOn0P/ZGtFtpV1IPC2B4GAHFhYNLisB1Vc
         oCEsajjN4cagQb90156RYT9Df36wn8ZDqSmijM4tbWNjvCnmA2xoYv7Q/FQ/RJdpGi
         CYtRKBprUyWySNZdkX0YRTglT7dg81HxqJaDB36E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Dial <scott@scottdial.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 06/48] net: macsec: preserve ingress frame ordering
Date:   Wed, 13 May 2020 11:44:32 +0200
Message-Id: <20200513094353.396369414@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Dial <scott@scottdial.com>

[ Upstream commit ab046a5d4be4c90a3952a0eae75617b49c0cb01b ]

MACsec decryption always occurs in a softirq context. Since
the FPU may not be usable in the softirq context, the call to
decrypt may be scheduled on the cryptd work queue. The cryptd
work queue does not provide ordering guarantees. Therefore,
preserving order requires masking out ASYNC implementations
of gcm(aes).

For instance, an Intel CPU with AES-NI makes available the
generic-gcm-aesni driver from the aesni_intel module to
implement gcm(aes). However, this implementation requires
the FPU, so it is not always available to use from a softirq
context, and will fallback to the cryptd work queue, which
does not preserve frame ordering. With this change, such a
system would select gcm_base(ctr(aes-aesni),ghash-generic).
While the aes-aesni implementation prefers to use the FPU, it
will fallback to the aes-asm implementation if unavailable.

By using a synchronous version of gcm(aes), the decryption
will complete before returning from crypto_aead_decrypt().
Therefore, the macsec_decrypt_done() callback will be called
before returning from macsec_decrypt(). Thus, the order of
calls to macsec_post_decrypt() for the frames is preserved.

While it's presumable that the pure AES-NI version of gcm(aes)
is more performant, the hybrid solution is capable of gigabit
speeds on modest hardware. Regardless, preserving the order
of frames is paramount for many network protocols (e.g.,
triggering TCP retries). Within the MACsec driver itself, the
replay protection is tripped by the out-of-order frames, and
can cause frames to be dropped.

This bug has been present in this code since it was added in
v4.6, however it may not have been noticed since not all CPUs
have FPU offload available. Additionally, the bug manifests
as occasional out-of-order packets that are easily
misattributed to other network phenomena.

When this code was added in v4.6, the crypto/gcm.c code did
not restrict selection of the ghash function based on the
ASYNC flag. For instance, x86 CPUs with PCLMULQDQ would
select the ghash-clmulni driver instead of ghash-generic,
which submits to the cryptd work queue if the FPU is busy.
However, this bug was was corrected in v4.8 by commit
b30bdfa86431afbafe15284a3ad5ac19b49b88e3, and was backported
all the way back to the v3.14 stable branch, so this patch
should be applicable back to the v4.6 stable branch.

Signed-off-by: Scott Dial <scott@scottdial.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1313,7 +1313,8 @@ static struct crypto_aead *macsec_alloc_
 	struct crypto_aead *tfm;
 	int ret;
 
-	tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
+	/* Pick a sync gcm(aes) cipher to ensure order is preserved. */
+	tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm))
 		return tfm;


