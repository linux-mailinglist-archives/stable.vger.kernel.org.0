Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC1D6239E
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390388AbfGHPdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390398AbfGHPdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:33:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 483F720665;
        Mon,  8 Jul 2019 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600015;
        bh=II54N9oyz9p4+uMfs8XurpWIeyvXpBd2PwxshOEByrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imjfrNwRF+InIqtOfoetEWG3UYMn0eRijtSXQC20py5k3xPmwrP5uCPaWfPohimjB
         y5nHASE6qZLtg6PCqOkT0j/hpAlJM/ajVJiDV+EVNb7ZTBNURdCmoC0BgtSoIyTyPH
         UYE6Uei8X1VFQd271vInhxa2JG9+z+E6ClN/s7FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f7baccc38dcc1e094e77@syzkaller.appspotmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.1 66/96] lib/mpi: Fix karactx leak in mpi_powm
Date:   Mon,  8 Jul 2019 17:13:38 +0200
Message-Id: <20190708150530.038193433@linuxfoundation.org>
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


