Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7685585B8
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbiFWSDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235765AbiFWSBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:01:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4FAB3D05;
        Thu, 23 Jun 2022 10:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B572FB824C0;
        Thu, 23 Jun 2022 17:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4E4C3411B;
        Thu, 23 Jun 2022 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004596;
        bh=iOUN+SJWtArXuCdDvQf/Yj0CiUG/LST6tsaQIxZiZN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNPHRMI0fnZi4cc3BN4QVP7JzbX3W39XyuS4BkqTchCOhXOVwH5GZGpqY+QozgGv1
         21MRhIVXPjXJRKcwGj4plWMuMOWSwLZ5U4jFgiAKLO3LKPRU7QG8loZtaUuC/VSDX0
         kOVA9qmVwuTF8/K32bQHx6MIgLPfC6XMvxsav93s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 089/234] random: remove outdated INT_MAX >> 6 check in urandom_read()
Date:   Thu, 23 Jun 2022 18:42:36 +0200
Message-Id: <20220623164345.577438270@linuxfoundation.org>
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

commit 434537ae54ad37e93555de21b6ac8133d6d773a9 upstream.

In 79a8468747c5 ("random: check for increase of entropy_count because of
signed conversion"), a number of checks were added around what values
were passed to account(), because account() was doing fancy fixed point
fractional arithmetic, and a user had some ability to pass large values
directly into it. One of things in that commit was limiting those values
to INT_MAX >> 6. The first >> 3 was for bytes to bits, and the next >> 3
was for bits to 1/8 fractional bits.

However, for several years now, urandom reads no longer touch entropy
accounting, and so this check serves no purpose. The current flow is:

urandom_read_nowarn()-->get_random_bytes_user()-->chacha20_block()

Of course, we don't want that size_t to be truncated when adding it into
the ssize_t. But we arrive at urandom_read_nowarn() in the first place
either via ordinary fops, which limits reads to MAX_RW_COUNT, or via
getrandom() which limits reads to INT_MAX.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1284,9 +1284,8 @@ void rand_initialize_disk(struct gendisk
 static ssize_t urandom_read_nowarn(struct file *file, char __user *buf,
 				   size_t nbytes, loff_t *ppos)
 {
-	int ret;
+	ssize_t ret;
 
-	nbytes = min_t(size_t, nbytes, INT_MAX >> 6);
 	ret = get_random_bytes_user(buf, nbytes);
 	trace_urandom_read(nbytes, input_pool.entropy_count);
 	return ret;


