Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC2259D4FF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbiHWIcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346018AbiHWIbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:31:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DA66DAE1;
        Tue, 23 Aug 2022 01:16:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5056F61238;
        Tue, 23 Aug 2022 08:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504D7C433D6;
        Tue, 23 Aug 2022 08:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242532;
        bh=kuYKk88RSu7FYIAyVvO8z2+iR0hHyGGdWODZnXNj8zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vXXPvMHE+npdAC/RN4Z1+bk/raK/fquuLMnHWzbe93PEu8dqB3HFXwHoWU6zfZyk
         HcCXuNx4XC45F/XUkP6oMusoNqtVBGvLvjQJSVF2KTSINmwjTW31RjoZXZq8gjqU9+
         BVN0iLGzLs3jhwSeJgNKHPIItsAnrspMxhYGJqV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeng Jingxiang <linuszeng@tencent.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.19 101/365] rtc: spear: set range max
Date:   Tue, 23 Aug 2022 10:00:02 +0200
Message-Id: <20220823080122.421683701@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zeng Jingxiang <linuszeng@tencent.com>

commit 03c4cd6f89e074a51e289eb9129ac646f0f2bd29 upstream.

In the commit f395e1d3b28d7c2c67b73bd467c4fb79523e1c65
("rtc: spear: set range"), the value of
RTC_TIMESTAMP_END_9999 was incorrectly set to range_min.
390	config->rtc->range_min = RTC_TIMESTAMP_BEGIN_0000;
391	config->rtc->range_max = RTC_TIMESTAMP_END_9999;

Fixes: f395e1d3b28d ("rtc: spear: set range")
Signed-off-by: Zeng Jingxiang <linuszeng@tencent.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220728100101.1906801-1-zengjx95@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-spear.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index d4777b01ab22..736fe535cd45 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -388,7 +388,7 @@ static int spear_rtc_probe(struct platform_device *pdev)
 
 	config->rtc->ops = &spear_rtc_ops;
 	config->rtc->range_min = RTC_TIMESTAMP_BEGIN_0000;
-	config->rtc->range_min = RTC_TIMESTAMP_END_9999;
+	config->rtc->range_max = RTC_TIMESTAMP_END_9999;
 
 	status = devm_rtc_register_device(config->rtc);
 	if (status)
-- 
2.37.2



