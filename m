Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F959536023
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiE0Lqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351895AbiE0LpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:45:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8664A12FEF1;
        Fri, 27 May 2022 04:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E688761CB7;
        Fri, 27 May 2022 11:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01207C385A9;
        Fri, 27 May 2022 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651681;
        bh=S0GE2QBe3vQH8SstAe6gAuiluPqa7/LtbKcsMUsmrik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrJhyAqqbHcxsgY8nfx5mdqciGBrDuuP+26bG7sABZobqCs3GPkQdksVsWsuwsroR
         6sURFgeoba76yHZfMsf/eTyAFtqMU1PronOsaOmqlxF/XyK+KbgS5fKdrJ7Y8V0gXH
         zf3PSjlT5GIECwGaO6q6l/FGSBwUWGORGWn/CX7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Helge Deller <deller@gmx.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 071/111] parisc: define get_cycles macro for arch-override
Date:   Fri, 27 May 2022 10:49:43 +0200
Message-Id: <20220527084829.568165652@linuxfoundation.org>
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

commit 8865bbe6ba1120e67f72201b7003a16202cd42be upstream.

PA-RISC defines a get_cycles() function, but it does not do the usual
`#define get_cycles get_cycles` dance, making it impossible for generic
code to see if an arch-specific function was defined. While the
get_cycles() ifdef is not currently used, the following timekeeping
patch in this series will depend on the macro existing (or not existing)
when defining random_get_entropy().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Helge Deller <deller@gmx.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/timex.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/timex.h
+++ b/arch/parisc/include/asm/timex.h
@@ -13,9 +13,10 @@
 
 typedef unsigned long cycles_t;
 
-static inline cycles_t get_cycles (void)
+static inline cycles_t get_cycles(void)
 {
 	return mfctl(16);
 }
+#define get_cycles get_cycles
 
 #endif


