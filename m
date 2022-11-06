Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC18C61E3EF
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiKFRFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiKFRFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:05:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C6110FE4;
        Sun,  6 Nov 2022 09:04:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 338F8B80C6D;
        Sun,  6 Nov 2022 17:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FC8C433D7;
        Sun,  6 Nov 2022 17:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754290;
        bh=GBvxC92X5aZMOeIL3/LdoqGdqXcHCSF6AmwTzSf1DqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctINbgcnuEkbaOGsJI45YC6XuqcL81sJ4ciAzHxqiNuFB5c7Jf8VSeHECAnDPqAWL
         RmIxpExusH+fYt1yfMqp1JL894BRKycSdsKm2iN3iU7EwikXom1D47tk2L0Rj1ebxy
         JCd3T8yQs49RxjE3ZsnY0s5IEbLYxta9MX4BOHT8dxc8O6mfZXrwEayVMbbXPCyaSO
         17PxeNAsiASBj+YDxa470HA1/DNLgZN3Vj+eJYfnFkOq3vS0Ngpu4hMZC/rdkfxBRv
         V/CVjht00VXzR+Hp3QtwbfLO4M5PBJWMKUEqd6n0npwhZIoneJPgI3pzHlX4vstozX
         z6/ArrtHuqMXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jelle van der Waa <jvanderwaa@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 25/30] platform/x86: thinkpad_acpi: Fix reporting a non present second fan on some models
Date:   Sun,  6 Nov 2022 12:03:37 -0500
Message-Id: <20221106170345.1579893-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
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

From: Jelle van der Waa <jvanderwaa@redhat.com>

[ Upstream commit a10d50983f7befe85acf95ea7dbf6ba9187c2d70 ]

thinkpad_acpi was reporting 2 fans on a ThinkPad T14s gen 1, even though
the laptop has only 1 fan.

The second, not present fan always reads 65535 (-1 in 16 bit signed),
ignore fans which report 65535 to avoid reporting the non present fan.

Signed-off-by: Jelle van der Waa <jvanderwaa@redhat.com>
Link: https://lore.kernel.org/r/20221019194751.5392-1-jvanderwaa@redhat.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2dbb9fc011a7..353507d18e11 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -263,6 +263,8 @@ enum tpacpi_hkey_event_t {
 #define TPACPI_DBG_BRGHT	0x0020
 #define TPACPI_DBG_MIXER	0x0040
 
+#define FAN_NOT_PRESENT		65535
+
 #define strlencmp(a, b) (strncmp((a), (b), strlen(b)))
 
 
@@ -8876,7 +8878,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 			/* Try and probe the 2nd fan */
 			tp_features.second_fan = 1; /* needed for get_speed to work */
 			res = fan2_get_speed(&speed);
-			if (res >= 0) {
+			if (res >= 0 && speed != FAN_NOT_PRESENT) {
 				/* It responded - so let's assume it's there */
 				tp_features.second_fan = 1;
 				tp_features.second_fan_ctl = 1;
-- 
2.35.1

