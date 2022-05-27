Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819FA536002
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244438AbiE0LoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351832AbiE0LoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:44:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C15A106A45;
        Fri, 27 May 2022 04:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16523CE2511;
        Fri, 27 May 2022 11:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2250DC385A9;
        Fri, 27 May 2022 11:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651657;
        bh=aOprigIcG/hpSAFQqHtR2NrqFIOQ6+qE+2D3VkQdaoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAcxjOFuoJNwkonmM5uClXAxtyJCbApeuglmS9N5vl4uB9aZxDFnnIzSmsnRIZgfU
         ozoxG3IL4uTjWiDyZudZ30Ys9PKsoQaoEk2g9nKEZ7pFVpuPA7MEeXJY4UbDVgPCoE
         GZEBav1E9Fr4JiPqZOU+LkbNEpgYAUOaZvQDFKSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 044/163] random: remove unused extract_entropy() reserved argument
Date:   Fri, 27 May 2022 10:48:44 +0200
Message-Id: <20220527084834.198560148@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 
@@ -989,7 +989,7 @@ static void crng_reseed(struct crng_stat
 	} buf;
 
 	if (r) {
-		num = extract_entropy(r, &buf, 32, 16, 0);
+		num = extract_entropy(r, &buf, 32, 16);
 		if (num == 0)
 			return;
 	} else {
@@ -1327,8 +1327,7 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
  * This function decides how many bytes to actually take from the
  * given pool, and also debits the entropy count accordingly.
  */
-static size_t account(struct entropy_store *r, size_t nbytes, int min,
-		      int reserved)
+static size_t account(struct entropy_store *r, size_t nbytes, int min)
 {
 	int entropy_count, orig, have_bytes;
 	size_t ibytes, nfrac;
@@ -1342,7 +1341,7 @@ retry:
 	/* never pull more than available */
 	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
 
-	if ((have_bytes -= reserved) < 0)
+	if (have_bytes < 0)
 		have_bytes = 0;
 	ibytes = min_t(size_t, ibytes, have_bytes);
 	if (ibytes < min)
@@ -1448,15 +1447,13 @@ static ssize_t _extract_entropy(struct e
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
 


