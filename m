Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30EA558272
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiFWRO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiFWRLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:11:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B43517AB7;
        Thu, 23 Jun 2022 09:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10C8261FBF;
        Thu, 23 Jun 2022 16:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83F5C3411B;
        Thu, 23 Jun 2022 16:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003046;
        bh=NngK8zJ9xOgR7UIyAU/43ZE+nhhVWSxmb/OOH9fQejc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnSsJX18XgOwVTCTD99q6/zwGBt6hRCvaLVCQ4HXhJGWaBr0hmxdtLsf5woJ49Iqn
         7cRKHImwgRGekNGjytWwRsDjRzT8rKK6+avBV8NZM0/MDwvmw5iUKoHhMACqhvGlvT
         86dCiDeSLKAs+heGDyNF3Ri4euLOXLz6cKp4KYaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 085/264] random: do not re-init if crng_reseed completes before primary init
Date:   Thu, 23 Jun 2022 18:41:18 +0200
Message-Id: <20220623164346.474751240@linuxfoundation.org>
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

commit 9c3ddde3f811aabbb83778a2a615bf141b4909ef upstream.

If the bootloader supplies sufficient material and crng_reseed() is called
very early on, but not too early that wqs aren't available yet, then we
might transition to crng_init==2 before rand_initialize()'s call to
crng_initialize_primary() made. Then, when crng_initialize_primary() is
called, if we're trusting the CPU's RDRAND instructions, we'll
needlessly reinitialize the RNG and emit a message about it. This is
mostly harmless, as numa_crng_init() will allocate and then free what it
just allocated, and excessive calls to invalidate_batched_entropy()
aren't so harmful. But it is funky and the extra message is confusing,
so avoid the re-initialization all together by checking for crng_init <
2 in crng_initialize_primary(), just as we already do in crng_reseed().

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -829,7 +829,7 @@ static void __init crng_initialize_prima
 {
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
 	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
-	if (crng_init_try_arch_early(crng) && trust_cpu) {
+	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
 		crng_init = 2;


