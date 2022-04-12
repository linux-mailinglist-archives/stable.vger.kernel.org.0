Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044AF4FD89D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351598AbiDLHUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351783AbiDLHM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B8EEA1;
        Mon, 11 Apr 2022 23:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27E13B81B47;
        Tue, 12 Apr 2022 06:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7337CC385A6;
        Tue, 12 Apr 2022 06:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746358;
        bh=+KzC2is8F+hd1MCMYwzg3ElnC2qKzJPJ/WTEs6GkaaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdrFP9eADYqK1iK96sU+H2IaHxyGA9qTOOnUICEYkjIYjd0wi1Vnx5eqVvTDyfvI/
         16MIMSnJ2RC3NUGbpwYZ/rlh2pWPiA5Wn6UDXFld6Zw6uI7yeUoX01L88NU2CkQwzL
         ImChAUVxmJwNug09D/StPKauR7oQie1nZ3v/MqyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 253/277] rtc: mc146818-lib: fix signedness bug in mc146818_get_time()
Date:   Tue, 12 Apr 2022 08:30:56 +0200
Message-Id: <20220412062949.363717273@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7372971c1be5b7d4fdd8ad237798bdc1d1d54162 upstream.

The mc146818_get_time() function returns zero on success or negative
a error code on failure.  It needs to be type int.

Fixes: d35786b3a28d ("rtc: mc146818-lib: change return values of mc146818_get_time()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220111071922.GE11243@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-mc146818-lib.c |    2 +-
 include/linux/mc146818rtc.h    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -33,7 +33,7 @@ bool mc146818_does_rtc_work(void)
 }
 EXPORT_SYMBOL_GPL(mc146818_does_rtc_work);
 
-unsigned int mc146818_get_time(struct rtc_time *time)
+int mc146818_get_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -124,7 +124,7 @@ struct cmos_rtc_board_info {
 #endif /* ARCH_RTC_LOCATION */
 
 bool mc146818_does_rtc_work(void);
-unsigned int mc146818_get_time(struct rtc_time *time);
+int mc146818_get_time(struct rtc_time *time);
 int mc146818_set_time(struct rtc_time *time);
 
 #endif /* _MC146818RTC_H */


