Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F108649FD7
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiLLNQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiLLNPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:15:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55362101F8
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6FA561043
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDEEC433EF;
        Mon, 12 Dec 2022 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850916;
        bh=lFjGZy635NdoFxSVWGMg/9MYUDXIrmraQx3ZM3OmtL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3KI+Q93omhyMBgJs5j3Qwhr9g2rEU5SnKe/NBqDYR8pgXzZaUS/YgOBFIgH2K0xD
         o5G8uLsxH6mNUZBm6SQFJqxk48yFlVBMATHM6SzjJfcVNaBwEyNLrvOAb/GKcvevj+
         NMK8XQD/BHyLI7LHobnp21x8NRa9FXAxZ3Z79l68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/106] rtc: mc146818-lib: fix signedness bug in mc146818_get_time()
Date:   Mon, 12 Dec 2022 14:10:06 +0100
Message-Id: <20221212130927.634259574@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7372971c1be5b7d4fdd8ad237798bdc1d1d54162 ]

The mc146818_get_time() function returns zero on success or negative
a error code on failure.  It needs to be type int.

Fixes: d35786b3a28d ("rtc: mc146818-lib: change return values of mc146818_get_time()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220111071922.GE11243@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 2 +-
 include/linux/mc146818rtc.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 3783aaf9dd5a..347655d24b5d 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -103,7 +103,7 @@ bool mc146818_does_rtc_work(void)
 }
 EXPORT_SYMBOL_GPL(mc146818_does_rtc_work);
 
-unsigned int mc146818_get_time(struct rtc_time *time)
+int mc146818_get_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index fb042e0e7d76..b0da04fe087b 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -126,7 +126,7 @@ struct cmos_rtc_board_info {
 #endif /* ARCH_RTC_LOCATION */
 
 bool mc146818_does_rtc_work(void);
-unsigned int mc146818_get_time(struct rtc_time *time);
+int mc146818_get_time(struct rtc_time *time);
 int mc146818_set_time(struct rtc_time *time);
 
 bool mc146818_avoid_UIP(void (*callback)(unsigned char seconds, void *param),
-- 
2.35.1



