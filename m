Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8F25FDD46
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 17:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJMPhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 11:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJMPhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 11:37:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B58BC604
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 08:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C513C61840
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 15:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8163C433C1;
        Thu, 13 Oct 2022 15:37:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QYmh/47d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665675426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wonQd4pfyJ5AsZuOKG34hCKgtBB8ldl/1cwHFcERf9E=;
        b=QYmh/47dZwV1FLLZ3N9ogkGHC6rJ83tJpXdVz/aGJPWlZbfTcL8rHqKMaUtKi7Ss3UsGBA
        opii3mxC3xoyNgpUDtoio8zcYSwBlRyTAfafV+BgaXZkKtM+213YXI+iIdBiz2SMjoL1Oh
        VzdjvzxO0zjjOv3A6FxX88EJvylhzDw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6a9f2e74 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 13 Oct 2022 15:37:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 2/3] random: avoid reading two cache lines on irq randomness
Date:   Thu, 13 Oct 2022 09:36:53 -0600
Message-Id: <20221013153654.1397691-3-Jason@zx2c4.com>
In-Reply-To: <20221013153654.1397691-1-Jason@zx2c4.com>
References: <20221013153654.1397691-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 39f811f3dcc9..6dd9544930f8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -890,10 +890,10 @@ void __init add_bootloader_randomness(const void *buf, size_t len)
 }
 
 struct fast_pool {
-	struct work_struct mix;
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
+	struct work_struct mix;
 };
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
-- 
2.37.3

