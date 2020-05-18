Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAB41D83D1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbgERSHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387436AbgERSHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A906220C09;
        Mon, 18 May 2020 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825267;
        bh=LKxni0uILG5TbrYILoYC0DaokGze+8/lhCaMHSWGj5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PyirHsl7TmhFkNWdiy7zr5JVGKHYThIXfQlu1yVlkVld7tuns3gLQ4d9B70r+64y
         9EclEndWW8wFEg1ZlSF3wUq+LiLSBWu/zuv6d8Qyk9jBIGqPDSisM53jdCyYKeIRhg
         OXmhlUKEoowcYQBhKMLK0A/dyPAW3TIbmhdaLeHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.6 165/194] usb: gadget: tegra-xudc: Fix idle suspend/resume
Date:   Mon, 18 May 2020 19:37:35 +0200
Message-Id: <20200518173544.955691616@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/usb/gadget/udc/tegra-xudc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3740,11 +3740,11 @@ static int __maybe_unused tegra_xudc_sus
 
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
 


