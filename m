Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372795360ED
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353064AbiE0MBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241611AbiE0L70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:59:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B28A1A9;
        Fri, 27 May 2022 04:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EF8A61DDC;
        Fri, 27 May 2022 11:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDBEC385A9;
        Fri, 27 May 2022 11:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652332;
        bh=N4I2vRnlz5HhcFVb3tpYEZeesn0q49B0+WAvsvwec5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDQzce7i31Hb11iIIzxzM+qv573T4RMyap/7uB1LSx1zkFJY1y2bFK0HZOLfXwXZJ
         4couJ9UgQi6g8QJ73303MgUKUr28hqfMjMkPJG/59vGnLrQ5QocVmyeA3zjtT6BBGW
         Uue2CMkPoLSq2Qrb0JbhmcCjbIfM+GVzyBPLa9Hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@ozlabs.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 126/163] powerpc: define get_cycles macro for arch-override
Date:   Fri, 27 May 2022 10:50:06 +0200
Message-Id: <20220527084845.533280818@linuxfoundation.org>
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


