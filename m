Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209F629B6DE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368756AbgJ0P1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797451AbgJ0PXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A8120657;
        Tue, 27 Oct 2020 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812216;
        bh=02Or6pHaDiuX9m/2Ylacsxcg1BvBcJBydenEo+NgFWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECm1GUjHgH/p9ibOqGmVC4+taRH3DjgFuuCEGEdG2Xd9A4I3gbn01R5rdPoO9+9ST
         C67hgb2WRNwZFZWHbGk5ExsMnfHTxdvwHuxmCizpI/DNAd72XpdiiOhiVGcS4BE2lB
         iHHbrWwTmOeXsd4sG6f/lIoDnQZaPXk/Y7D05KtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 132/757] fscrypt: restrict IV_INO_LBLK_32 to ino_bits <= 32
Date:   Tue, 27 Oct 2020 14:46:22 +0100
Message-Id: <20201027135456.777198259@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 5e895bd4d5233cb054447d0491d4e63c8496d419 ]

When an encryption policy has the IV_INO_LBLK_32 flag set, the IV
generation method involves hashing the inode number.  This is different
from fscrypt's other IV generation methods, where the inode number is
either not used at all or is included directly in the IVs.

Therefore, in principle IV_INO_LBLK_32 can work with any length inode
number.  However, currently fscrypt gets the inode number from
inode::i_ino, which is 'unsigned long'.  So currently the implementation
limit is actually 32 bits (like IV_INO_LBLK_64), since longer inode
numbers will have been truncated by the VFS on 32-bit platforms.

Fix fscrypt_supported_v2_policy() to enforce the correct limit.

This doesn't actually matter currently, since only ext4 and f2fs support
IV_INO_LBLK_32, and they both only support 32-bit inode numbers.  But we
might as well fix it in case it matters in the future.

Ideally inode::i_ino would instead be made 64-bit, but for now it's not
needed.  (Note, this limit does *not* prevent filesystems with 64-bit
inode numbers from adding fscrypt support, since IV_INO_LBLK_* support
is optional and is useful only on certain hardware.)

Fixes: e3b1078bedd3 ("fscrypt: add support for IV_INO_LBLK_32 policies")
Reported-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20200824203841.1707847-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/crypto/policy.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 2d73fd39ad96f..b92f345231780 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -192,10 +192,15 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 					  32, 32))
 		return false;
 
+	/*
+	 * IV_INO_LBLK_32 hashes the inode number, so in principle it can
+	 * support any ino_bits.  However, currently the inode number is gotten
+	 * from inode::i_ino which is 'unsigned long'.  So for now the
+	 * implementation limit is 32 bits.
+	 */
 	if ((policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
-	    /* This uses hashed inode numbers, so ino_bits doesn't matter. */
 	    !supported_iv_ino_lblk_policy(policy, inode, "IV_INO_LBLK_32",
-					  INT_MAX, 32))
+					  32, 32))
 		return false;
 
 	if (memchr_inv(policy->__reserved, 0, sizeof(policy->__reserved))) {
-- 
2.25.1



