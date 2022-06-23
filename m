Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20290558628
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiFWSI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiFWSGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:06:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AE648314;
        Thu, 23 Jun 2022 10:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CDC061E07;
        Thu, 23 Jun 2022 17:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC5EC3411B;
        Thu, 23 Jun 2022 17:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004686;
        bh=LxfPCWUpPkoJx7CMdmDWuUIIaCKudlIu6rNxc9EV36E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z115MAB7IvXXmm/ma2qZSqX0r+JKIVV5T8fj9F//QBb1PYvy9Mu5oeI4olM3++LVW
         ZQQOo+Er1X6ueN+MjJ8WWc1SWC30hYS/gBGZaV604Y1GUqhH2oyedEQ/Fh3GkwEd4o
         F/Fr7Mbi8CBpXj3McblU8lVC1V/al40UhvuhXfgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 116/234] random: give sysctl_random_min_urandom_seed a more sensible value
Date:   Thu, 23 Jun 2022 18:43:03 +0200
Message-Id: <20220623164346.341146891@linuxfoundation.org>
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

commit d0efdf35a6a71d307a250199af6fce122a7c7e11 upstream.

This isn't used by anything or anywhere, but we can't delete it due to
compatibility. So at least give it the correct value of what it's
supposed to be instead of a garbage one.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1612,7 +1612,7 @@ const struct file_operations urandom_fop
  *   to avoid breaking old userspaces, but writing to it does not
  *   change any behavior of the RNG.
  *
- * - urandom_min_reseed_secs - fixed to the meaningless value "60".
+ * - urandom_min_reseed_secs - fixed to the value CRNG_RESEED_INTERVAL.
  *   It is writable to avoid breaking old userspaces, but writing
  *   to it does not change any behavior of the RNG.
  *
@@ -1622,7 +1622,7 @@ const struct file_operations urandom_fop
 
 #include <linux/sysctl.h>
 
-static int sysctl_random_min_urandom_seed = 60;
+static int sysctl_random_min_urandom_seed = CRNG_RESEED_INTERVAL / HZ;
 static int sysctl_random_write_wakeup_bits = POOL_MIN_BITS;
 static int sysctl_poolsize = POOL_BITS;
 static u8 sysctl_bootid[UUID_SIZE];


