Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD922535C53
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349253AbiE0I6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350301AbiE0I5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:57:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B836C119044;
        Fri, 27 May 2022 01:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13504CE237A;
        Fri, 27 May 2022 08:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052A6C385B8;
        Fri, 27 May 2022 08:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641682;
        bh=vTKQqfjX4F70+FXW6akEB42FGx0gbfSWX/LAI81xnYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1S//vrJmpwF4ZW6mcuvu556w5GTpbrSc4xnml/u9PVFgEN581goqSpqrCIw/2qN45
         I3nI5YBp3/bUOPz3Uclim1cuSvWqM/8Xz6daMh6jjeBOafWwNcbw5dqoJNcdgUCsLL
         nufI3+Z/1ozHtpd23cgoNx+l5VAofHiR8PrUMUTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 007/111] random: make credit_entropy_bits() always safe
Date:   Fri, 27 May 2022 10:48:39 +0200
Message-Id: <20220527084820.150052298@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
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

commit a49c010e61e1938be851f5e49ac219d49b704103 upstream.

This is called from various hwgenerator drivers, so rather than having
one "safe" version for userspace and one "unsafe" version for the
kernel, just make everything safe; the checks are cheap and sensible to
have anyway.

Reported-by: Sultan Alsawaf <sultan@kerneltoast.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -447,18 +447,15 @@ static void process_random_ready_list(vo
 	spin_unlock_irqrestore(&random_ready_list_lock, flags);
 }
 
-/*
- * Credit (or debit) the entropy store with n bits of entropy.
- * Use credit_entropy_bits_safe() if the value comes from userspace
- * or otherwise should be checked for extreme values.
- */
 static void credit_entropy_bits(int nbits)
 {
 	int entropy_count, orig;
 
-	if (!nbits)
+	if (nbits <= 0)
 		return;
 
+	nbits = min(nbits, POOL_BITS);
+
 	do {
 		orig = READ_ONCE(input_pool.entropy_count);
 		entropy_count = min(POOL_BITS, orig + nbits);
@@ -470,18 +467,6 @@ static void credit_entropy_bits(int nbit
 		crng_reseed(&primary_crng, true);
 }
 
-static int credit_entropy_bits_safe(int nbits)
-{
-	if (nbits < 0)
-		return -EINVAL;
-
-	/* Cap the value to avoid overflows */
-	nbits = min(nbits, POOL_BITS);
-
-	credit_entropy_bits(nbits);
-	return 0;
-}
-
 /*********************************************************************
  *
  * CRNG using CHACHA20
@@ -1526,7 +1511,10 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		return credit_entropy_bits_safe(ent_count);
+		if (ent_count < 0)
+			return -EINVAL;
+		credit_entropy_bits(ent_count);
+		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -1539,7 +1527,8 @@ static long random_ioctl(struct file *f,
 		retval = write_pool((const char __user *)p, size);
 		if (retval < 0)
 			return retval;
-		return credit_entropy_bits_safe(ent_count);
+		credit_entropy_bits(ent_count);
+		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
 		/*


