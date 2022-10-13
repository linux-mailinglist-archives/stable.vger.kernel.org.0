Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BF95FE005
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiJMSCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiJMSC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780C611465;
        Thu, 13 Oct 2022 11:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98879B82050;
        Thu, 13 Oct 2022 17:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A31C433D6;
        Thu, 13 Oct 2022 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683919;
        bh=SzjUWlrxdx6dSBn+CgiQOoaJon3rIv0huAMKubMWhmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS2mzlz/b5Kdya9N8IqyEurfMDytA4edDfDeSbIDYL3REvu4ea7HDWrPj8vFLd6Sn
         TdOXRbLBTAF1LUTA/HjeeiuBSMt2+4of6iUHoPJRV6dIZVdMLa2FfYkkd7p2JzbDMS
         bsC1whr5v7gOQELPhVJfCWdhmlmAMs0XB2H/xyfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 07/27] random: clamp credited irq bits to maximum mixed
Date:   Thu, 13 Oct 2022 19:52:36 +0200
Message-Id: <20221013175143.791866092@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175143.518476113@linuxfoundation.org>
References: <20221013175143.518476113@linuxfoundation.org>
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
@@ -980,7 +980,7 @@ static void mix_interrupt_randomness(str
 	local_irq_enable();
 
 	mix_pool_bytes(pool, sizeof(pool));
-	credit_init_bits(max(1u, (count & U16_MAX) / 64));
+	credit_init_bits(clamp_t(unsigned int, (count & U16_MAX) / 64, 1, sizeof(pool) * 8));
 
 	memzero_explicit(pool, sizeof(pool));
 }


