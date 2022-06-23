Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25AB55868D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbiFWSOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbiFWSNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:13:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6B89A852;
        Thu, 23 Jun 2022 10:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A42CB824B8;
        Thu, 23 Jun 2022 17:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FD3C3411B;
        Thu, 23 Jun 2022 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004872;
        bh=ZIGf3OIICc/ZkZtAiW0hV2LGkW+W99wy51TwniPPSIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPUmdnYXoDJwLTYOyxUKjMOHJOYLahYxh99r2zqYtqFFXxJ+wgbNAvM5H0yEyjeUR
         nH5Sh4WZ2UCYzqgeLG+myHTLpt0uR//d2+V2FlN2FzKwJ7Q7HwWtZDlOSsQEE60VpR
         0p7CQQgXfKcIJUHrsIrpkxph+zxDOCv8WIxab+e0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 178/234] random: avoid checking crng_ready() twice in random_init()
Date:   Thu, 23 Jun 2022 18:44:05 +0200
Message-Id: <20220623164348.088536062@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit 9b29b6b20376ab64e1b043df6301d8a92378e631 upstream.

The current flow expands to:

    if (crng_ready())
       ...
    else if (...)
        if (!crng_ready())
            ...

The second crng_ready() call is redundant, but can't so easily be
optimized out by the compiler.

This commit simplifies that to:

    if (crng_ready()
        ...
    else if (...)
        ...

Fixes: 560181c27b58 ("random: move initialization functions out of hot pages")
Cc: stable@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -834,7 +834,7 @@ int __init random_init(const char *comma
 	if (crng_ready())
 		crng_reseed();
 	else if (trust_cpu)
-		credit_init_bits(arch_bytes * 8);
+		_credit_init_bits(arch_bytes * 8);
 
 	return 0;
 }


