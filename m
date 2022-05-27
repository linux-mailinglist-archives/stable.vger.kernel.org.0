Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1B2535C06
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350044AbiE0IxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350057AbiE0Iw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:52:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9EC53700;
        Fri, 27 May 2022 01:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7800D61D3D;
        Fri, 27 May 2022 08:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF15C385A9;
        Fri, 27 May 2022 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641533;
        bh=vzwuZWnm6kpqwOb+2kD3Qz0bX3zG6yU4MW7xDk9XB+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/LDAA7/5BkN6haIAwS7FmLePB9txoO62/pY4VvdwZwAxkZxrChmS/m//sOV9xizP
         wK+nxiFEQknMM5sGXu6TYAZC2XFTXUcx4R99t/3YGKKFU1Rs5m4pe2e4sODSaPVXel
         NB1eA9RQk8QIV0IIfjpYZDwIQE8A+nNH0PFp2rMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 08/47] alpha: define get_cycles macro for arch-override
Date:   Fri, 27 May 2022 10:49:48 +0200
Message-Id: <20220527084802.446208511@linuxfoundation.org>
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

commit 1097710bc9660e1e588cf2186a35db3d95c4d258 upstream.

Alpha defines a get_cycles() function, but it does not do the usual
`#define get_cycles get_cycles` dance, making it impossible for generic
code to see if an arch-specific function was defined. While the
get_cycles() ifdef is not currently used, the following timekeeping
patch in this series will depend on the macro existing (or not existing)
when defining random_get_entropy().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Acked-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/asm/timex.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/alpha/include/asm/timex.h
+++ b/arch/alpha/include/asm/timex.h
@@ -28,5 +28,6 @@ static inline cycles_t get_cycles (void)
 	__asm__ __volatile__ ("rpcc %0" : "=r"(ret));
 	return ret;
 }
+#define get_cycles get_cycles
 
 #endif


