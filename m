Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D509E5583BA
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiFWRdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiFWRdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:33:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AC086AC5;
        Thu, 23 Jun 2022 10:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4318D6159A;
        Thu, 23 Jun 2022 17:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7E4C3411B;
        Thu, 23 Jun 2022 17:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003939;
        bh=okNb7qxX9pzDwpptb3CnaqhHEgUqiLR2hlWi9j3HNaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGW0oEg38pr1pqJ3Ia6rKhbi27VcbXFqnaZZTwTpamH7l4hOy6kTNYWNDgIV2eZyD
         alo9amMb5BR4sDRaesdVljvdsLp7ALvLEMJxlVegEZxAf1uLFeAhRxLZchd1ik4V8J
         kIk51pqkcyqMCnBq8UbNtaRf7ExVPcZAiXeOdnXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 095/237] random: fix locking in crng_fast_load()
Date:   Thu, 23 Jun 2022 18:42:09 +0200
Message-Id: <20220623164345.882784457@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 7c2fe2b32bf76441ff5b7a425b384e5f75aa530a upstream.

crng_init is protected by primary_crng->lock, so keep holding that lock
when incrementing crng_init from 0 to 1 in crng_fast_load(). The call to
pr_notice() can wait until the lock is released; this code path cannot
be reached twice, as crng_fast_load() aborts early if crng_init > 0.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -646,12 +646,13 @@ static size_t crng_fast_load(const u8 *c
 		p[crng_init_cnt % CHACHA20_KEY_SIZE] ^= *cp;
 		cp++; crng_init_cnt++; len--; ret++;
 	}
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
-		pr_notice("fast init done\n");
 	}
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	if (crng_init == 1)
+		pr_notice("fast init done\n");
 	return ret;
 }
 


