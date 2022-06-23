Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE3B55802F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiFWQqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiFWQp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B0348899;
        Thu, 23 Jun 2022 09:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D219761F90;
        Thu, 23 Jun 2022 16:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA81C3411B;
        Thu, 23 Jun 2022 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002757;
        bh=rIewcPyjRIULRKFTtZUPDNO+kpZQNF51NvXoc5nbINs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtmsMyg/sGGzPtcAG2jNViwJYZOQik8eLy6uFFbafjdVlcgwwEbhVtuT6snFEjJDy
         dY93iTQfoIJwv6O7cNS4/KcfqK7+PxO3HmosT0PYMSav+/1pb5Lx8A56jRxz7WvUE0
         mlQH3p1NPdrYHduNutwGA5HxKD4UeC52Zp+HyfG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Helge Deller <deller@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 016/264] random: fix warning message on ia64 and parisc
Date:   Thu, 23 Jun 2022 18:40:09 +0200
Message-Id: <20220623164344.523992651@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 51d96dc2e2dc2cf9b81cf976cc93c51ba3ac2f92 upstream.

Fix the warning message on the parisc and IA64 architectures to show the
correct function name of the caller by using %pS instead of %pF. The
message is printed with the value of _RET_IP_ which calls
__builtin_return_address(0) and as such returns the IP address caller
instead of pointer to a function descriptor of the caller.

The effect of this patch is visible on the parisc and ia64 architectures
only since those are the ones which use function descriptors while on
all others %pS and %pF will behave the same.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: eecabf567422 ("random: suppress spammy warnings about unseeded randomness")
Fixes: d06bfd1989fe ("random: warn when kernel uses unseeded randomness")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1556,7 +1556,7 @@ static void _warn_unseeded_randomness(co
 #ifndef CONFIG_WARN_ALL_UNSEEDED_RANDOM
 	print_once = true;
 #endif
-	pr_notice("random: %s called from %pF with crng_init=%d\n",
+	pr_notice("random: %s called from %pS with crng_init=%d\n",
 		  func_name, caller, crng_init);
 }
 


