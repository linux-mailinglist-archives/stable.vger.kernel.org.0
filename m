Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181F55FDF95
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJMR40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiJMR4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:56:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8496A15383D;
        Thu, 13 Oct 2022 10:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18253B82024;
        Thu, 13 Oct 2022 17:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C327C433C1;
        Thu, 13 Oct 2022 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683658;
        bh=Sf4p/I5+I0rasfxMUpNRv3gda7JlSUROFiBRNveWqCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDrYy4FRIRqSLvsPyDbO2nH1ip4qdmr6ON4PUWD8/TG6O6X3FRj0+BFpBs7ZNyfXQ
         AS95eH7kUtTiFM56E34BmanF9224KN/5DbTlLgQ1nuKyM4LYk6kMoyeqj2njrY50OA
         hHSQdCe6GZy/Cak1Dpffnb/eVnqrOeXKxEpNSn0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 22/38] random: clamp credited irq bits to maximum mixed
Date:   Thu, 13 Oct 2022 19:52:23 +0200
Message-Id: <20221013175145.009920659@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
References: <20221013175144.245431424@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -976,7 +976,7 @@ static void mix_interrupt_randomness(str
 	local_irq_enable();
 
 	mix_pool_bytes(pool, sizeof(pool));
-	credit_init_bits(max(1u, (count & U16_MAX) / 64));
+	credit_init_bits(clamp_t(unsigned int, (count & U16_MAX) / 64, 1, sizeof(pool) * 8));
 
 	memzero_explicit(pool, sizeof(pool));
 }


