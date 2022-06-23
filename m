Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4FC5585B0
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiFWSB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiFWSAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0DCB2CF3;
        Thu, 23 Jun 2022 10:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C008461DED;
        Thu, 23 Jun 2022 17:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9596DC3411B;
        Thu, 23 Jun 2022 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004590;
        bh=vTKQqfjX4F70+FXW6akEB42FGx0gbfSWX/LAI81xnYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA94Iyy324iLq3q7pu8oeCEhOTS7MhQc0V79TXLCqn0gOJxbHKZ4Hvx6OAykPff1G
         Jw/Qv67H5MPhfbe+Fvy6V3zAfi4ltM0IXsEcVQLO9lGRYr+13nif5lCmkAu/9GZyEl
         wPIjWaEkk3JPOcbdN1dvd/QHRi1DoV0WuBfWEhCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 079/234] random: make credit_entropy_bits() always safe
Date:   Thu, 23 Jun 2022 18:42:26 +0200
Message-Id: <20220623164345.293829763@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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


