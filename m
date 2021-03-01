Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EED328AAE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbhCASVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:21:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239489AbhCASQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:16:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E11765254;
        Mon,  1 Mar 2021 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619689;
        bh=Xaen+2tNomgp1Bj/b+Bfg7QrMKTzi8/UYwNT7bTctGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTYhCwgCH+wWb68wjgdDqbA7Nf1KUT6tLTsPueoAsYwkxvCudEazNjpFTWVoZq+cP
         QMV3aqhg2n6C32n5ZskMbvYNzRxASugG8HrOGU8qfp7HLZhHhGngOAnmBIUENWnr/H
         BrP24Z5zk+lRc/YRJO9pZAmCqf3LmayYLb7I7hDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 545/663] crypto: sun4i-ss - checking sg length is not sufficient
Date:   Mon,  1 Mar 2021 17:13:13 +0100
Message-Id: <20210301161208.836694175@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

commit 7bdcd851fa7eb66e8922aa7f6cba9e2f2427a7cf upstream.

The optimized cipher function need length multiple of 4 bytes.
But it get sometimes odd length.
This is due to SG data could be stored with an offset.

So the fix is to check also if the offset is aligned with 4 bytes.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -201,12 +201,12 @@ static int sun4i_ss_cipher_poll(struct s
 	 * we can use the SS optimized function
 	 */
 	while (in_sg && no_chunk == 1) {
-		if (in_sg->length % 4)
+		if ((in_sg->length | in_sg->offset) & 3u)
 			no_chunk = 0;
 		in_sg = sg_next(in_sg);
 	}
 	while (out_sg && no_chunk == 1) {
-		if (out_sg->length % 4)
+		if ((out_sg->length | out_sg->offset) & 3u)
 			no_chunk = 0;
 		out_sg = sg_next(out_sg);
 	}


