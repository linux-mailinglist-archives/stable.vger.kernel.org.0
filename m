Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7738A38EA29
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhEXOw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233479AbhEXOuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B61B61401;
        Mon, 24 May 2021 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867672;
        bh=1NEL+GcIiRtjPVEvr2hIegNN3AwAHmDg7Vo8080uR6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoFvvZUVORbd8POTcG5k+BvUkEsYZyMB839Yk9fFE/RmcmlAjOPNUNoimT6vJ/GkD
         99E5zwqgfVadw8qfWLPEVPVfVavlRgYe5if6lcCBV9kvsx5Yb+lSRcw5PoELVyuX3S
         a3GTQj2rLnrgGA9X6UemRqDMYPGetPqf2Z0nMXpYS8tcY1aJkBEUm81xoqwcho+hpy
         ncUJq7PvuIEGeLOCzW9yF6xiKyUJ5JsijrRZAdX1S1NNFsDmebLUsqh+rSDeFRU1as
         nWAjfGbp3VbV8siWMnBw1xsYTK40jNnVWQRRBWjtN80R/Jx4VA/6HXT+mfyYwjM9IE
         9YSJ/WNjAiO+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Jiri Slaby <jirislaby@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/62] Revert "serial: max310x: pass return value of spi_register_driver"
Date:   Mon, 24 May 2021 10:46:47 -0400
Message-Id: <20210524144744.2497894-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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
index 8434bd5a8ec7..f60b7b86d099 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1527,10 +1527,10 @@ static int __init max310x_uart_init(void)
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

