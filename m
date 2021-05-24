Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B886338F025
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhEXQBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhEXQA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E60E61469;
        Mon, 24 May 2021 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871170;
        bh=sTz6XrR3syPDSWyg/TB/3cIFmLu+NQdSjbLs1Aee43c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3f8WTzg55MEKgGlYickI5B5wXt9k9I9ydlfiwDuGdcp+iYxCBWg276d3uOb21YpC
         HJl6uTeHoGY3rctE/DqCId5WdOgRQQyIy9g2BHSPpjsvNtU89HlbYILSD38dHfjN33
         t6ClzD3d6kM2cqOnCyElgW3UdTWK6/f7nA94Nt3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: [PATCH 5.12 098/127] Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"
Date:   Mon, 24 May 2021 17:26:55 +0200
Message-Id: <20210524152338.172754887@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8d1beda5f11953ffe135a5213287f0b25b4da41b upstream.

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
Link: https://lore.kernel.org/r/20210503115736.2104747-9-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp5523.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -305,9 +305,7 @@ static int lp5523_init_program_engine(st
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
-	if (ret)
-		return ret;
+	lp55xx_read(chip, LP5523_REG_STATUS, &status);
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status != LP5523_ENG_STATUS_MASK) {


