Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19B037CC98
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbhELQpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238398AbhELQiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:38:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B23AB61CD3;
        Wed, 12 May 2021 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835381;
        bh=ipny/XQ34DvAw3xp5zETAC8Ek0RH55ndwdTEUk5mhPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNpqHVKVUXlzdQcIPJ1QhnNwQk2bNjq1swDxNOwHrpmyV262O0Xr4pJBytRPVqgX8
         mp568Au/vns0ZmRhnXBTHbYeOHpPqebSD74B6LNYiykXhb4kL2vo1SkYqhQlf2HnTE
         nZwAlQKVC7egcmjfQfPGu6LNLGtc1nQwC0conIzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 321/677] crypto: arm64/aes-ce - deal with oversight in new CTR carry code
Date:   Wed, 12 May 2021 16:46:07 +0200
Message-Id: <20210512144847.896548602@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 0f19dbc994dcb7f7137f2e056e813c84530b7538 ]

The new carry handling code in the CTR driver can deal with a carry
occurring in the 4x/5x parallel code path, by using a computed goto to
jump into the carry sequence at the right place as to only apply the
carry to a subset of the blocks being processed.

If the lower half of the counter wraps and ends up at exactly 0x0, a
carry needs to be applied to the counter, but not to the counter values
taken for the 4x/5x parallel sequence. In this case, the computed goto
skips all register assignments, and branches straight to the jump
instruction that gets us back to the fast path. This produces the
correct result, but due to the fact that this branch target does not
carry the correct BTI annotation, this fails when BTI is enabled.

Let's omit the computed goto entirely in this case, and jump straight
back to the fast path after applying the carry to the main counter.

Fixes: 5318d3db465d ("crypto: arm64/aes-ctr - improve tail handling")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/crypto/aes-modes.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index bbdb54702aa7..247011356d11 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -359,6 +359,7 @@ ST5(	mov		v4.16b, vctr.16b		)
 	ins		vctr.d[0], x8
 
 	/* apply carry to N counter blocks for N := x12 */
+	cbz		x12, 2f
 	adr		x16, 1f
 	sub		x16, x16, x12, lsl #3
 	br		x16
-- 
2.30.2



