Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753D8536175
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351812AbiE0L5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353333AbiE0L4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536A7F25;
        Fri, 27 May 2022 04:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E483061D56;
        Fri, 27 May 2022 11:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBE1C385A9;
        Fri, 27 May 2022 11:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652294;
        bh=Af/mC/zq4tKhaB0LwhH5Vk0R8nnqO8wO9ms7HejQAZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQT4Gg26JeLMBR6D4Ua4uAN8AAuoWqZKn3RH4h803NpCuzvBgt9++kN5mi7PNzqc8
         XKGFLVBc8gHFB62biunS9ctkuuFkJsNr8t1XddhCS3N1kKbx5VTwWNWnT33aGkwsDL
         Ewi1OWo6y4AWZsgNhc6goVT0x3IR5BM0uDgPA4Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 130/163] mips: use fallback for random_get_entropy() instead of just c0 random
Date:   Fri, 27 May 2022 10:50:10 +0200
Message-Id: <20220527084846.169779937@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 1c99c6a7c3c599a68321b01b9ec243215ede5a68 upstream.

For situations in which we don't have a c0 counter register available,
we've been falling back to reading the c0 "random" register, which is
usually bounded by the amount of TLB entries and changes every other
cycle or so. This means it wraps extremely often. We can do better by
combining this fast-changing counter with a potentially slower-changing
counter from random_get_entropy_fallback() in the more significant bits.
This commit combines the two, taking into account that the changing bits
are in a different bit position depending on the CPU model. In addition,
we previously were falling back to 0 for ancient CPUs that Linux does
not support anyway; remove that dead path entirely.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Tested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/timex.h |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/arch/mips/include/asm/timex.h
+++ b/arch/mips/include/asm/timex.h
@@ -76,25 +76,24 @@ static inline cycles_t get_cycles(void)
 	else
 		return 0;	/* no usable counter */
 }
+#define get_cycles get_cycles
 
 /*
  * Like get_cycles - but where c0_count is not available we desperately
  * use c0_random in an attempt to get at least a little bit of entropy.
- *
- * R6000 and R6000A neither have a count register nor a random register.
- * That leaves no entropy source in the CPU itself.
  */
 static inline unsigned long random_get_entropy(void)
 {
-	unsigned int prid = read_c0_prid();
-	unsigned int imp = prid & PRID_IMP_MASK;
+	unsigned int c0_random;
 
-	if (can_use_mips_counter(prid))
+	if (can_use_mips_counter(read_c0_prid()))
 		return read_c0_count();
-	else if (likely(imp != PRID_IMP_R6000 && imp != PRID_IMP_R6000A))
-		return read_c0_random();
+
+	if (cpu_has_3kex)
+		c0_random = (read_c0_random() >> 8) & 0x3f;
 	else
-		return 0;	/* no usable register */
+		c0_random = read_c0_random() & 0x3f;
+	return (random_get_entropy_fallback() << 6) | (0x3f - c0_random);
 }
 #define random_get_entropy random_get_entropy
 


