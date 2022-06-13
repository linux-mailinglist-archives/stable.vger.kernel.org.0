Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922EE547FAD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 08:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbiFMGoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 02:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiFMGoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 02:44:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC39101F9
        for <stable@vger.kernel.org>; Sun, 12 Jun 2022 23:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72356B80D5D
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 06:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E270CC3411E;
        Mon, 13 Jun 2022 06:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655102672;
        bh=JXIESsH+BGhpi9/GbQihyGt3GxtRsZdBcou4eELIiFc=;
        h=Subject:To:Cc:From:Date:From;
        b=zOIhPW3oN50A8K65Z5zXYP2HViMBBGwJmeokrssdXyaUIRxKMYxaDDxD+qT9vjXUW
         fPMKkK7ngewbhK5KnO7mQmkggit6zdWkxu160UvETti3VEeAXbn+OhmZ+WdLpfeEnB
         AC55BrYdqb1sLIL7Pi5XwbHerfxaKpTqxeOLidc4=
Subject: FAILED: patch "[PATCH] random: avoid checking crng_ready() twice in random_init()" failed to apply to 5.15-stable tree
To:     Jason@zx2c4.com, linux@dominikbrodowski.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 08:44:27 +0200
Message-ID: <1655102667167158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9b29b6b20376ab64e1b043df6301d8a92378e631 Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 7 Jun 2022 09:44:07 +0200
Subject: [PATCH] random: avoid checking crng_ready() twice in random_init()

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

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b691b9d59503..4862d4d3ec49 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -801,7 +801,7 @@ int __init random_init(const char *command_line)
 	if (crng_ready())
 		crng_reseed();
 	else if (trust_cpu)
-		credit_init_bits(arch_bytes * 8);
+		_credit_init_bits(arch_bytes * 8);
 	used_arch_random = arch_bytes * 8 >= POOL_READY_BITS;
 
 	WARN_ON(register_pm_notifier(&pm_notifier));

