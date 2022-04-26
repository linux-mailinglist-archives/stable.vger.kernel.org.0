Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EDB5107FB
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353508AbiDZTFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352553AbiDZTFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CED19916B;
        Tue, 26 Apr 2022 12:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F081619B9;
        Tue, 26 Apr 2022 19:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2698C385A4;
        Tue, 26 Apr 2022 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999723;
        bh=U7F8eZYEpVTSmb/J39TUf2NGEuMLVkqIGrd2moRZY9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3CXmT3zD6FMP0xdzpTson6eupiio3AGrL7iHp1R1GCMOk6Ntqk5bKoh+JFg5xtCS
         kMsIBXZCLW5qELnXRG3ee428aWk+piwpjvQ4kpJ5jDRsCsZdM7jDCtG1CajeLasMRg
         K4hQRzFiN2BI1X2H4DVvHVlO2KKfTTRo9lMTiKaDBMgmW+0MZfY51a+jcmKL/ixVwy
         fEEKoZ3l7EF1mdOnAjxxlJEqLGIpCWOyeU8r4XO/U1JwGY/OAjRK8MvL65Z19z/imz
         oR7xHn91XDhlFrxsE60Qa9ogbEWJE1Z9T8lBHreWDyIZwoOZn1o1xRLktPj/uOW8XL
         OWJyEmaSoB/Vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>, chris@zankel.net,
        jirislaby@kernel.org, gregkh@linuxfoundation.org, dsterba@suse.com,
        borntraeger@linux.ibm.com, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 5.17 09/22] arch: xtensa: platforms: Fix deadlock in rs_close()
Date:   Tue, 26 Apr 2022 15:01:32 -0400
Message-Id: <20220426190145.2351135-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

