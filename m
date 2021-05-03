Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188353714D0
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhECMB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233834AbhECMAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25CC161364;
        Mon,  3 May 2021 11:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043200;
        bh=gnPSlI+roFFTk5iidLNsQQtkOcb7p+BeTDNjL0KPcik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKnaZBr7AzjPu+OfPCHBkQNTg5NnZ0IXNEHazXDg9Ycffo9Q0soujCU6OrArPBHpX
         /VS0RA3QBaCEGs4zFn4K/ua1NHW3MawgmjGbdhg+vbjIM5g7hD7FhdlaIX3noWYA3o
         pyZj86s1CCRoKHlk0Z1P/tgySELSdJC+zCWsM4u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 08/69] Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"
Date:   Mon,  3 May 2021 13:56:35 +0200
Message-Id: <20210503115736.2104747-9-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 248b57015f35c94d4eae2fdd8c6febf5cd703900.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit does not properly unwind if there is an error
condition so it needs to be reverted at this point in time.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 248b57015f35 ("leds: lp5523: fix a missing check of return value of lp55xx_read")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp5523.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index fc433e63b1dc..5036d7d5f3d4 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -305,9 +305,7 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
-	if (ret)
-		return ret;
+	lp55xx_read(chip, LP5523_REG_STATUS, &status);
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status != LP5523_ENG_STATUS_MASK) {
-- 
2.31.1

