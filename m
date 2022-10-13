Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74535FDFC3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiJMR6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiJMR51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:57:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380E8659EF;
        Thu, 13 Oct 2022 10:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18BB6B81CF4;
        Thu, 13 Oct 2022 17:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF15C433D6;
        Thu, 13 Oct 2022 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683763;
        bh=NP1XPEhn7jtkvGePO/ii4tg8z2O0BgSRceDNFGGZJbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXwH/mBoenPXO1zXVoUy4hPIxLn1+pEHD7viMJz/6opnDQaXqqYxHt2ZS/xOc4+5p
         shgUamLT44+1qZV/Pz9J/McBavNugFAb6SllJMQDX3PMXeqVwP0Oqh4tiJKjHLio72
         I1+mTSNOdpnfKprSIRfG3qXxBY5iyqhNIos7CIl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 41/54] random: avoid reading two cache lines on irq randomness
Date:   Thu, 13 Oct 2022 19:52:35 +0200
Message-Id: <20221013175148.335434415@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
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
@@ -895,10 +895,10 @@ void __cold add_bootloader_randomness(co
 EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
 struct fast_pool {
-	struct work_struct mix;
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
+	struct work_struct mix;
 };
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {


