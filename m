Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5C1F2E34
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbgFIAjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:32866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgFHXNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D48A4208C3;
        Mon,  8 Jun 2020 23:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657990;
        bh=39vqlRfsBoNdJeuI4mEYkQrLbavGQuPFoJIQ8ZIkAzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAaKUN4WzHRmZ/D2SLtDdWHbpOTC7oR9EhMeBaUHWpvcmj55xVi/E0Me2Qy21ERK5
         qqNKkAlQEy5N0xk5M8sKaDKMX/4Iyq491goQQlmoLuddS6b6vFPR1jDDUj5EGv+/st
         uCfFvxnHwv8ou2SmT3VxQfns4qOg6C6MRMRnXQqc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 049/606] usb: gadget: tegra-xudc: Fix idle suspend/resume
Date:   Mon,  8 Jun 2020 19:02:54 -0400
Message-Id: <20200608231211.3363633-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit 0534d40160cb9505073b0ecf5e7210daee319a66 upstream.

When the XUDC device is idle (i.e. powergated), care must be taken not
to access any registers because that would lead to a crash.

Move the call to tegra_xudc_device_mode_off() into the same conditional
as the tegra_xudc_powergate() call to make sure we only force device
mode off if the XUDC is actually powered up.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index 634c2c19a176..a22d190d00a0 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3740,11 +3740,11 @@ static int __maybe_unused tegra_xudc_suspend(struct device *dev)
 
 	flush_work(&xudc->usb_role_sw_work);
 
-	/* Forcibly disconnect before powergating. */
-	tegra_xudc_device_mode_off(xudc);
-
-	if (!pm_runtime_status_suspended(dev))
+	if (!pm_runtime_status_suspended(dev)) {
+		/* Forcibly disconnect before powergating. */
+		tegra_xudc_device_mode_off(xudc);
 		tegra_xudc_powergate(xudc);
+	}
 
 	pm_runtime_disable(dev);
 
-- 
2.25.1

