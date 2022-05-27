Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB2B535F8F
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349039AbiE0LkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351717AbiE0LkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:40:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8AC131F14;
        Fri, 27 May 2022 04:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9487B824DF;
        Fri, 27 May 2022 11:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C48C385A9;
        Fri, 27 May 2022 11:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651545;
        bh=GttTWEuZi0EVDiRVwcJjYuVxU22fnz52STZBwAgK7Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQS+REzZreFsoagyHk+xoeN0RR7i9FX9YDwu2FPJHJ7uUB1nwyCT7hr5IfSRD5JUY
         GRx419mwhpKCajajhAbsAOYAWLor2WyA130euyO7voF7iGomJVKiSKZqqCFnKRBCdG
         JzBjoRGgSh93EwLBNDK2WynQYtpwILpDgSoB6L9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 015/145] random: do not re-init if crng_reseed completes before primary init
Date:   Fri, 27 May 2022 10:48:36 +0200
Message-Id: <20220527084852.847058474@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
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
@@ -827,7 +827,7 @@ static void __init crng_initialize_prima
 {
 	chacha_init_consts(crng->state);
 	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
-	if (crng_init_try_arch_early(crng) && trust_cpu) {
+	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
 		crng_init = 2;


