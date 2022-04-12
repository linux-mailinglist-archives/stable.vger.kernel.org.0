Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8840B4FD231
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351307AbiDLHKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiDLHHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B43349CB5;
        Mon, 11 Apr 2022 23:49:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06310610FB;
        Tue, 12 Apr 2022 06:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FA1C385A1;
        Tue, 12 Apr 2022 06:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746165;
        bh=owrRxY8cSiGya61jUO0X4zrPASoREzU4RoHqg/WmKWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YVp9kOMsEY3yHsCMTHX2T4bEsCP+QE2l2fLctUwQAr8Vo6D2Hhm8i07sHIzMKgwC
         XogkGrB6JtBt98s5rfj6kK5dyVV1/H5WAXhW95FdcGdEZXg+tekJoYVGKQA+HWcc6s
         MDczK+0z2Zv4+D8nMqoFqhyIEAsFQCW2e3S1S8Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/277] rtc: mc146818-lib: change return values of mc146818_get_time()
Date:   Tue, 12 Apr 2022 08:29:07 +0200
Message-Id: <20220412062946.202178265@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

[ Upstream commit d35786b3a28dee20b12962ae2dd365892a99ed1a ]

No function is checking mc146818_get_time() return values yet, so
correct them to make them more customary.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211210200131.153887-3-mat.jonczyk@o2.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 04b05e3b68cb..bd48cee3027e 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -25,7 +25,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
 		spin_unlock_irqrestore(&rtc_lock, flags);
 		memset(time, 0xff, sizeof(*time));
-		return 0;
+		return -EIO;
 	}
 
 	/*
@@ -116,7 +116,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 
 	time->tm_mon--;
 
-	return RTC_24H;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mc146818_get_time);
 
-- 
2.35.1



