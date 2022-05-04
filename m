Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7247051A9E2
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357779AbiEDRUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356681AbiEDROD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B53C53B4E;
        Wed,  4 May 2022 09:58:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9D12617B7;
        Wed,  4 May 2022 16:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FDBC385AA;
        Wed,  4 May 2022 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683490;
        bh=U7F8eZYEpVTSmb/J39TUf2NGEuMLVkqIGrd2moRZY9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNVs4hv8sjWzhzseeNnkTXBC1eoSjP6UsFpCG8jxB358ymIQuu4hHqAa0uI7CoHWU
         l5Ir8NGqTEo6mquYI5nb4Vyz6LAA5JDDCu/GU+RmqI8DY9EnJ/vs+jh4HUrdB93pfR
         vsZkYVGqyE1rS0cyZN2CNTAS2+ZkBM4xgUwUIUMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 165/225] arch: xtensa: platforms: Fix deadlock in rs_close()
Date:   Wed,  4 May 2022 18:46:43 +0200
Message-Id: <20220504153124.692859690@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit eb5adc70754d26a260f8b42d39db42da0d0af500 ]

There is a deadlock in rs_close(), which is shown
below:

   (Thread 1)              |      (Thread 2)
                           | rs_open()
rs_close()                 |  mod_timer()
 spin_lock_bh() //(1)      |  (wait a time)
 ...                       | rs_poll()
 del_timer_sync()          |  spin_lock() //(2)
 (wait timer to stop)      |  ...

We hold timer_lock in position (1) of thread 1 and
use del_timer_sync() to wait timer to stop, but timer handler
also need timer_lock in position (2) of thread 2.
As a result, rs_close() will block forever.

This patch deletes the redundant timer_lock in order to
prevent the deadlock. Because there is no race condition
between rs_close, rs_open and rs_poll.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Message-Id: <20220407154430.22387-1-duoming@zju.edu.cn>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/platforms/iss/console.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 81d7c7e8f7e9..10b79d3c74e0 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -36,24 +36,19 @@ static void rs_poll(struct timer_list *);
 static struct tty_driver *serial_driver;
 static struct tty_port serial_port;
 static DEFINE_TIMER(serial_timer, rs_poll);
-static DEFINE_SPINLOCK(timer_lock);
 
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
-	spin_lock_bh(&timer_lock);
 	if (tty->count == 1)
 		mod_timer(&serial_timer, jiffies + SERIAL_TIMER_VALUE);
-	spin_unlock_bh(&timer_lock);
 
 	return 0;
 }
 
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
-	spin_lock_bh(&timer_lock);
 	if (tty->count == 1)
 		del_timer_sync(&serial_timer);
-	spin_unlock_bh(&timer_lock);
 }
 
 
@@ -73,8 +68,6 @@ static void rs_poll(struct timer_list *unused)
 	int rd = 1;
 	unsigned char c;
 
-	spin_lock(&timer_lock);
-
 	while (simc_poll(0)) {
 		rd = simc_read(0, &c, 1);
 		if (rd <= 0)
@@ -87,7 +80,6 @@ static void rs_poll(struct timer_list *unused)
 		tty_flip_buffer_push(port);
 	if (rd)
 		mod_timer(&serial_timer, jiffies + SERIAL_TIMER_VALUE);
-	spin_unlock(&timer_lock);
 }
 
 
-- 
2.35.1



