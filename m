Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5C060A3A7
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiJXL6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiJXL5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:57:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA3527CC0;
        Mon, 24 Oct 2022 04:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66E76B8113E;
        Mon, 24 Oct 2022 11:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFE0C433C1;
        Mon, 24 Oct 2022 11:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612033;
        bh=HvNQLbDFpQyKb6hj8OG6baMZ1QDProYxanDCjhbgJvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEepv6HdZeQNBz/rBs/aquBX05uRDqiFz/7Xuu2klhYj5/lCUyTtUlwZI01qqbnKQ
         IQRRVUVfYTu1W6ghmZIOVtAXm0QFNNRNpYqKnwBYdbT610uVzd1xpZNaEyW/Ht3vyH
         doMSIk39oT0yUjz4DgGIc9zfonSY0VipndQ+kySM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 045/210] random: avoid reading two cache lines on irq randomness
Date:   Mon, 24 Oct 2022 13:29:22 +0200
Message-Id: <20221024112958.456405677@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
@@ -890,10 +890,10 @@ void __init add_bootloader_randomness(co
 }
 
 struct fast_pool {
-	struct work_struct mix;
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
+	struct work_struct mix;
 };
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {


