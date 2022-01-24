Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65E8498AC1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345006AbiAXTGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58834 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344567AbiAXTDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:03:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F201260915;
        Mon, 24 Jan 2022 19:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E31C340E5;
        Mon, 24 Jan 2022 19:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050994;
        bh=clj+vxpqqIICktGBM5OJvshuuNp5mLq7b+Nhg7gw3E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jx6USeD+Xqmrhn+A53Yvs4jMnLrWToCLXgNZ7qJglSuLw4pLqoErpmWR2HfDDQlUK
         juTEyuLadiJcnm9xqfJTiLMbqUPBzoXBeCZI6N9DLLvh6yFAAFYUT4GHqEEbI3eyI4
         emutt89OOXHwF6p4Ky6wqyuAMciyvEwKRg/nsHw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.14 020/186] rtc: cmos: take rtc_lock while reading from CMOS
Date:   Mon, 24 Jan 2022 19:41:35 +0100
Message-Id: <20220124183937.770167723@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
@@ -421,7 +421,10 @@ static int cmos_set_alarm(struct device
 	min = t->time.tm_min;
 	sec = t->time.tm_sec;
 
+	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
+	spin_unlock_irq(&rtc_lock);
+
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		/* Writing 0xff means "don't care" or "match all".  */
 		mon = (mon <= 12) ? bin2bcd(mon) : 0xff;


