Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE42B13F628
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389778AbgAPTB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388712AbgAPRFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CBF205F4;
        Thu, 16 Jan 2020 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194344;
        bh=/iN5Lv/5xS6+NV97ObyRAfHsQdm5wUcuDcmt1iZWIz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqqx47MhkPwf/LIZ9LtHMaba5k0eplb2MLFh6gh2RqRF5DEvk1lvakYlUdAFPujqc
         pHRW008HUgJoFwbn+4hzgDntVA7nDnCrDOFxmJeprWnEDieJdaPoFY3CWYT9v9rP6G
         X0F0cSrAByGSwG+izYy3zZbwEmt0CdRzUuOGtJFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        Zhao Lijian <lijian.zhao@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 286/671] ACPI: button: reinitialize button state upon resume
Date:   Thu, 16 Jan 2020 11:58:44 -0500
Message-Id: <20200116170509.12787-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 13e962140be671f31a011543f11477af67a6c33e ]

With commit dfa46c50f65b ("ACPI / button: Fix an issue in
button.lid_init_state=ignore mode"), the lid device is considered to be
not compliant to SW_LID if the Lid state is unchanged when updating it.

This is not wrong, but we overlooked the resume case, where Lid state is
updated unconditionally in the button driver .resume() callback. And this
results in warning message "ACPI: button: The lid device is not compliant
to  SW_LID." after resume, if the machine is suspended with Lid opened and
then resumed with Lid opened.

Fix this by flushing the cached lid state before updating the Lid device
in .resume() callback.

Fixes: dfa46c50f65b ("ACPI / button: Fix an issue in button.lid_init_state=ignore mode")
Reported-and-tested-by: Zhao Lijian <lijian.zhao@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 870eb5c7516a..a25d77b3a16a 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -467,8 +467,11 @@ static int acpi_button_resume(struct device *dev)
 	struct acpi_button *button = acpi_driver_data(device);
 
 	button->suspended = false;
-	if (button->type == ACPI_BUTTON_TYPE_LID && button->input->users)
+	if (button->type == ACPI_BUTTON_TYPE_LID && button->input->users) {
+		button->last_state = !!acpi_lid_evaluate_state(device);
+		button->last_time = ktime_get();
 		acpi_lid_initialize_state(device);
+	}
 	return 0;
 }
 #endif
-- 
2.20.1

