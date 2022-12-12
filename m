Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C34649FD6
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiLLNQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiLLNPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:15:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E6313D56
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:15:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87CBD60FF4
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336D6C433D2;
        Mon, 12 Dec 2022 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850912;
        bh=fhs5fA57J/p4a3PHpy7bxrxXOmg/jUtb2bVxw7E3S1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LK+FjtXMk0gkp+jbqKTD6I0NzL2KTvurmWNcVWJ5kX0D5VKeZHsHfD41EfJ1bjeTz
         w5J2girHUtuZTKhyeefs85wFIK5/4+QjjIK1ND0UWqsm1hwpGp2WBymvQOK0glnHIy
         Siy29aEPiErDwzotZC8YaSuJd7SWVNEjXg5DecUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/106] rtc: mc146818-lib: fix locking in mc146818_set_time
Date:   Mon, 12 Dec 2022 14:10:05 +0100
Message-Id: <20221212130927.589482356@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

[ Upstream commit 811f5559270f25c34c338d6eaa2ece2544c3d3bd ]

In mc146818_set_time(), CMOS_READ(RTC_CONTROL) was performed without the
rtc_lock taken, which is required for CMOS accesses. Fix this.

Nothing in kernel modifies RTC_DM_BINARY, so a separate critical section
is allowed here.

Fixes: dcf257e92622 ("rtc: mc146818: Reduce spinlock section in mc146818_set_time()")
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220220090403.153928-1-mat.jonczyk@o2.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 1ca866461d10..3783aaf9dd5a 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -283,8 +283,10 @@ int mc146818_set_time(struct rtc_time *time)
 	if (yrs >= 100)
 		yrs -= 100;
 
-	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)
-	    || RTC_ALWAYS_BCD) {
+	spin_lock_irqsave(&rtc_lock, flags);
+	save_control = CMOS_READ(RTC_CONTROL);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		sec = bin2bcd(sec);
 		min = bin2bcd(min);
 		hrs = bin2bcd(hrs);
-- 
2.35.1



