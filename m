Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7668E409139
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbhIMOAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245657AbhIMN5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BEB560462;
        Mon, 13 Sep 2021 13:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540202;
        bh=lNnfIkoxkGMnhxc9WgDuAvO438LsQOi8NKlR+JJQBKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/eOkN8Ag0YbBDs6zgCskc9BIouQedA6ad8jQLaP/TPO2fu4cq56fSu9pRngyapSK
         VKTXf5huVEDlA5HT/BhCdHiWBk/aPMjDNXrL5+duDt5F1X6dT/rWW3rkVSQRyyrQDP
         p4d2ZzsQcnG8tD1Q4Vnb6s/W9DgQ53BNP99ms9wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongbo Li <herberthbli@tencent.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 062/300] lib/mpi: use kcalloc in mpi_resize
Date:   Mon, 13 Sep 2021 15:12:03 +0200
Message-Id: <20210913131111.456055790@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongbo Li <herberthbli@tencent.com>

[ Upstream commit b6f756726e4dfe75be1883f6a0202dcecdc801ab ]

We should set the additional space to 0 in mpi_resize().
So use kcalloc() instead of kmalloc_array().

In lib/mpi/ec.c:
/****************
 * Resize the array of A to NLIMBS. the additional space is cleared
 * (set to 0) [done by m_realloc()]
 */
int mpi_resize(MPI a, unsigned nlimbs)

Like the comment of kernel's mpi_resize() said, the additional space
need to be set to 0, but when a->d is not NULL, it does not set.

The kernel's mpi lib is from libgcrypt, the mpi resize in libgcrypt
is _gcry_mpi_resize() which set the additional space to 0.

This bug may cause mpi api which use mpi_resize() get wrong result
under the condition of using the additional space without initiation.
If this condition is not met, the bug would not be triggered.
Currently in kernel, rsa, sm2 and dh use mpi lib, and they works well,
so the bug is not triggered in these cases.

add_points_edwards() use the additional space directly, so it will
get a wrong result.

Fixes: cdec9cb5167a ("crypto: GnuPG based MPI lib - source files (part 1)")
Signed-off-by: Hongbo Li <herberthbli@tencent.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/mpi/mpiutil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mpi/mpiutil.c b/lib/mpi/mpiutil.c
index 3c63710c20c6..e6c4b3180ab1 100644
--- a/lib/mpi/mpiutil.c
+++ b/lib/mpi/mpiutil.c
@@ -148,7 +148,7 @@ int mpi_resize(MPI a, unsigned nlimbs)
 		return 0;	/* no need to do it */
 
 	if (a->d) {
-		p = kmalloc_array(nlimbs, sizeof(mpi_limb_t), GFP_KERNEL);
+		p = kcalloc(nlimbs, sizeof(mpi_limb_t), GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
 		memcpy(p, a->d, a->alloced * sizeof(mpi_limb_t));
-- 
2.30.2



