Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3071861E444
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiKFRJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiKFRJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:09:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E7010B65;
        Sun,  6 Nov 2022 09:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD6F160D32;
        Sun,  6 Nov 2022 17:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAEFC43153;
        Sun,  6 Nov 2022 17:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754346;
        bh=Ef68W4NwjGbsOzalRyCpru/gKH3exkvFkF3fKzhFOrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7t9ZEzLJ9S2/qXUMZ/5OMsnbKCtJRsWPbd8d2yQ8FiRH/HX5PRs7QXC7Xd3as1oD
         umRB1XG2G4YKFUIn9EiF15T76TeQ00r5hDr0W1HHl0EWNz3rPvrg/hNTHQFjpvas8D
         lzvQEWurPaU6EZoRda1FfxCgszjJ35t1aWxqtFjNddom/bmnCWqwMfqLuBaQ9ZDsMs
         bjG5SVDEJrsLu1YrLGhdOAYMp5tT75w81ej7XY3OI9Jo17DfxXn2wx/vEThQLFwoGL
         GGrvd3lSEB4iJlOv8k0XS8k6dIXjIRDiU3tRGf39P2cE/qCsu5Il0C3T4L5LSvi8I3
         zsSp0IwrZcK/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/18] rtc: cmos: fix build on non-ACPI platforms
Date:   Sun,  6 Nov 2022 12:05:04 -0500
Message-Id: <20221106170509.1580304-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170509.1580304-1-sashal@kernel.org>
References: <20221106170509.1580304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index b90a603d6b12..3e7b6834a7b0 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1296,6 +1296,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP
-- 
2.35.1

