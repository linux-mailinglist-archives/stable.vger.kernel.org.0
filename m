Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C4F549277
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbiFMOtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241892AbiFMOqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:46:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427B3C045D;
        Mon, 13 Jun 2022 04:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DABFB80ECD;
        Mon, 13 Jun 2022 11:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C1EC34114;
        Mon, 13 Jun 2022 11:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121157;
        bh=PuqB4YyKvwdx+4buQKALMr2m1gWs1fXxzTsrNCO7bpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVM6M2Kb4o2XW0F7XBwzTXXrGDHSlZBZ3/i0NOkYYlNcf/5E0o+pidcXLK3x8JWc8
         ZbTqMsDq54sT9OEa2id3tLlOdrgJ5hHwUS0aOQVBsuKZp2+Fhk0Tk2mq5nRaGnrDmj
         ewSgSP9uH61roYqQxnE++w5PPJVwSQEz8/Sh2KMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 292/298] random: mark bootloader randomness code as __init
Date:   Mon, 13 Jun 2022 12:13:06 +0200
Message-Id: <20220613094933.935156347@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 39e0f991a62ed5efabd20711a7b6e7da92603170 upstream.

add_bootloader_randomness() and the variables it touches are only used
during __init and not after, so mark these as __init. At the same time,
unexport this, since it's only called by other __init code that's
built-in.

Cc: stable@vger.kernel.org
Fixes: 428826f5358c ("fdt: add support for rng-seed")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |    7 +++----
 include/linux/random.h |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -789,8 +789,8 @@ static void __cold _credit_init_bits(siz
  *
  **********************************************************************/
 
-static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
-static bool trust_bootloader __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER);
+static bool trust_cpu __initdata = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
+static bool trust_bootloader __initdata = IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER);
 static int __init parse_trust_cpu(char *arg)
 {
 	return kstrtobool(arg, &trust_cpu);
@@ -886,13 +886,12 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_random
  * Handle random seed passed by bootloader, and credit it if
  * CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  */
-void __cold add_bootloader_randomness(const void *buf, size_t len)
+void __init add_bootloader_randomness(const void *buf, size_t len)
 {
 	mix_pool_bytes(buf, len);
 	if (trust_bootloader)
 		credit_init_bits(len * 8);
 }
-EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
 struct fast_pool {
 	struct work_struct mix;
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -13,7 +13,7 @@
 struct notifier_block;
 
 void add_device_randomness(const void *buf, size_t len);
-void add_bootloader_randomness(const void *buf, size_t len);
+void __init add_bootloader_randomness(const void *buf, size_t len);
 void add_input_randomness(unsigned int type, unsigned int code,
 			  unsigned int value) __latent_entropy;
 void add_interrupt_randomness(int irq) __latent_entropy;


