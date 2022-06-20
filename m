Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224C2551B41
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243188AbiFTNfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346391AbiFTNc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:32:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E178929D;
        Mon, 20 Jun 2022 06:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3F5360EA0;
        Mon, 20 Jun 2022 13:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E70C341C0;
        Mon, 20 Jun 2022 13:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730769;
        bh=OmzC7V4eFcpWTGj4IkCutE4YTGLbRDKXs5Xy15gQa+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6UREju2FV0KzBJUZh0Snz+oWfq2Cky0svx8RC04uGu9039V0LcxUVJra12OJKZ1i
         AzgRfKmasEfdP2jYs/X/tMTVDVdkDa3icVtYtau6fD64C6Jcfbrhpr8BxEyD/qJ/KY
         dwwzT6uJPihse9AFXvSQtj4VW1Bk1iW1ZejYXsJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 023/240] random: avoid warnings for !CONFIG_NUMA builds
Date:   Mon, 20 Jun 2022 14:48:44 +0200
Message-Id: <20220620124738.483592702@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
@@ -800,7 +800,7 @@ static bool crng_init_try_arch(struct cr
 	return arch_init;
 }
 
-static void crng_initialize_secondary(struct crng_state *crng)
+static void __maybe_unused crng_initialize_secondary(struct crng_state *crng)
 {
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
 	_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);


