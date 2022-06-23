Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A2B5581AB
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiFWRDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiFWRBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:01:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582424FC6E;
        Thu, 23 Jun 2022 09:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B37D8B82490;
        Thu, 23 Jun 2022 16:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BC7C3411B;
        Thu, 23 Jun 2022 16:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003257;
        bh=Z4K5trf9hQxf9+At5Y5do4u4889G7hzVgVOshj8AtIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5AIim3ewtHSt2MR7qJHCZuyIE5+/rg63vtd0M0HStFnKEBKzVbWbCA7JemfXmML3
         6o2ju7Dlt+P7MtoPjDEmtYMwdR6Iqbo+U0iiGNMR1eEEm6tfsKWPWKpM+yx9L5ojlP
         Bq3qb/Fojske4yHxhc/DR/4EqC2YQFPto83PPBlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 181/264] alpha: define get_cycles macro for arch-override
Date:   Thu, 23 Jun 2022 18:42:54 +0200
Message-Id: <20220623164349.187845555@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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
@@ -27,5 +27,6 @@ static inline cycles_t get_cycles (void)
 	__asm__ __volatile__ ("rpcc %0" : "=r"(ret));
 	return ret;
 }
+#define get_cycles get_cycles
 
 #endif


