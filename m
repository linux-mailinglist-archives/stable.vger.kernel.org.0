Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E70255852B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiFWRyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbiFWRxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:53:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFC3AA328;
        Thu, 23 Jun 2022 10:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 694D8B82498;
        Thu, 23 Jun 2022 17:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AE0C341C5;
        Thu, 23 Jun 2022 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004439;
        bh=GO8ohRsxsQsssNWETF7PtJipysym1ywZrmza87B+8bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNwoIb6qymuj3lKPMDYQIJ/a2rannTM42X0HjpEhJwHe6QjE3BVGmOV2i/+IBa2XP
         lJeRJo1voqgIUiT/3hiXHfiHwJ5W5bsTYIGMdZs1LleTktAtzGcBbHYtleAqmrKWrx
         E4XkHdrGsICRxpZK8f36o0x/i27mx3yfpLKE5hjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Spelvin <lkml@sdf.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 007/234] random: document get_random_int() family
Date:   Thu, 23 Jun 2022 18:41:14 +0200
Message-Id: <20220623164343.261610774@linuxfoundation.org>
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

From: George Spelvin <lkml@sdf.org>

commit 92e507d216139b356a375afbda2824e85235e748 upstream.

Explain what these functions are for and when they offer
an advantage over get_random_bytes().

(We still need documentation on rng_is_initialized(), the
random_ready_callback system, and early boot in general.)

Signed-off-by: George Spelvin <lkml@sdf.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   83 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 7 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -101,15 +101,13 @@
  * Exported interfaces ---- output
  * ===============================
  *
- * There are three exported interfaces; the first is one designed to
- * be used from within the kernel:
+ * There are four exported interfaces; two for use within the kernel,
+ * and two or use from userspace.
  *
- * 	void get_random_bytes(void *buf, int nbytes);
- *
- * This interface will return the requested number of random bytes,
- * and place it in the requested buffer.
+ * Exported interfaces ---- userspace output
+ * -----------------------------------------
  *
- * The two other interfaces are two character devices /dev/random and
+ * The userspace interfaces are two character devices /dev/random and
  * /dev/urandom.  /dev/random is suitable for use when very high
  * quality randomness is desired (for example, for key generation or
  * one-time pads), as it will only return a maximum of the number of
@@ -122,6 +120,77 @@
  * this will result in random numbers that are merely cryptographically
  * strong.  For many applications, however, this is acceptable.
  *
+ * Exported interfaces ---- kernel output
+ * --------------------------------------
+ *
+ * The primary kernel interface is
+ *
+ * 	void get_random_bytes(void *buf, int nbytes);
+ *
+ * This interface will return the requested number of random bytes,
+ * and place it in the requested buffer.  This is equivalent to a
+ * read from /dev/urandom.
+ *
+ * For less critical applications, there are the functions:
+ *
+ * 	u32 get_random_u32()
+ * 	u64 get_random_u64()
+ * 	unsigned int get_random_int()
+ * 	unsigned long get_random_long()
+ *
+ * These are produced by a cryptographic RNG seeded from get_random_bytes,
+ * and so do not deplete the entropy pool as much.  These are recommended
+ * for most in-kernel operations *if the result is going to be stored in
+ * the kernel*.
+ *
+ * Specifically, the get_random_int() family do not attempt to do
+ * "anti-backtracking".  If you capture the state of the kernel (e.g.
+ * by snapshotting the VM), you can figure out previous get_random_int()
+ * return values.  But if the value is stored in the kernel anyway,
+ * this is not a problem.
+ *
+ * It *is* safe to expose get_random_int() output to attackers (e.g. as
+ * network cookies); given outputs 1..n, it's not feasible to predict
+ * outputs 0 or n+1.  The only concern is an attacker who breaks into
+ * the kernel later; the get_random_int() engine is not reseeded as
+ * often as the get_random_bytes() one.
+ *
+ * get_random_bytes() is needed for keys that need to stay secret after
+ * they are erased from the kernel.  For example, any key that will
+ * be wrapped and stored encrypted.  And session encryption keys: we'd
+ * like to know that after the session is closed and the keys erased,
+ * the plaintext is unrecoverable to someone who recorded the ciphertext.
+ *
+ * But for network ports/cookies, stack canaries, PRNG seeds, address
+ * space layout randomization, session *authentication* keys, or other
+ * applications where the sensitive data is stored in the kernel in
+ * plaintext for as long as it's sensitive, the get_random_int() family
+ * is just fine.
+ *
+ * Consider ASLR.  We want to keep the address space secret from an
+ * outside attacker while the process is running, but once the address
+ * space is torn down, it's of no use to an attacker any more.  And it's
+ * stored in kernel data structures as long as it's alive, so worrying
+ * about an attacker's ability to extrapolate it from the get_random_int()
+ * CRNG is silly.
+ *
+ * Even some cryptographic keys are safe to generate with get_random_int().
+ * In particular, keys for SipHash are generally fine.  Here, knowledge
+ * of the key authorizes you to do something to a kernel object (inject
+ * packets to a network connection, or flood a hash table), and the
+ * key is stored with the object being protected.  Once it goes away,
+ * we no longer care if anyone knows the key.
+ *
+ * prandom_u32()
+ * -------------
+ *
+ * For even weaker applications, see the pseudorandom generator
+ * prandom_u32(), prandom_max(), and prandom_bytes().  If the random
+ * numbers aren't security-critical at all, these are *far* cheaper.
+ * Useful for self-tests, random error simulation, randomized backoffs,
+ * and any other application where you trust that nobody is trying to
+ * maliciously mess with you by guessing the "random" numbers.
+ *
  * Exported interfaces ---- input
  * ==============================
  *


