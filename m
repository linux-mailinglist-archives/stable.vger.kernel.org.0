Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1314F5585E5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbiFWSF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiFWSF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:05:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2530DB8F97;
        Thu, 23 Jun 2022 10:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A2D61DC6;
        Thu, 23 Jun 2022 17:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC55C3411B;
        Thu, 23 Jun 2022 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004650;
        bh=/S1iYXeszMNaRYv4XNqtEEGXovrfJyB6SAipvJMmfqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ty034qwvGH22HkWmz0fg9ouYbCOsKAS5031mUXheyL8uEJ4Tbos79+zlJdgS9PsVH
         bvRSq3bhMqoJpfYH5p5WfJOf8L7nvBiarPsKpKVPZFzCpYt59+9H2WH7wrdjBsygVM
         VvpD91YeChEfpQsmSYyBD8OGzjlXA2eAWL/wEdpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 106/234] random: do not take pool spinlock at boot
Date:   Thu, 23 Jun 2022 18:42:53 +0200
Message-Id: <20220623164346.057560831@linuxfoundation.org>
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

commit afba0b80b977b2a8f16234f2acd982f82710ba33 upstream.

Since rand_initialize() is run while interrupts are still off and
nothing else is running, we don't need to repeatedly take and release
the pool spinlock, especially in the RDSEED loop.

Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -973,10 +973,10 @@ int __init rand_initialize(void)
 			rv = random_get_entropy();
 			arch_init = false;
 		}
-		mix_pool_bytes(&rv, sizeof(rv));
+		_mix_pool_bytes(&rv, sizeof(rv));
 	}
-	mix_pool_bytes(&now, sizeof(now));
-	mix_pool_bytes(utsname(), sizeof(*(utsname())));
+	_mix_pool_bytes(&now, sizeof(now));
+	_mix_pool_bytes(utsname(), sizeof(*(utsname())));
 
 	extract_entropy(base_crng.key, sizeof(base_crng.key));
 	++base_crng.generation;


