Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F1E30334D
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbhAZEtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730047AbhAYSqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F0922D58;
        Mon, 25 Jan 2021 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600344;
        bh=UKDr5wvYWa3oDVHqw81KBDA1tJIdeyCpvj3hgKXAwtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wclE6nT0ickn82xmdWx1+UsIsNQRF44kGciOLkhVWTUD6DuCYiyUwNW9gQ6qUGAFL
         fMaSHcs7iVNrgLFtw7VOtihgOg/vUQUxl/8Bc7llWscWRCpl6WAyUgUXXvitUrdpKW
         fCcKYrq9NkDwiG5aO7ht6oN85TFqjE63UvtM7FWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JC Kuo <jckuo@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 65/86] xhci: tegra: Delay for disabling LFPS detector
Date:   Mon, 25 Jan 2021 19:39:47 +0100
Message-Id: <20210125183203.792881184@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JC Kuo <jckuo@nvidia.com>

commit da7e0c3c2909a3d9bf8acfe1db3cb213bd7febfb upstream.

Occasionally, we are seeing some SuperSpeed devices resumes right after
being directed to U3. This commits add 500us delay to ensure LFPS
detector is disabled before sending ACK to firmware.

[   16.099363] tegra-xusb 70090000.usb: entering ELPG
[   16.104343] tegra-xusb 70090000.usb: 2-1 isn't suspended: 0x0c001203
[   16.114576] tegra-xusb 70090000.usb: not all ports suspended: -16
[   16.120789] tegra-xusb 70090000.usb: entering ELPG failed

The register write passes through a few flop stages of 32KHz clock domain.
NVIDIA ASIC designer reviewed RTL and suggests 500us delay.

Cc: stable@vger.kernel.org
Signed-off-by: JC Kuo <jckuo@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210115161907.2875631-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-tegra.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -562,6 +562,13 @@ static void tegra_xusb_mbox_handle(struc
 								     enable);
 			if (err < 0)
 				break;
+
+			/*
+			 * wait 500us for LFPS detector to be disabled before
+			 * sending ACK
+			 */
+			if (!enable)
+				usleep_range(500, 1000);
 		}
 
 		if (err < 0) {


