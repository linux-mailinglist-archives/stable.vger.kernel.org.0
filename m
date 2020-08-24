Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3A924F687
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgHXJBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728959AbgHXI5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:57:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17B252072D;
        Mon, 24 Aug 2020 08:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259423;
        bh=nG/68UkyJbPFo39KSSnnMAkMSDLG37DYiU7yZfHaGPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiSM+Z01rB3nqIepwNUGllhhDcCNhwQ4RW74dz5B1ZMkYjXpysBKBfQQuMm4tIjvg
         qrMlleKoPA6ZpOa3eHKxm6IZjKOPbTFF75lkl5EgmwV/zB5NNfkHTj7hWtnGx+hI55
         yE+WrDb0910pMsV4am/kRL2XnpbuIsUqV6TfhrQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/71] rtc: goldfish: Enable interrupt in set_alarm() when necessary
Date:   Mon, 24 Aug 2020 10:31:15 +0200
Message-Id: <20200824082357.095355850@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

[ Upstream commit 22f8d5a1bf230cf8567a4121fc3789babb46336d ]

When use goldfish rtc, the "hwclock" command fails with "select() to
/dev/rtc to wait for clock tick timed out". This is because "hwclock"
need the set_alarm() hook to enable interrupt when alrm->enabled is
true. This operation is missing in goldfish rtc (but other rtc drivers,
such as cmos rtc, enable interrupt here), so add it.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/1592654683-31314-1-git-send-email-chenhc@lemote.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-goldfish.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-goldfish.c b/drivers/rtc/rtc-goldfish.c
index a1c44d0c85578..30cbe22c57a8e 100644
--- a/drivers/rtc/rtc-goldfish.c
+++ b/drivers/rtc/rtc-goldfish.c
@@ -87,6 +87,7 @@ static int goldfish_rtc_set_alarm(struct device *dev,
 		rtc_alarm64 = rtc_alarm * NSEC_PER_SEC;
 		writel((rtc_alarm64 >> 32), base + TIMER_ALARM_HIGH);
 		writel(rtc_alarm64, base + TIMER_ALARM_LOW);
+		writel(1, base + TIMER_IRQ_ENABLED);
 	} else {
 		/*
 		 * if this function was called with enabled=0
-- 
2.25.1



