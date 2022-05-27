Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB7535C16
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350087AbiE0Iw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350094AbiE0Iwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:52:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9904856216;
        Fri, 27 May 2022 01:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C0161D3D;
        Fri, 27 May 2022 08:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07E1C385A9;
        Fri, 27 May 2022 08:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641537;
        bh=N4I2vRnlz5HhcFVb3tpYEZeesn0q49B0+WAvsvwec5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjUkyyFQDIPxdrCFI3CgiQs3R1EQtUio2+yhuu7IVp56w9bZP0eMoh2tQ0ZWAXdm0
         xZ3VH7deMwpP/3dJ+OyeqIMdV5kzD9BglLE4FYnwvHlfCjMhNFmEetKr26OMZUGdhR
         Vupr74FsafY1MT9Et8+PB45C15iTeFqWFZNPemgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@ozlabs.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 09/47] powerpc: define get_cycles macro for arch-override
Date:   Fri, 27 May 2022 10:49:49 +0200
Message-Id: <20220527084802.605486650@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
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

commit 408835832158df0357e18e96da7f2d1ed6b80e7f upstream.

PowerPC defines a get_cycles() function, but it does not do the usual
`#define get_cycles get_cycles` dance, making it impossible for generic
code to see if an arch-specific function was defined. While the
get_cycles() ifdef is not currently used, the following timekeeping
patch in this series will depend on the macro existing (or not existing)
when defining random_get_entropy().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/timex.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/include/asm/timex.h
+++ b/arch/powerpc/include/asm/timex.h
@@ -19,6 +19,7 @@ static inline cycles_t get_cycles(void)
 {
 	return mftb();
 }
+#define get_cycles get_cycles
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_TIMEX_H */


