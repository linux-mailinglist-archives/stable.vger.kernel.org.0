Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2135E148447
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389884AbgAXLQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390419AbgAXLQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:50 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 317A920704;
        Fri, 24 Jan 2020 11:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864609;
        bh=iWOvmtPuQpPbp+4US4yRbuGCEWa4v0sdlhxeSTCZgLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypx0V8Y9N9HB5e6mY6tVa2LURYDAHLG57pbwWRSV3O3BiI2D/63sBrQ/gfHoKE/ez
         yuTUfk3oTEJevP78mYRggsh3ArPNPD57fFa5OyF6RH9fqkzVqmCR+hpFV+jWsgBICy
         +2VBMO5fCfefDYVnj2VOTNLz2/Lx3icpp4TMiVQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Zhao Lijian <lijian.zhao@intel.com>
Subject: [PATCH 4.19 301/639] ACPI: button: reinitialize button state upon resume
Date:   Fri, 24 Jan 2020 10:27:51 +0100
Message-Id: <20200124093124.646463561@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 870eb5c7516a5..a25d77b3a16ad 100644
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



