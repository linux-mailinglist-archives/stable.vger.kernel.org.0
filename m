Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B687551DC2
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344105AbiFTOBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350610AbiFTNxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F001A3B0;
        Mon, 20 Jun 2022 06:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBAEC60C8B;
        Mon, 20 Jun 2022 13:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECFEC3411B;
        Mon, 20 Jun 2022 13:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730639;
        bh=uWs2zUwT/SVjM5aswnIC6LTcAQBCGhcDUTFAe2cHKu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lfG7Gss2cBf55fKGmPxS6rcKud2kh+73BW5dgVGq01JY7ZXtQPoBt0lBWkk6nah/
         B77tB0TuR8kbB3kqQplfCzqaDjmA6ba4FiZKXLLuoFUkd8t2fDoiN4CgmcnGE3mUVJ
         9QpXmcHE4IBYuqjfs6NEkGHo7NYRIuT2M5az0QRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 010/240] random: Add a urandom_read_nowait() for random APIs that dont warn
Date:   Mon, 20 Jun 2022 14:48:31 +0200
Message-Id: <20220620124738.106403104@linuxfoundation.org>
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

From: Andy Lutomirski <luto@kernel.org>

commit c6f1deb158789abba02a7eba600747843eeb3a57 upstream.

/dev/random and getrandom() never warn.  Split the meat of
urandom_read() into urandom_read_nowarn() and leave the warning code
in urandom_read().

This has no effect on kernel behavior, but it makes subsequent
patches more straightforward.  It also makes the fact that
getrandom() never warns more obvious.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/c87ab200588de746431d9f916501ef11e5242b13.1577088521.git.luto@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2043,11 +2043,22 @@ random_read(struct file *file, char __us
 }
 
 static ssize_t
+urandom_read_nowarn(struct file *file, char __user *buf, size_t nbytes,
+		    loff_t *ppos)
+{
+	int ret;
+
+	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
+	ret = extract_crng_user(buf, nbytes);
+	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS(&input_pool));
+	return ret;
+}
+
+static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	unsigned long flags;
 	static int maxwarn = 10;
-	int ret;
 
 	if (!crng_ready() && maxwarn > 0) {
 		maxwarn--;
@@ -2059,10 +2070,8 @@ urandom_read(struct file *file, char __u
 		crng_init_cnt = 0;
 		spin_unlock_irqrestore(&primary_crng.lock, flags);
 	}
-	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
-	ret = extract_crng_user(buf, nbytes);
-	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS(&input_pool));
-	return ret;
+
+	return urandom_read_nowarn(file, buf, nbytes, ppos);
 }
 
 static __poll_t
@@ -2224,7 +2233,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 		if (unlikely(ret))
 			return ret;
 	}
-	return urandom_read(NULL, buf, count, NULL);
+	return urandom_read_nowarn(NULL, buf, count, NULL);
 }
 
 /********************************************************************


