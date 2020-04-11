Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946811A589B
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgDKXKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729546AbgDKXKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C490F2192A;
        Sat, 11 Apr 2020 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646624;
        bh=q8EPPLSEVbvjnptnecss4LENEF77lwuNgER2TlSMdBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDemGGUf3ixyg80FLyYwHPN3b6Q2yk9YfuleeYmhxCJ+1+AeLoPd/LFqHSobLz/tJ
         ylk4T+pR4Lsp9VrGpOUkhR+X8M1lkiKW+OCon4SKZu3g6MsPAvY4B0FHcbviQnJnCo
         wlkKya8jGLD7R2w+TyPO1bvLXAlco5DzdkylPcFM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 033/108] crypto: chelsio - Endianess bug in create_authenc_wr
Date:   Sat, 11 Apr 2020 19:08:28 -0400
Message-Id: <20200411230943.24951-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ff462ddfd95b915345c3c7c037c3bfafdc58bae7 ]

kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
                - sizeof(chcr_req->key_ctx);
can't possibly be endian-safe.  Look: ->key_ctx_hdr is __be32.  And
KEY_CONTEXT_CTX_LEN_V is "shift up by 24 bits".  On little-endian hosts it
sees
	b0 b1 b2 b3
in memory, inteprets that into b0 + (b1 << 8) + (b2 << 16) + (b3 << 24),
shifts up by 24, resulting in b0 << 24, does ntohl (byteswap on l-e),
gets b0 and shifts that up by 4.  So we get b0 * 16 - sizeof(...).

Sounds reasonable, but on b-e we get
b3 + (b2 << 8) + (b1 << 16) + (b0 << 24), shift up by 24,
yielding b3 << 24, do ntohl (no-op on b-e) and then shift up by 4.
Resulting in b3 << 28 - sizeof(...), i.e. slightly under b3 * 256M.

Then we increase it some more and pass to alloc_skb() as size.
Somehow I doubt that we really want a quarter-gigabyte skb allocation
here...

Note that when you are building those values in
#define  FILL_KEY_CTX_HDR(ck_size, mk_size, d_ck, opad, ctx_len) \
                htonl(KEY_CONTEXT_VALID_V(1) | \
                      KEY_CONTEXT_CK_SIZE_V((ck_size)) | \
                      KEY_CONTEXT_MK_SIZE_V(mk_size) | \
                      KEY_CONTEXT_DUAL_CK_V((d_ck)) | \
                      KEY_CONTEXT_OPAD_PRESENT_V((opad)) | \
                      KEY_CONTEXT_SALT_PRESENT_V(1) | \
                      KEY_CONTEXT_CTX_LEN_V((ctx_len)))
ctx_len ends up in the first octet (i.e. b0 in the above), which
matches the current behaviour on l-e.  If that's the intent, this
thing should've been
        kctx_len = (KEY_CONTEXT_CTX_LEN_G(ntohl(aeadctx->key_ctx_hdr)) << 4)
                - sizeof(chcr_req->key_ctx);
instead - fetch after ntohl() we get (b0 << 24) + (b1 << 16) + (b2 << 8) + b3,
shift it down by 24 (b0), resuling in b0 * 16 - sizeof(...) both on l-e and
on b-e.

PS: when sparse warns you about endianness problems, it might be worth checking
if there really is something wrong.  And I don't mean "slap __force cast on it"...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 01dd418bdadc5..44423a3be3094 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2360,7 +2360,7 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 	snents = sg_nents_xlen(req->src, req->assoclen + req->cryptlen,
 			       CHCR_SRC_SG_SIZE, 0);
 	dst_size = get_space_for_phys_dsgl(dnents);
-	kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
+	kctx_len = (KEY_CONTEXT_CTX_LEN_G(ntohl(aeadctx->key_ctx_hdr)) << 4)
 		- sizeof(chcr_req->key_ctx);
 	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, dst_size);
 	reqctx->imm = (transhdr_len + req->assoclen + req->cryptlen) <
-- 
2.20.1

