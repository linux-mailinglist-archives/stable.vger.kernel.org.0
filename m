Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76B8558115
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiFWQzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbiFWQt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:49:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0FE13F3D;
        Thu, 23 Jun 2022 09:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DDCBCCE25D9;
        Thu, 23 Jun 2022 16:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC414C385A5;
        Thu, 23 Jun 2022 16:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002876;
        bh=DVqS7H5Sm67SdV6zpWpQ1W1Mj+FjSJsjD7F6bT+BDPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODTbryXKvY8poKwLBT11rdWYCt/KEndZgVPeLneG155xBxViqPpEK8tzcnEFhcYd6
         5RmlRS0hhK2kwjwsxZYCUb8ImwslRU8QOjFVpPrCnWvSx6Z7sK+3C83B1ZFw/TolN1
         cjn7InwsX513toinLyvHV3d5jt84gyvPOUitJKgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 056/264] random: ignore GRND_RANDOM in getentropy(2)
Date:   Thu, 23 Jun 2022 18:40:49 +0200
Message-Id: <20220623164345.658306748@linuxfoundation.org>
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

From: Andy Lutomirski <luto@kernel.org>

commit 48446f198f9adcb499b30332488dfd5bc3f176f6 upstream.

The separate blocking pool is going away.  Start by ignoring
GRND_RANDOM in getentropy(2).

This should not materially break any API.  Any code that worked
without this change should work at least as well with this change.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/705c5a091b63cc5da70c99304bb97e0109be0a26.1577088521.git.luto@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c       |    3 ---
 include/uapi/linux/random.h |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2200,9 +2200,6 @@ SYSCALL_DEFINE3(getrandom, char __user *
 	if (count > INT_MAX)
 		count = INT_MAX;
 
-	if (flags & GRND_RANDOM)
-		return _random_read(flags & GRND_NONBLOCK, buf, count);
-
 	if (!(flags & GRND_INSECURE) && !crng_ready()) {
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -47,7 +47,7 @@ struct rand_pool_info {
  * Flags for getrandom(2)
  *
  * GRND_NONBLOCK	Don't block and return EAGAIN instead
- * GRND_RANDOM		Use the /dev/random pool instead of /dev/urandom
+ * GRND_RANDOM		No effect
  * GRND_INSECURE	Return non-cryptographic random bytes
  */
 #define GRND_NONBLOCK	0x0001


