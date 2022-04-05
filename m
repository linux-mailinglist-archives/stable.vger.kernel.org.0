Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7CF4F2D9A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242766AbiDEKfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbiDEJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AE078911;
        Tue,  5 Apr 2022 02:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 243FE6144D;
        Tue,  5 Apr 2022 09:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B37FC385A0;
        Tue,  5 Apr 2022 09:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150574;
        bh=9oeaOtDRB/SGVsQXC0FYtjORDubOt8V3HM+oZFsGGz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umdtQ3u1Hh86WM491LLpt/m9v+/dlHTsMOY7l0D3P3jdS1FIuRAGLocZGNw8Hr6HY
         jG/CZHWsCfdeRAujP8JzZC08E3ClTAMJ8gkJvKQZU2pZQIQFRoGSv8xhfXkRQTPn5v
         OBHE48Z71vaUQa0TS/DKc1rLMiz6chlDUqhJnQ00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 103/913] rtc: mc146818-lib: fix locking in mc146818_set_time
Date:   Tue,  5 Apr 2022 09:19:25 +0200
Message-Id: <20220405070342.914276063@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

commit 811f5559270f25c34c338d6eaa2ece2544c3d3bd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-mc146818-lib.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -176,8 +176,10 @@ int mc146818_set_time(struct rtc_time *t
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


