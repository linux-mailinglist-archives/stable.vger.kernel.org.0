Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C616A09CD
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbjBWNKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbjBWNKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:10:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1222956537
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCE07616EC
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE704C433D2;
        Thu, 23 Feb 2023 13:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157795;
        bh=jY/TG1R6ZV98n2nfEV8cPpanCMp0NeNMImzorczH3mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xMpKvINSjLwSfSXKEZ4uY2Xi/bhWpyQHBwxyG088+JyXGThbGy//8pEtcBStkdby
         TPIN5gGSt1s52NXZ1M/V1gsAJUp78AnDXml8XsrHElFAcw32i+iCgVicC74hyA2hpv
         QDCfJeUE/5zU+u928CXW1oMDMgd1iZPDH/j9kmvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        PaX Team <pageexec@freemail.hu>,
        Emese Revfy <re.emese@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/46] random: always mix cycle counter in add_latent_entropy()
Date:   Thu, 23 Feb 2023 14:06:19 +0100
Message-Id: <20230223130432.115880300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit d7bf7f3b813e3755226bcb5114ad2ac477514ebf ]

add_latent_entropy() is called every time a process forks, in
kernel_clone(). This in turn calls add_device_randomness() using the
latent entropy global state. add_device_randomness() does two things:

   2) Mixes into the input pool the latent entropy argument passed; and
   1) Mixes in a cycle counter, a sort of measurement of when the event
      took place, the high precision bits of which are presumably
      difficult to predict.

(2) is impossible without CONFIG_GCC_PLUGIN_LATENT_ENTROPY=y. But (1) is
always possible. However, currently CONFIG_GCC_PLUGIN_LATENT_ENTROPY=n
disables both (1) and (2), instead of just (2).

This commit causes the CONFIG_GCC_PLUGIN_LATENT_ENTROPY=n case to still
do (1) by passing NULL (len 0) to add_device_randomness() when add_latent_
entropy() is called.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Emese Revfy <re.emese@gmail.com>
Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/random.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index bd954ecbef901..51133627ba73a 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -19,14 +19,14 @@ void add_input_randomness(unsigned int type, unsigned int code,
 void add_interrupt_randomness(int irq) __latent_entropy;
 void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
-#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
 {
+#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
-}
 #else
-static inline void add_latent_entropy(void) { }
+	add_device_randomness(NULL, 0);
 #endif
+}
 
 #if IS_ENABLED(CONFIG_VMGENID)
 void add_vmfork_randomness(const void *unique_vm_id, size_t len);
-- 
2.39.0



