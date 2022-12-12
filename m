Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324D2649FAE
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiLLNN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiLLNN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF89B30
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A96CB80D0C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2F0C433F0;
        Mon, 12 Dec 2022 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850806;
        bh=jn1Hb41fBiNLCAfkBwK/ZgAxCeBpCkmYAj7XZmyDhM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWgOgQuz1cpJnrwKNBJPbNaBNryP8DdhggcP/KjJXRYQZh03fnLwJVAn5R8Y+1K0f
         IbgDmUmsjWOZHkwMq+hrqKfY+JFT1NRaJlvUEp3pI1C1wHZrMSRbdQ7XwsW5sMtUfh
         D5/STh8A+o6krk63mPiZZm/cHzV6KmO0po6cw9T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/106] rtc: cmos: remove stale REVISIT comments
Date:   Mon, 12 Dec 2022 14:09:36 +0100
Message-Id: <20221212130926.306226418@linuxfoundation.org>
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

[ Upstream commit e1aba37569f0aa9c993f740828871e48eea79f98 ]

It appears mc146818_get_time() and mc146818_set_time() now correctly
use the century register as specified in the ACPI FADT table. It is not
clear what else could be done here.

These comments were introduced by
        commit 7be2c7c96aff ("[PATCH] RTC framework driver for CMOS RTCs")
in 2007, which originally referenced function get_rtc_time() in
include/asm-generic/rtc.h .

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210716210437.29622-1-mat.jonczyk@o2.pl
Stable-dep-of: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 8e8ce40f6440..ed4f512eabf0 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -229,19 +229,13 @@ static int cmos_read_time(struct device *dev, struct rtc_time *t)
 	if (!pm_trace_rtc_valid())
 		return -EIO;
 
-	/* REVISIT:  if the clock has a "century" register, use
-	 * that instead of the heuristic in mc146818_get_time().
-	 * That'll make Y3K compatility (year > 2070) easy!
-	 */
 	mc146818_get_time(t);
 	return 0;
 }
 
 static int cmos_set_time(struct device *dev, struct rtc_time *t)
 {
-	/* REVISIT:  set the "century" register if available
-	 *
-	 * NOTE: this ignores the issue whereby updating the seconds
+	/* NOTE: this ignores the issue whereby updating the seconds
 	 * takes effect exactly 500ms after we write the register.
 	 * (Also queueing and other delays before we get this far.)
 	 */
-- 
2.35.1



