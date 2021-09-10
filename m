Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5525240621B
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240541AbhIJAoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233685AbhIJAUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F796023D;
        Fri, 10 Sep 2021 00:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233166;
        bh=g6oxqBtujSLDxF3lSt9un3bshuYJvb3z1daAs5f6syQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQ2V6lAusiy2glVZtzN9hdma5/ndylk16L6vtejsGCL8MNSv5+nE7zP4Ak3dtG7+q
         ljLcL7Sbafeig/ffAjWM5RhbPysHvbLLI7wDevhDCq0Y4R2yNj2TcchHiumt936rWz
         lmInUwf+r0DoOB26m4HmKsk8eBtCoiiwdmEte/O6faCnEHkVclNhefYImd6ydKLFH4
         rO2JuiHF5cgmP9/Qaip5TpyjsLxDRwobQfD0G9opdPuzRK8NALu+JiX0lVQXwCME3w
         kZTBBf0L72ozcSago+xd1N2suhT4VDFxxH84PY9J+CH7xxnPhQuFDR6VHKxGDmsr1V
         dX1IGQhUl6uOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Meng Dong <whenov@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 46/88] platform/x86: ideapad-laptop: Fix Legion 5 Fn lock LED
Date:   Thu,  9 Sep 2021 20:17:38 -0400
Message-Id: <20210910001820.174272-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Dong <whenov@gmail.com>

[ Upstream commit 3ae86d2d4704796ee658a34245cb86e68c40c5d7 ]

This patch fixes the bug 212671.
Althrough the Fn lock (Fn + Esc) works on Legion 5 (R7000P), its LED
light does not change with the state. This modification sets the Fn lock
state to its current value on receiving the wmi event
8FC0DE0C-B4E4-43FD-B0F3-8871711C1294 to update the LED state.

Signed-off-by: Meng Dong <whenov@gmail.com>
Link: https://lore.kernel.org/r/20210817171203.12855-1-whenov@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 387817290921..15de129e5777 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -41,6 +41,7 @@
 static const char *const ideapad_wmi_fnesc_events[] = {
 	"26CAB2E5-5CF1-46AE-AAC3-4A12B6BA50E6", /* Yoga 3 */
 	"56322276-8493-4CE8-A783-98C991274F5E", /* Yoga 700 */
+	"8FC0DE0C-B4E4-43FD-B0F3-8871711C1294", /* Legion 5 */
 };
 #endif
 
@@ -1447,11 +1448,19 @@ static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
 static void ideapad_wmi_notify(u32 value, void *context)
 {
 	struct ideapad_private *priv = context;
+	unsigned long result;
 
 	switch (value) {
 	case 128:
 		ideapad_input_report(priv, value);
 		break;
+	case 208:
+		if (!eval_hals(priv->adev->handle, &result)) {
+			bool state = test_bit(HALS_FNLOCK_STATE_BIT, &result);
+
+			exec_sals(priv->adev->handle, state ? SALS_FNLOCK_ON : SALS_FNLOCK_OFF);
+		}
+		break;
 	default:
 		dev_info(&priv->platform_device->dev,
 			 "Unknown WMI event: %u\n", value);
-- 
2.30.2

