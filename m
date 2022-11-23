Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DF3635EAB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbiKWM5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238637AbiKWMzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:55:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C507690592;
        Wed, 23 Nov 2022 04:45:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59439B81F6E;
        Wed, 23 Nov 2022 12:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFD0C433D7;
        Wed, 23 Nov 2022 12:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207511;
        bh=3MviyrC2njBscUAbTJZ9qmoodCR9Uz6Jufyhkr1+Q0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNWGuOz6XM9WpO/v/cS4qWyF+TyUghbpe3dMwckZF583syXykIdeROShNP6QGQ6gf
         ri1VTD1N/wQe4lnSfi8W8Bp8A3voLAvV4tWeFCZ+uduzh1beC0ZLgAtOWgK2ylorL7
         Tt2nu9rp/iFduvi2sX65/CWEEXlOTfNNwU2s9M2jMoO/nBZFrgFxBAOBicJ1S5bNGq
         sqyGD54RZ3sCGeunb6PRkwndsvuzAxy932r4dm7WRpmFgqhepoQpyTi0MXrWR9M22Q
         a8NtwouFi70X2CWBWK9RoxSUN4DHHcM5tFMzlnw9B+j+DlbIlZfQiXNvFDAEFNOkIp
         FxNTouZo/7QAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/11] platform/x86: hp-wmi: Ignore Smart Experience App event
Date:   Wed, 23 Nov 2022 07:44:51 -0500
Message-Id: <20221123124458.266492-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124458.266492-1-sashal@kernel.org>
References: <20221123124458.266492-1-sashal@kernel.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 8b9b6a044b408283b086702b1d9e3cf4ba45b426 ]

Sometimes hp-wmi driver complains on system resume:
[ 483.116451] hp_wmi: Unknown event_id - 33 - 0x0

According to HP it's a feature called "HP Smart Experience App" and it's
safe to be ignored.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20221114073842.205392-1-kai.heng.feng@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index f911410bb4c7..6f35becaa743 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -76,6 +76,7 @@ enum hp_wmi_event_ids {
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
 	HPWMI_SANITIZATION_MODE		= 0x17,
+	HPWMI_SMART_EXPERIENCE_APP	= 0x21,
 };
 
 struct bios_args {
@@ -634,6 +635,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		break;
 	case HPWMI_SANITIZATION_MODE:
 		break;
+	case HPWMI_SMART_EXPERIENCE_APP:
+		break;
 	default:
 		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
-- 
2.35.1

