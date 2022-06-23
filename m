Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4E558548
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiFWRzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbiFWRyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:54:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406A9AD1A2;
        Thu, 23 Jun 2022 10:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE50DB82498;
        Thu, 23 Jun 2022 17:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DEBC3411B;
        Thu, 23 Jun 2022 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004504;
        bh=VpQApCs5/lvsmf8+1uF4l3TjOpcku2gXN53TYSaWCMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uHMyv2Fih1mBKxUEJPFB+Exihu/MfTmNEJglp90wv734qfd5CooxRmw1tVSpuf2a
         nD6ZuVJJRVgGGRJVTzKlSvGHaZ9qcLu9BfSnqhPqk5lrn8qpqdkArFYu5Yy3TefS8k
         Z9zn8OKKIH0TouaKNwcuHDBDv+k3ktiwcdE3HPBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 059/234] random: dont reset crng_init_cnt on urandom_read()
Date:   Thu, 23 Jun 2022 18:42:06 +0200
Message-Id: <20220623164344.734731857@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 6c8e11e08a5b74bb8a5cdd5cbc1e5143df0fba72 upstream.

At the moment, urandom_read() (used for /dev/urandom) resets crng_init_cnt
to zero when it is called at crng_init<2. This is inconsistent: We do it
for /dev/urandom reads, but not for the equivalent
getrandom(GRND_INSECURE).

(And worse, as Jason pointed out, we're only doing this as long as
maxwarn>0.)

crng_init_cnt is only read in crng_fast_load(); it is relevant at
crng_init==0 for determining when to switch to crng_init==1 (and where in
the RNG state array to write).

As far as I understand:

 - crng_init==0 means "we have nothing, we might just be returning the same
   exact numbers on every boot on every machine, we don't even have
   non-cryptographic randomness; we should shove every bit of entropy we
   can get into the RNG immediately"
 - crng_init==1 means "well we have something, it might not be
   cryptographic, but at least we're not gonna return the same data every
   time or whatever, it's probably good enough for TCP and ASLR and stuff;
   we now have time to build up actual cryptographic entropy in the input
   pool"
 - crng_init==2 means "this is supposed to be cryptographically secure now,
   but we'll keep adding more entropy just to be sure".

The current code means that if someone is pulling data from /dev/urandom
fast enough at crng_init==0, we'll keep resetting crng_init_cnt, and we'll
never make forward progress to crng_init==1. It seems to be intended to
prevent an attacker from bruteforcing the contents of small individual RNG
inputs on the way from crng_init==0 to crng_init==1, but that's misguided;
crng_init==1 isn't supposed to provide proper cryptographic security
anyway, RNG users who care about getting secure RNG output have to wait
until crng_init==2.

This code was inconsistent, and it probably made things worse - just get
rid of it.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1831,7 +1831,6 @@ urandom_read_nowarn(struct file *file, c
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	unsigned long flags;
 	static int maxwarn = 10;
 
 	if (!crng_ready() && maxwarn > 0) {
@@ -1839,9 +1838,6 @@ urandom_read(struct file *file, char __u
 		if (__ratelimit(&urandom_warning))
 			pr_notice("%s: uninitialized urandom read (%zd bytes read)\n",
 				  current->comm, nbytes);
-		spin_lock_irqsave(&primary_crng.lock, flags);
-		crng_init_cnt = 0;
-		spin_unlock_irqrestore(&primary_crng.lock, flags);
 	}
 
 	return urandom_read_nowarn(file, buf, nbytes, ppos);


