Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9804ABC12
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383483AbiBGLaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383684AbiBGLXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:23:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F3FC0401F0;
        Mon,  7 Feb 2022 03:23:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9271E6126D;
        Mon,  7 Feb 2022 11:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F859C004E1;
        Mon,  7 Feb 2022 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233000;
        bh=tvZEM60YYnpiLaqprdHNK3Tb+A8gmqs5ag5ZSNH2XMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mo+Fahqc6Qjr1l4+HpPxpX2Mm2v61A4tBu1eTDM2jYcDkl4Y9vCaY3mFBg6f8Urhe
         uE8jUEriMVE+UKxa19Eesz6OC83jZQLVt+Rw81YS2b7GnFCOpLO6rNZq4MHtC1E5bN
         Ia9EIfWPjMTaIMxwQhYC2SKnwJka01vWBEENa0AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riwen Lu <luriwen@kylinos.cn>,
        Eric Wong <e@80x24.org>,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 59/74] rtc: cmos: Evaluate century appropriate
Date:   Mon,  7 Feb 2022 12:06:57 +0100
Message-Id: <20220207103759.158334607@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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

From: Riwen Lu <luriwen@kylinos.cn>

commit ff164ae39b82ee483b24579c8e22a13a8ce5bd04 upstream.

There's limiting the year to 2069. When setting the rtc year to 2070,
reading it returns 1970. Evaluate century starting from 19 to count the
correct year.

$ sudo date -s 20700106
Mon 06 Jan 2070 12:00:00 AM CST
$ sudo hwclock -w
$ sudo hwclock -r
1970-01-06 12:00:49.604968+08:00

Fixes: 2a4daadd4d3e5071 ("rtc: cmos: ignore bogus century byte")

Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Acked-by: Eric Wong <e@80x24.org>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220106084609.1223688-1-luriwen@kylinos.cn
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl> # preparation for stable
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-mc146818-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -83,7 +83,7 @@ unsigned int mc146818_get_time(struct rt
 	time->tm_year += real_year - 72;
 #endif
 
-	if (century > 20)
+	if (century > 19)
 		time->tm_year += (century - 19) * 100;
 
 	/*


