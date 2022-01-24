Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D367499078
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbiAXUAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350954AbiAXTwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:52:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3623C0617A3;
        Mon, 24 Jan 2022 11:24:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B79BB8122F;
        Mon, 24 Jan 2022 19:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866E0C340E8;
        Mon, 24 Jan 2022 19:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052297;
        bh=Q3d16Erybi8ks3P6I31MKaCH6TV11ACxsCvMgjcQY2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7cvptfEzOOb46dFmQV+FG/b9ajbnRYhFI1is89ZOsqw9MI6kdU5c2UiY/mYBLYbL
         nLfc0tUnRwrJapa8AtWr2ivFzCUQhOmGKAvTCk5dkM1M3ZEVSYf/X0Lf0I+nLPyu3G
         1cmuhHlSecjm7r+D5MHShPL6VNIB8Rupj4hM/XCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 013/320] rtc: cmos: take rtc_lock while reading from CMOS
Date:   Mon, 24 Jan 2022 19:39:57 +0100
Message-Id: <20220124183954.205099585@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

commit 454f47ff464325223129b9b5b8d0b61946ec704d upstream.

Reading from the CMOS involves writing to the index register and then
reading from the data register. Therefore access to the CMOS has to be
serialized with rtc_lock. This invocation of CMOS_READ was not
serialized, which could cause trouble when other code is accessing CMOS
at the same time.

Use spin_lock_irq() like the rest of the function.

Nothing in kernel modifies the RTC_DM_BINARY bit, so there could be a
separate pair of spin_lock_irq() / spin_unlock_irq() before doing the
math.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211210200131.153887-2-mat.jonczyk@o2.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -463,7 +463,10 @@ static int cmos_set_alarm(struct device
 	min = t->time.tm_min;
 	sec = t->time.tm_sec;
 
+	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
+	spin_unlock_irq(&rtc_lock);
+
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		/* Writing 0xff means "don't care" or "match all".  */
 		mon = (mon <= 12) ? bin2bcd(mon) : 0xff;


