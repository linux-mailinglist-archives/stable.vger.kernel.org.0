Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3CF5FE01F
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiJMSEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiJMSDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D303A157F5F;
        Thu, 13 Oct 2022 11:03:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4375461952;
        Thu, 13 Oct 2022 18:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4941FC43143;
        Thu, 13 Oct 2022 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684023;
        bh=wWxXNLldQJWjVR9cUWjf0UKYSuekCHsercakn8tOViM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eiYyJPoKshujY3RDf7cXo4GmJfJ//cnAvgJzt8StnPv3FyQ16sJIwwnHDtztK9eZ
         3rgECIoaD6vidM7Azg0j9umeiMz5UJANTzlFg+qmlapPzprI0+kgkEBpSuMaL6/VqT
         tKOzBsleYnlXi61Qq/GEYkaYlXyXWTa7IUdvkQ2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.19 18/33] random: avoid reading two cache lines on irq randomness
Date:   Thu, 13 Oct 2022 19:52:50 +0200
Message-Id: <20221013175145.887818528@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
References: <20221013175145.236739253@linuxfoundation.org>
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

commit 9ee0507e896b45af6d65408c77815800bce30008 upstream.

In order to avoid reading and dirtying two cache lines on every IRQ,
move the work_struct to the bottom of the fast_pool struct. add_
interrupt_randomness() always touches .pool and .count, which are
currently split, because .mix pushes everything down. Instead, move .mix
to the bottom, so that .pool and .count are always in the first cache
line, since .mix is only accessed when the pool is full.

Fixes: 58340f8e952b ("random: defer fast pool mixing to worker")
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -903,10 +903,10 @@ EXPORT_SYMBOL_GPL(unregister_random_vmfo
 #endif
 
 struct fast_pool {
-	struct work_struct mix;
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
+	struct work_struct mix;
 };
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {


