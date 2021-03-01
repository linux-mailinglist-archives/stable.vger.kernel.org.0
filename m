Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F623285BF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhCAQ6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235794AbhCAQwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:52:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A19564FB5;
        Mon,  1 Mar 2021 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616405;
        bh=wYYQUZI4Lv7Vc+6cscue2zINWcEHnylnQDKnVEuSZ/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajpOEKOwWKNEBNNtop1HDf/W9v/dyyPOu0Bso99ItX/OlgJslcvBRCOLJelr/92qj
         VhSakJ3Cf/RHvqziGKKBeInUTFI+KsQg6/OwnU/vYW2f51x4gFpL7jyQjGPGDyZxTs
         kGyYkltaMxmLaFZYAKPkzDzt5YCHqj42SFQmBSf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 141/176] crypto: sun4i-ss - checking sg length is not sufficient
Date:   Mon,  1 Mar 2021 17:13:34 +0100
Message-Id: <20210301161028.012954010@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -189,12 +189,12 @@ static int sun4i_ss_cipher_poll(struct s
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


