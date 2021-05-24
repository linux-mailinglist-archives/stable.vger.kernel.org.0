Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA3838EE82
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhEXPvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhEXPsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C70E0613BC;
        Mon, 24 May 2021 15:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870658;
        bh=sTz6XrR3syPDSWyg/TB/3cIFmLu+NQdSjbLs1Aee43c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbDRVfmSoFuoPPM9c9ZCTVObYM5iCWk4dE/kQSoKS6wlJ372pxRcyFou8ra6sdh72
         Jnm64BWWTD5Ua4qzyi+Pv3KDFn4N6yyW62dEuWfsjp8tSqgfzkeQI/wPabeb3EJ7N8
         6PwCDTG7um+cspovf91enerQP76gr9ocIrdkw6As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: [PATCH 5.4 46/71] Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"
Date:   Mon, 24 May 2021 17:25:52 +0200
Message-Id: <20210524152327.963073733@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
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


