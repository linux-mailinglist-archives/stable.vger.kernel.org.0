Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2EC5481A8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238850AbiFMIGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 04:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbiFMIGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 04:06:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25DC1DA6B
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 01:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6944FB80D8B
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 08:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49B8C34114;
        Mon, 13 Jun 2022 08:06:15 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QiaI8boK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655107573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i5gIktZxlqBTbiJQsNZFNduSdXsoKkfKv/JFiIbGY/4=;
        b=QiaI8boK1VZTyFk26xoBGO6l5D3GvnZRE/LLb8vTFKxIRLGOwcwMcAMLQ0ZW2yEm+QeW50
        YL4tE4lbrNicN6aJG3IKzyxgCLhmJdVII6N0ysPasWT+5aFMczO5GEyZVaFsIr0xfGQJBO
        HdjO2nq1kVTFMY585kyyIjBeahoOLj0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 21f81ceb (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jun 2022 08:06:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.18 5.17 5.15 5.10 1/3] random: avoid checking crng_ready() twice in random_init()
Date:   Mon, 13 Jun 2022 10:05:59 +0200
Message-Id: <20220613080601.153153-2-Jason@zx2c4.com>
In-Reply-To: <20220613080601.153153-1-Jason@zx2c4.com>
References: <20220613080601.153153-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 420d78eee6c5..9972259809db 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -834,7 +834,7 @@ int __init random_init(const char *command_line)
 	if (crng_ready())
 		crng_reseed();
 	else if (trust_cpu)
-		credit_init_bits(arch_bytes * 8);
+		_credit_init_bits(arch_bytes * 8);
 
 	return 0;
 }
-- 
2.35.1

