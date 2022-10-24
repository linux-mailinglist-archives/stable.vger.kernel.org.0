Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748F660BDCA
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJXWtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiJXWsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:48:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEC52CF4A7;
        Mon, 24 Oct 2022 14:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61AD7CE1318;
        Mon, 24 Oct 2022 11:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54791C433C1;
        Mon, 24 Oct 2022 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611574;
        bh=7d0m2Z6BIjDkYt6daIwwF++izl41uVIUnp2ibyflk6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQOl9iOX1nyMMdTkqlnUOGy+zJo4rwFZrxjLlMSfp2LoYeAZ45xncW5QYJMIocoGV
         fuxc9X6yt0vC4cWJFirkCcwj/aLDv6/8xlck+d2zl5JxydpwRuvTf+A/cOO0vclN4s
         hfkyiQi9DLFe2/SwEufbbfoCBE0AraVp5skKVth8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 031/159] random: clamp credited irq bits to maximum mixed
Date:   Mon, 24 Oct 2022 13:29:45 +0200
Message-Id: <20221024112950.545644221@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit e78a802a7b4febf53f2a92842f494b01062d85a8 upstream.

Since the most that's mixed into the pool is sizeof(long)*2, don't
credit more than that many bytes of entropy.

Fixes: e3e33fc2ea7f ("random: do not use input pool from hard IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -977,7 +977,7 @@ static void mix_interrupt_randomness(str
 	local_irq_enable();
 
 	mix_pool_bytes(pool, sizeof(pool));
-	credit_init_bits(max(1u, (count & U16_MAX) / 64));
+	credit_init_bits(clamp_t(unsigned int, (count & U16_MAX) / 64, 1, sizeof(pool) * 8));
 
 	memzero_explicit(pool, sizeof(pool));
 }


