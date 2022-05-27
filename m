Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188EC5360C6
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349617AbiE0Lx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352837AbiE0Luz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6858E12FED3;
        Fri, 27 May 2022 04:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2680FB82466;
        Fri, 27 May 2022 11:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8887AC385A9;
        Fri, 27 May 2022 11:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651951;
        bh=hwxcHasEV/bb2nOwjqLI3dCmvo+Iqwr+zYuY74pKObQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPq9S/jJBJUmAp2csFwK0hO00S1Yjn9/4iJJprsCjDSCuanLKN+6iHx60CzeCavsb
         8XcnKvjwwWhnxCzkpDVEXAqomEaDGE3kzOPjWe09cAfBiXt6xexJc46J7troS9FS4q
         9W3L0NW0kCKox/QNi0wXRFG8rEVSjthJvO9C/VJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 068/163] random: do not xor RDRAND when writing into /dev/random
Date:   Fri, 27 May 2022 10:49:08 +0200
Message-Id: <20220527084837.422272677@linuxfoundation.org>
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

commit 91c2afca290ed3034841c8c8532e69ed9e16cf34 upstream.

Continuing the reasoning of "random: ensure early RDSEED goes through
mixer on init", we don't want RDRAND interacting with anything without
going through the mixer function, as a backdoored CPU could presumably
cancel out data during an xor, which it'd have a harder time doing when
being forced through a cryptographic hash function. There's actually no
need at all to be calling RDRAND in write_pool(), because before we
extract from the pool, we always do so with 32 bytes of RDSEED hashed in
at that stage. Xoring at this stage is needless and introduces a minor
liability.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1305,25 +1305,15 @@ static __poll_t random_poll(struct file
 static int write_pool(const char __user *buffer, size_t count)
 {
 	size_t bytes;
-	u32 t, buf[16];
+	u8 buf[BLAKE2S_BLOCK_SIZE];
 	const char __user *p = buffer;
 
 	while (count > 0) {
-		int b, i = 0;
-
 		bytes = min(count, sizeof(buf));
-		if (copy_from_user(&buf, p, bytes))
+		if (copy_from_user(buf, p, bytes))
 			return -EFAULT;
-
-		for (b = bytes; b > 0; b -= sizeof(u32), i++) {
-			if (!arch_get_random_int(&t))
-				break;
-			buf[i] ^= t;
-		}
-
 		count -= bytes;
 		p += bytes;
-
 		mix_pool_bytes(buf, bytes);
 		cond_resched();
 	}


