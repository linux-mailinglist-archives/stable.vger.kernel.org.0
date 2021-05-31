Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5850C396074
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhEaO1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233614AbhEaOZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:25:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE39B61A19;
        Mon, 31 May 2021 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468780;
        bh=1NEL+GcIiRtjPVEvr2hIegNN3AwAHmDg7Vo8080uR6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvkD1gbE9vQgOPn6bG8/gJS86QK67ybzyQBHpFZXE0N0NGa/mOmQ+kQy/t0cfFNUO
         wNJ4ZZ/180sG+ADCcq+EURHxCtveBiRaTo0UnrtSzdu9Na77+HcDhieBzUGiVudYb2
         NVfERGucd7C0LyBvt5OyejRFTelORWXfm9CuwBQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Jiri Slaby <jirislaby@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/177] Revert "serial: max310x: pass return value of spi_register_driver"
Date:   Mon, 31 May 2021 15:14:07 +0200
Message-Id: <20210531130651.007865053@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



