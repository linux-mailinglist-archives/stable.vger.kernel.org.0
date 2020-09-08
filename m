Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95D626198E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbgIHSVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731463AbgIHQLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F1F224734;
        Tue,  8 Sep 2020 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579658;
        bh=BaR3Q+Wii/OZ1NeyQdL6A+0hfF+tUl1OXApdXXhNhBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eShw3GQcqroG6qw5IFcNo07m0xSd6xHmVIHrUtTVzVNcRnK0OvbV2hwm8LlGqtKnx
         5TTNRtUHbT/FVeovLaW/XeOHVeQwv2L0h4pmQ81LwDCLUJ+bRl4uoMR4MS4xjaNFzj
         YjUGjVs1FmvTpWYI8j4jgswWfaFP8Y41CXnictRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.8 168/186] dm crypt: Initialize crypto wait structures
Date:   Tue,  8 Sep 2020 17:25:10 +0200
Message-Id: <20200908152249.802852415@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 7785a9e4c228db6d01086a52d5685cd7336a08b7 upstream.

Use the DECLARE_CRYPTO_WAIT() macro to properly initialize the crypto
wait structures declared on stack before their use with
crypto_wait_req().

Fixes: 39d13a1ac41d ("dm crypt: reuse eboiv skcipher for IV generation")
Fixes: bbb1658461ac ("dm crypt: Implement Elephant diffuser for Bitlocker compatibility")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -736,7 +736,7 @@ static int crypt_iv_eboiv_gen(struct cry
 	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
 	struct skcipher_request *req;
 	struct scatterlist src, dst;
-	struct crypto_wait wait;
+	DECLARE_CRYPTO_WAIT(wait);
 	int err;
 
 	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
@@ -933,7 +933,7 @@ static int crypt_iv_elephant(struct cryp
 	u8 *es, *ks, *data, *data2, *data_offset;
 	struct skcipher_request *req;
 	struct scatterlist *sg, *sg2, src, dst;
-	struct crypto_wait wait;
+	DECLARE_CRYPTO_WAIT(wait);
 	int i, r;
 
 	req = skcipher_request_alloc(elephant->tfm, GFP_NOIO);


