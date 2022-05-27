Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EE153613A
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350445AbiE0MBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352403AbiE0MA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D840CD12E;
        Fri, 27 May 2022 04:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38BAB61DD0;
        Fri, 27 May 2022 11:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7C9C385A9;
        Fri, 27 May 2022 11:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652335;
        bh=N+njQa8dbPvGRCd+m8kR8WWw+lhJD4cHuiN1wI+6arY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FD+27LUXrEN7IC9MbWDVCTEtUCSeTSTWpgF4DTWnKSbQTCH4EOXsy0B5ME1eUvUN7
         dFO2OaBt7dTgfkDupzHu62ITsjwYWLOujXpEEKl/l52NDeKKGLdFS7fanDq9yQ/oSL
         QXRDNCyAAWnMFI+DIZ1C9UaLOiWRd+gEyODlKDFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 111/145] riscv: use fallback for random_get_entropy() instead of zero
Date:   Fri, 27 May 2022 10:50:12 +0200
Message-Id: <20220527084904.029665777@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
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

commit 6d01238623faa9425f820353d2066baf6c9dc872 upstream.

In the event that random_get_entropy() can't access a cycle counter or
similar, falling back to returning 0 is really not the best we can do.
Instead, at least calling random_get_entropy_fallback() would be
preferable, because that always needs to return _something_, even
falling back to jiffies eventually. It's not as though
random_get_entropy_fallback() is super high precision or guaranteed to
be entropic, but basically anything that's not zero all the time is
better than returning zero all the time.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/timex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/timex.h
+++ b/arch/riscv/include/asm/timex.h
@@ -41,7 +41,7 @@ static inline u32 get_cycles_hi(void)
 static inline unsigned long random_get_entropy(void)
 {
 	if (unlikely(clint_time_val == NULL))
-		return 0;
+		return random_get_entropy_fallback();
 	return get_cycles();
 }
 #define random_get_entropy()	random_get_entropy()


