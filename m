Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3795329AEC2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754031AbgJ0ODt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754027AbgJ0ODs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:03:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 906F32222C;
        Tue, 27 Oct 2020 14:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807428;
        bh=Fh3CurmhpDkxBXxMF8kBsENV/noZeSJClYThqjOkMQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/2IMW5OucqYRKmcb3IbAlZejEWFHVp8PHoFYmDmErMLpsj2TNfSV3UbWhnMzReoF
         a5RoztjF2rI0U0EQWttMmfreU0zK5dgF/AMxTArZ4CYK9Fh3GIcXZupLvhtDL56YP5
         OcElLR+ZEg2vUq4nWEOhd/d//DvVSXW08PtJpimw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 050/139] usb: gadget: f_ncm: fix ncm_bitrate for SuperSpeed and above.
Date:   Tue, 27 Oct 2020 14:49:04 +0100
Message-Id: <20201027134904.507540923@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Colitti <lorenzo@google.com>

[ Upstream commit 986499b1569af980a819817f17238015b27793f6 ]

Currently, SuperSpeed NCM gadgets report a speed of 851 Mbps
in USB_CDC_NOTIFY_SPEED_CHANGE. But the calculation appears to
assume 16 packets per microframe, and USB 3 and above no longer
use microframes.

Maximum speed is actually much higher. On a direct connection,
theoretical throughput is at most 3.86 Gbps for gen1x1 and
9.36 Gbps for gen2x1, and I have seen gadget->host iperf
throughput of >2 Gbps for gen1x1 and >4 Gbps for gen2x1.

Unfortunately the ConnectionSpeedChange defined in the CDC spec
only uses 32-bit values, so we can't report accurate numbers for
10Gbps and above. So, report 3.75Gbps for SuperSpeed (which is
roughly maximum theoretical performance) and 4.25Gbps for
SuperSpeed Plus (which is close to the maximum that we can report
in a 32-bit unsigned integer).

This results in:

[50879.191272] cdc_ncm 2-2:1.0 enx228b127e050c: renamed from usb0
[50879.234778] cdc_ncm 2-2:1.0 enx228b127e050c: 3750 mbit/s downlink 3750 mbit/s uplink

on SuperSpeed and:

[50798.434527] cdc_ncm 8-2:1.0 enx228b127e050c: renamed from usb0
[50798.524278] cdc_ncm 8-2:1.0 enx228b127e050c: 4250 mbit/s downlink 4250 mbit/s uplink

on SuperSpeed Plus.

Fixes: 1650113888fe ("usb: gadget: f_ncm: add SuperSpeed descriptors for CDC NCM")
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_ncm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 0061bf130598e..ba8fa97a62cfd 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -91,8 +91,10 @@ static inline struct f_ncm *func_to_ncm(struct usb_function *f)
 /* peak (theoretical) bulk transfer rate in bits-per-second */
 static inline unsigned ncm_bitrate(struct usb_gadget *g)
 {
-	if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
-		return 13 * 1024 * 8 * 1000 * 8;
+	if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
+		return 4250000000U;
+	else if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
+		return 3750000000U;
 	else if (gadget_is_dualspeed(g) && g->speed == USB_SPEED_HIGH)
 		return 13 * 512 * 8 * 1000 * 8;
 	else
-- 
2.25.1



