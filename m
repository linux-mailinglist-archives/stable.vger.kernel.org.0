Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB925580F2
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiFWQyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbiFWQur (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:50:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726174AE1F;
        Thu, 23 Jun 2022 09:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E66D61FA3;
        Thu, 23 Jun 2022 16:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628F3C3411B;
        Thu, 23 Jun 2022 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002918;
        bh=veDQwILYuYD77O/PWU+fYo0AeKKkbMgMDyW8CYhs+zQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOlUGwiXDFjcg6eRkCxRhD/q/hDUyxLARr4NcIfSLGwkdIFMFYGq8nkysXQh4hA0f
         eMt/VN6mh+Zp7CipTFXIGoiGBlms4pJmIka1ibqz+mjZ0utFnQ5peIKgia7u3/8mBR
         UvW05sdvL48n9kxlbNBXkfNyIWijFIjeURvlxO+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 068/264] random: avoid warnings for !CONFIG_NUMA builds
Date:   Thu, 23 Jun 2022 18:41:01 +0200
Message-Id: <20220623164345.995818273@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit ab9a7e27044b87ff2be47b8f8e095400e7fccc44 upstream.

As crng_initialize_secondary() is only called by do_numa_crng_init(),
and the latter is under ifdeffery for CONFIG_NUMA, when CONFIG_NUMA is
not selected the compiler will warn that the former is unused:

| drivers/char/random.c:820:13: warning: 'crng_initialize_secondary' defined but not used [-Wunused-function]
|   820 | static void crng_initialize_secondary(struct crng_state *crng)
|       |             ^~~~~~~~~~~~~~~~~~~~~~~~~

Stephen reports that this happens for x86_64 noallconfig builds.

We could move crng_initialize_secondary() and crng_init_try_arch() under
the CONFIG_NUMA ifdeffery, but this has the unfortunate property of
separating them from crng_initialize_primary() and
crng_init_try_arch_early() respectively. Instead, let's mark
crng_initialize_secondary() as __maybe_unused.

Link: https://lore.kernel.org/r/20200310121747.GA49602@lakrids.cambridge.arm.com
Fixes: 5cbe0f13b51a ("random: split primary/secondary crng init paths")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -801,7 +801,7 @@ static bool crng_init_try_arch(struct cr
 	return arch_init;
 }
 
-static void crng_initialize_secondary(struct crng_state *crng)
+static void __maybe_unused crng_initialize_secondary(struct crng_state *crng)
 {
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
 	_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);


