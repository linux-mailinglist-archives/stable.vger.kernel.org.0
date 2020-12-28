Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6A42E3FBD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503738AbgL1O0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503736AbgL1O0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0174620715;
        Mon, 28 Dec 2020 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165556;
        bh=gvMcVUzKsXet3MnHcTMbgtBrN6esXF7gH4hk6t7bmAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRYPED2ZSEtFE0k+7rz47XeR/JoBQu6PXLd1xFpUKBVwbMxQImrMMWfOP2DlZqhaK
         36mWKx1UQi3Nzs4LdhPbns+QkkkDVWJnxxgUcMENthdZ6jh7rjiK3piSmoo7sbOvxg
         xPHJrXbc3qiqzK5rZqEQ3IM8V4zpif3dLDe8AedE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 572/717] crypto: arm/aes-ce - work around Cortex-A57/A72 silion errata
Date:   Mon, 28 Dec 2020 13:49:30 +0100
Message-Id: <20201228125048.322133271@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit f3456b9fd269c6d0c973b136c5449d46b2510f4b upstream.

ARM Cortex-A57 and Cortex-A72 cores running in 32-bit mode are affected
by silicon errata #1742098 and #1655431, respectively, where the second
instruction of a AES instruction pair may execute twice if an interrupt
is taken right after the first instruction consumes an input register of
which a single 32-bit lane has been updated the last time it was modified.

This is not such a rare occurrence as it may seem: in counter mode, only
the least significant 32-bit word is incremented in the absence of a
carry, which makes our counter mode implementation susceptible to these
errata.

So let's shuffle the counter assignments around a bit so that the most
recent updates when the AES instruction pair executes are 128-bit wide.

[0] ARM-EPM-049219 v23 Cortex-A57 MPCore Software Developers Errata Notice
[1] ARM-EPM-012079 v11.0 Cortex-A72 MPCore Software Developers Errata Notice

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/crypto/aes-ce-core.S |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -386,20 +386,32 @@ ENTRY(ce_aes_ctr_encrypt)
 .Lctrloop4x:
 	subs		r4, r4, #4
 	bmi		.Lctr1x
-	add		r6, r6, #1
+
+	/*
+	 * NOTE: the sequence below has been carefully tweaked to avoid
+	 * a silicon erratum that exists in Cortex-A57 (#1742098) and
+	 * Cortex-A72 (#1655431) cores, where AESE/AESMC instruction pairs
+	 * may produce an incorrect result if they take their input from a
+	 * register of which a single 32-bit lane has been updated the last
+	 * time it was modified. To work around this, the lanes of registers
+	 * q0-q3 below are not manipulated individually, and the different
+	 * counter values are prepared by successive manipulations of q7.
+	 */
+	add		ip, r6, #1
 	vmov		q0, q7
+	rev		ip, ip
+	add		lr, r6, #2
+	vmov		s31, ip			@ set lane 3 of q1 via q7
+	add		ip, r6, #3
+	rev		lr, lr
 	vmov		q1, q7
-	rev		ip, r6
-	add		r6, r6, #1
+	vmov		s31, lr			@ set lane 3 of q2 via q7
+	rev		ip, ip
 	vmov		q2, q7
-	vmov		s7, ip
-	rev		ip, r6
-	add		r6, r6, #1
+	vmov		s31, ip			@ set lane 3 of q3 via q7
+	add		r6, r6, #4
 	vmov		q3, q7
-	vmov		s11, ip
-	rev		ip, r6
-	add		r6, r6, #1
-	vmov		s15, ip
+
 	vld1.8		{q4-q5}, [r1]!
 	vld1.8		{q6}, [r1]!
 	vld1.8		{q15}, [r1]!


