Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E600558332
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiFWR0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbiFWR0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:26:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A398C60E1A;
        Thu, 23 Jun 2022 10:02:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67812B8248C;
        Thu, 23 Jun 2022 17:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6885EC3411B;
        Thu, 23 Jun 2022 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003754;
        bh=c/3QVajyXUvgYbs+hFND6RmbU8EoSZIdAlbVw6MmTwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfNjGtiwS70bW0++htHK1xvnAr296ISJ9ooqgMsbNCAZux3ZtByITaZCVy7DpP7SK
         ru/yb0mQmsScf6S4juCgjlm5aD/1qreh/gjzL3+JD1avHZ0K9A4Ubln6kiBusk+fQ1
         mcaXGzIcgLLtR545DfVCn93G6I4fwg1okT5tRt6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 076/237] random: remove unused extract_entropy() reserved argument
Date:   Thu, 23 Jun 2022 18:41:50 +0200
Message-Id: <20220623164345.338858513@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 8b2d953b91e7f60200c24067ab17b77cc7bfd0d4 upstream.

This argument is always set to zero, as a result of us not caring about
keeping a certain amount reserved in the pool these days. So just remove
it and cleanup the function signatures.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -519,7 +519,7 @@ struct entropy_store {
 };
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-			       size_t nbytes, int min, int rsvd);
+			       size_t nbytes, int min);
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
 				size_t nbytes);
 
@@ -988,7 +988,7 @@ static void crng_reseed(struct crng_stat
 	} buf;
 
 	if (r) {
-		num = extract_entropy(r, &buf, 32, 16, 0);
+		num = extract_entropy(r, &buf, 32, 16);
 		if (num == 0)
 			return;
 	} else {
@@ -1326,8 +1326,7 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
  * This function decides how many bytes to actually take from the
  * given pool, and also debits the entropy count accordingly.
  */
-static size_t account(struct entropy_store *r, size_t nbytes, int min,
-		      int reserved)
+static size_t account(struct entropy_store *r, size_t nbytes, int min)
 {
 	int entropy_count, orig, have_bytes;
 	size_t ibytes, nfrac;
@@ -1341,7 +1340,7 @@ retry:
 	/* never pull more than available */
 	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
 
-	if ((have_bytes -= reserved) < 0)
+	if (have_bytes < 0)
 		have_bytes = 0;
 	ibytes = min_t(size_t, ibytes, have_bytes);
 	if (ibytes < min)
@@ -1447,15 +1446,13 @@ static ssize_t _extract_entropy(struct e
  * returns it in a buffer.
  *
  * The min parameter specifies the minimum amount we can pull before
- * failing to avoid races that defeat catastrophic reseeding while the
- * reserved parameter indicates how much entropy we must leave in the
- * pool after each pull to avoid starving other readers.
+ * failing to avoid races that defeat catastrophic reseeding.
  */
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-				 size_t nbytes, int min, int reserved)
+				 size_t nbytes, int min)
 {
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
-	nbytes = account(r, nbytes, min, reserved);
+	nbytes = account(r, nbytes, min);
 	return _extract_entropy(r, buf, nbytes);
 }
 


