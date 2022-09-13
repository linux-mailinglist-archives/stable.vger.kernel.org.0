Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276085B706B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiIMO0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiIMOZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:25:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E2F58B4F;
        Tue, 13 Sep 2022 07:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92183B80EFC;
        Tue, 13 Sep 2022 14:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEFBC433D6;
        Tue, 13 Sep 2022 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078504;
        bh=HS2roA9G01cpdQH+6ACcYZ8syFpKwUpCdVOO2iIMwL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITZ5JNTUjwe0+CzrN/88hd9GFJLXnvoKVwkUKfITWa3sR+s6xm4eBY18mDljy4d0u
         J2NsVGljufioonctU4m7ObGt0XYj4xMTjkHEd7ZhOodZiPtEfSbKS2ZaQJjQzoBp8l
         E99pIzAyLvNZYsqb4oUrlervvx0+yhL2ccrYaoSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 158/192] ASoC: mchp-spdiftx: Fix clang -Wbitfield-constant-conversion
Date:   Tue, 13 Sep 2022 16:04:24 +0200
Message-Id: <20220913140417.902031066@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 5c5c2baad2b55cc0a4b190266889959642298f79 upstream.

A recent change in clang strengthened its -Wbitfield-constant-conversion
to warn when 1 is assigned to a 1-bit signed integer bitfield, as it can
only be 0 or -1, not 1:

  sound/soc/atmel/mchp-spdiftx.c:505:20: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
          dev->gclk_enabled = 1;
                            ^ ~
  1 error generated.

The actual value of the field is never checked, just that it is not
zero, so there is not a real bug here. However, it is simple enough to
silence the warning by making the bitfield unsigned, which matches the
mchp-spdifrx driver.

Fixes: 06ca24e98e6b ("ASoC: mchp-spdiftx: add driver for S/PDIF TX Controller")
Link: https://github.com/ClangBuiltLinux/linux/issues/1686
Link: https://github.com/llvm/llvm-project/commit/82afc9b169a67e8b8a1862fb9c41a2cd974d6691
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20220810010809.2024482-1-nathan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/atmel/mchp-spdiftx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/atmel/mchp-spdiftx.c
+++ b/sound/soc/atmel/mchp-spdiftx.c
@@ -196,7 +196,7 @@ struct mchp_spdiftx_dev {
 	struct clk				*pclk;
 	struct clk				*gclk;
 	unsigned int				fmt;
-	int					gclk_enabled:1;
+	unsigned int				gclk_enabled:1;
 };
 
 static inline int mchp_spdiftx_is_running(struct mchp_spdiftx_dev *dev)


