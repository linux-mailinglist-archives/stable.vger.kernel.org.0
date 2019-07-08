Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F116240F
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389261AbfGHP2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389277AbfGHP2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5533A21537;
        Mon,  8 Jul 2019 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599703;
        bh=II54N9oyz9p4+uMfs8XurpWIeyvXpBd2PwxshOEByrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5qixreJixuIZ6SD0u+EUOYlla5g70gB//JeAgvFv8E0UGKCDVOHHCnpDZ95QfdQJ
         ivADcdXrj5PX4njU66MtvFqP3e+/2Gqi0avFkST/r1gRw3xMvAdZRUc4WKQM1GOhr8
         CD9NzHpi5QaSJaggEzE9HqsqnUXBlsSs/LwpvbV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f7baccc38dcc1e094e77@syzkaller.appspotmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4.19 50/90] lib/mpi: Fix karactx leak in mpi_powm
Date:   Mon,  8 Jul 2019 17:13:17 +0200
Message-Id: <20190708150525.072211436@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit c8ea9fce2baf7b643384f36f29e4194fa40d33a6 upstream.

Sometimes mpi_powm will leak karactx because a memory allocation
failure causes a bail-out that skips the freeing of karactx.  This
patch moves the freeing of karactx to the end of the function like
everything else so that it can't be skipped.

Reported-by: syzbot+f7baccc38dcc1e094e77@syzkaller.appspotmail.com
Fixes: cdec9cb5167a ("crypto: GnuPG based MPI lib - source files...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/mpi/mpi-pow.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/lib/mpi/mpi-pow.c
+++ b/lib/mpi/mpi-pow.c
@@ -37,6 +37,7 @@
 int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 {
 	mpi_ptr_t mp_marker = NULL, bp_marker = NULL, ep_marker = NULL;
+	struct karatsuba_ctx karactx = {};
 	mpi_ptr_t xp_marker = NULL;
 	mpi_ptr_t tspace = NULL;
 	mpi_ptr_t rp, ep, mp, bp;
@@ -163,13 +164,11 @@ int mpi_powm(MPI res, MPI base, MPI exp,
 		int c;
 		mpi_limb_t e;
 		mpi_limb_t carry_limb;
-		struct karatsuba_ctx karactx;
 
 		xp = xp_marker = mpi_alloc_limb_space(2 * (msize + 1));
 		if (!xp)
 			goto enomem;
 
-		memset(&karactx, 0, sizeof karactx);
 		negative_result = (ep[0] & 1) && base->sign;
 
 		i = esize - 1;
@@ -294,8 +293,6 @@ int mpi_powm(MPI res, MPI base, MPI exp,
 		if (mod_shift_cnt)
 			mpihelp_rshift(rp, rp, rsize, mod_shift_cnt);
 		MPN_NORMALIZE(rp, rsize);
-
-		mpihelp_release_karatsuba_ctx(&karactx);
 	}
 
 	if (negative_result && rsize) {
@@ -312,6 +309,7 @@ int mpi_powm(MPI res, MPI base, MPI exp,
 leave:
 	rc = 0;
 enomem:
+	mpihelp_release_karatsuba_ctx(&karactx);
 	if (assign_rp)
 		mpi_assign_limb_space(res, rp, size);
 	if (mp_marker)


