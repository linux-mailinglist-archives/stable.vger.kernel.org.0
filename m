Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE88304A73
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbhAZFEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731256AbhAYSxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8384B22B3F;
        Mon, 25 Jan 2021 18:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600762;
        bh=7YJG0bSBD3hQKWurWV0Ha7hCKS0B8WTwO/yhFspp0nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgPj/ceqZLDHkDrJFnDt2NpbcKLTMhbErKlT2t1AqVEYJL1fJPpCQsDtGxIpT9AiX
         //P15LIYTkLJ+sozdXybxqSDW8iq3QuHeX/bQb5i/Kc3iOGhmurXMv/pjpPXbBhXV/
         8Ha+U8xkWe7R8e6NmC1b4g4gY9YnlaEVF55NFfU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JC Kuo <jckuo@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 141/199] xhci: tegra: Delay for disabling LFPS detector
Date:   Mon, 25 Jan 2021 19:39:23 +0100
Message-Id: <20210125183222.167300004@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
@@ -623,6 +623,13 @@ static void tegra_xusb_mbox_handle(struc
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


