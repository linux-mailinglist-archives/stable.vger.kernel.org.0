Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1067853615F
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352185AbiE0L7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352581AbiE0Lz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:55:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D715AB2D;
        Fri, 27 May 2022 04:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3ABA61D56;
        Fri, 27 May 2022 11:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD4CC385A9;
        Fri, 27 May 2022 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652124;
        bh=0MYS7OwGSsxOj9r4dJeXvJnS30+TdN5SqX5eby8CsFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZVpVGZdvcaVPfZyWMPf3Db5IDPCU4PQTyqvSt4A/6NBrdCUuym7/54J/9fgmnCYt
         k1J7SBVI3DOC+uqhXDV7Bekot4HLJGvUgDprHOFGGS0llEvEczow0bGd7n3FSKgeFO
         MlGwO8TGqNvmSF28lfPw2yUuOjjpWm3pzookXjlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 076/145] random: check for crng_init == 0 in add_device_randomness()
Date:   Fri, 27 May 2022 10:49:37 +0200
Message-Id: <20220527084859.878541829@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
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

commit 1daf2f387652bf3a7044aea042f5023b3f6b189b upstream.

This has no real functional change, as crng_pre_init_inject() (and
before that, crng_slow_init()) always checks for == 0, not >= 2. So
correct the outer unlocked change to reflect that. Before this used
crng_ready(), which was not correct.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1020,7 +1020,7 @@ void add_device_randomness(const void *b
 	unsigned long time = random_get_entropy() ^ jiffies;
 	unsigned long flags;
 
-	if (!crng_ready() && size)
+	if (crng_init == 0 && size)
 		crng_pre_init_inject(buf, size, false, false);
 
 	spin_lock_irqsave(&input_pool.lock, flags);


