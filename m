Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D355360B4
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352130AbiE0Lws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352764AbiE0Luv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1B218B36;
        Fri, 27 May 2022 04:45:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 751BCB824D6;
        Fri, 27 May 2022 11:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9E0C385A9;
        Fri, 27 May 2022 11:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651913;
        bh=Ve6NfPpdS1r05uyDwxztOFOgYNEeL5kzJRoMP9JvtMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwm9/CYtUV5+WAw9B01qpcmPOqGqwLV0jP4AyRltUyYsO02gPPkXOvaHdhsD7wZLa
         3Tj6EalI0zXJQ2U192srWx+OQuMtr3yBHDz6se1yHx2X+gWRd69pCCb0zraFdkeAqd
         rXq5NJgr7tWcMzGSZEiTyrrc/Ktp3vqusAVLIyg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 073/163] random: remove outdated INT_MAX >> 6 check in urandom_read()
Date:   Fri, 27 May 2022 10:49:13 +0200
Message-Id: <20220527084838.164887740@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1286,9 +1286,8 @@ void rand_initialize_disk(struct gendisk
 static ssize_t urandom_read_nowarn(struct file *file, char __user *buf,
 				   size_t nbytes, loff_t *ppos)
 {
-	int ret;
+	ssize_t ret;
 
-	nbytes = min_t(size_t, nbytes, INT_MAX >> 6);
 	ret = get_random_bytes_user(buf, nbytes);
 	trace_urandom_read(nbytes, input_pool.entropy_count);
 	return ret;


