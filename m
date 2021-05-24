Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB5138E91F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhEXOsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233165AbhEXOr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:47:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28BA1613BF;
        Mon, 24 May 2021 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867588;
        bh=3sJWlWwJts/OZe86uPzAEUSOBxJPp9sIBwTodNo2VCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFNQ3FrJY1i/3TOg56w8nFnyyA11wgeUSZANSglDd0EuOa7ROmFBprWIAufIMl5FZ
         2Fkpl/0OqSEujiT6Dxq21PdC9NzSrCR7GrrW+c4SdYdJgP1uHLYDaR0fj6yLWSSeDc
         BhcPp8N1M+mLuOdp5mpDOhekEYM+Bj5MnehzdAoH8nde6Ti6NJk2tb7sXta1SR1BMy
         OYY/3d3EGGttK24RP+FhgLaQMVj9/uZpjxKVCx/9oqQbQq9p1Ut4RpQLN5LYFJRlrK
         AfXnycJl7f4DvVrwWhdpJlP5874J74CZtFgaR7VWTtce4QkDsc6gnz8MBf8a3Xog8p
         mjh4qj6+7rODg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Jiri Slaby <jirislaby@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 06/63] Revert "serial: max310x: pass return value of spi_register_driver"
Date:   Mon, 24 May 2021 10:45:23 -0400
Message-Id: <20210524144620.2497249-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit b0a85abbe92e1a6f3e8580a4590fa7245de7090b ]

This reverts commit 51f689cc11333944c7a457f25ec75fcb41e99410.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

This change did not properly unwind from the error condition, so it was
not correct.

Cc: Kangjie Lu <kjlu@umn.edu>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-11-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 1b61d26bb7af..93f69b66b896 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1518,10 +1518,10 @@ static int __init max310x_uart_init(void)
 		return ret;
 
 #ifdef CONFIG_SPI_MASTER
-	ret = spi_register_driver(&max310x_spi_driver);
+	spi_register_driver(&max310x_spi_driver);
 #endif
 
-	return ret;
+	return 0;
 }
 module_init(max310x_uart_init);
 
-- 
2.30.2

