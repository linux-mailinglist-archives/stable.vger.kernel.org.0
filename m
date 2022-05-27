Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20CD53613D
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349851AbiE0L5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353189AbiE0L4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC44C15EA5E;
        Fri, 27 May 2022 04:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB2FB8091D;
        Fri, 27 May 2022 11:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C02C385A9;
        Fri, 27 May 2022 11:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652199;
        bh=7HTA8dBismSNtEddUBqn+LQFyLT1UhrR03jQn5QntLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4hrG7Ocf6iYHNV7lwWKPRdwTa5Tq24Gxn7SGl1f4CJ6TQmdhpj5yyMLe+JFYT1qg
         1gvr8GOgZ0HqvvbxPnmRHuf/tUKK2VAINoNbGmUbw/Tsgcf3G05PYT06Ci0DrTmkrX
         81ZDrgpT8xSQajeksOD2Vtc7pW938FlcQAvZMX1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 102/163] random: give sysctl_random_min_urandom_seed a more sensible value
Date:   Fri, 27 May 2022 10:49:42 +0200
Message-Id: <20220527084842.168493553@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
@@ -1619,7 +1619,7 @@ const struct file_operations urandom_fop
  *   to avoid breaking old userspaces, but writing to it does not
  *   change any behavior of the RNG.
  *
- * - urandom_min_reseed_secs - fixed to the meaningless value "60".
+ * - urandom_min_reseed_secs - fixed to the value CRNG_RESEED_INTERVAL.
  *   It is writable to avoid breaking old userspaces, but writing
  *   to it does not change any behavior of the RNG.
  *
@@ -1629,7 +1629,7 @@ const struct file_operations urandom_fop
 
 #include <linux/sysctl.h>
 
-static int sysctl_random_min_urandom_seed = 60;
+static int sysctl_random_min_urandom_seed = CRNG_RESEED_INTERVAL / HZ;
 static int sysctl_random_write_wakeup_bits = POOL_MIN_BITS;
 static int sysctl_poolsize = POOL_BITS;
 static u8 sysctl_bootid[UUID_SIZE];


