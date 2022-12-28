Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1768657D04
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiL1Pib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiL1Pib (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:38:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A54916591
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B1EDB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA90C433D2;
        Wed, 28 Dec 2022 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241907;
        bh=qtKCOpNDs6clThnZ2VvpYciND2sFhVaJ054d9J5CKTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9vNe/w1ZNSQFiChTBZBwJPycjTbIClRLoheOmt7idejn4w5kKjIIZerwjpkdkTw2
         I4v++GJ5xUHmRkkHHrWbLoaHDo+F87vO25F/pWL4a842VvxtsWdv5vgA34JY8FExgW
         wKZORSNu5Pauh1oiN2FuEH0q/kN6Fj4qex2xY42w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 541/731] rtc: cmos: fix build on non-ACPI platforms
Date:   Wed, 28 Dec 2022 15:40:48 +0100
Message-Id: <20221228144312.223723630@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit db4e955ae333567dea02822624106c0b96a2f84f ]

Now that rtc_wake_setup is called outside of cmos_wake_setup, it also need
to be defined on non-ACPI platforms.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20221018203512.2532407-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 01fb31f8e534..58cc2bae2f8a 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1346,6 +1346,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP
-- 
2.35.1



