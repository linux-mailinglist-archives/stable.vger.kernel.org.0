Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC2568D0D
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiGFPbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiGFPbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2B223158;
        Wed,  6 Jul 2022 08:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5200861FDB;
        Wed,  6 Jul 2022 15:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12CFC341C8;
        Wed,  6 Jul 2022 15:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121475;
        bh=SXBs8PJTooKJkdHbWMfHeTXXHYAQPjBwFTdpDhHDu64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugkvIpyG8EhU+yT3ZmumnKeVCoaUz19q96VLFStnaI3BZhARdPg27RZqq3S8AJspS
         tXndA2zKv6ODysLNP+umQFIJE4dyZ3I8rPOf+X1k17UteLU11YR+HU7kyc0CtFQOFr
         AEagjXaQEWxQJumyfdBf7a8+LBE6vb7ioRGmKpXVFEkl7IVlaG/d8lac9ZNODfLgtt
         AHeka9CPdanhhk99N4bxLDavR6k3aA4uD6B3gnNGXgXX9KphmSjMmPp89cSWSMcuMY
         MYhK1pUk21ukA1cnvkuLmqQ2Zycf9NXMZunubskyoSOjpe/03KRY1bCel9Ntmbj57g
         iZ4fhQK6al4Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jorge Lopez <jorge.lopez2@hp.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 14/22] platform/x86: hp-wmi: Ignore Sanitization Mode event
Date:   Wed,  6 Jul 2022 11:30:32 -0400
Message-Id: <20220706153041.1597639-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153041.1597639-1-sashal@kernel.org>
References: <20220706153041.1597639-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 9ab762a84b8094540c18a170e5ddd6488632c456 ]

After system resume the hp-wmi driver may complain:
[ 702.620180] hp_wmi: Unknown event_id - 23 - 0x0

According to HP it means 'Sanitization Mode' and it's harmless to just
ignore the event.

Cc: Jorge Lopez <jorge.lopez2@hp.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20220628123726.250062-1-kai.heng.feng@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 0e6ed75c70f3..c63ec1471b84 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -89,6 +89,7 @@ enum hp_wmi_event_ids {
 	HPWMI_BACKLIT_KB_BRIGHTNESS	= 0x0D,
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
+	HPWMI_SANITIZATION_MODE		= 0x17,
 };
 
 /*
@@ -846,6 +847,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		break;
 	case HPWMI_BATTERY_CHARGE_PERIOD:
 		break;
+	case HPWMI_SANITIZATION_MODE:
+		break;
 	default:
 		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
-- 
2.35.1

