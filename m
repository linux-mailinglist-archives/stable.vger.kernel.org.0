Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575A5157A60
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgBJNWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgBJMhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:25 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05E2D20842;
        Mon, 10 Feb 2020 12:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338245;
        bh=EtqAip2wnqvoXOp3+xaMnhpjYdXXYLsB5O4YTrNPBjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLP/hwqN+O57rLZIKkQTjWv9aqRiT4PxzzFzK5Wzb7GKYhjVL3V+iQRXPaLUPIdJH
         8UYWPTNDeVYOiNCkCSGfdmITivVCi4nrszxgBR87OcqdBe2TlKP2ZpP2wscm4fgset
         JlR1Zl2JGlGyHCXJi56mJMyFpyXqJyVPpZaQ8bx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 103/309] crypto: ccree - fix AEAD decrypt auth fail
Date:   Mon, 10 Feb 2020 04:30:59 -0800
Message-Id: <20200210122416.168542999@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit 2a6bc713f1cef32e39e3c4e6f2e1a9849da6379c upstream.

On AEAD decryption authentication failure we are suppose to
zero out the output plaintext buffer. However, we've missed
skipping the optional associated data that may prefix the
ciphertext. This commit fixes this issue.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: e88b27c8eaa8 ("crypto: ccree - use std api sg_zero_buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_aead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -237,7 +237,7 @@ static void cc_aead_complete(struct devi
 			 * revealed the decrypted message --> zero its memory.
 			 */
 			sg_zero_buffer(areq->dst, sg_nents(areq->dst),
-				       areq->cryptlen, 0);
+				       areq->cryptlen, areq->assoclen);
 			err = -EBADMSG;
 		}
 	/*ENCRYPT*/


