Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572343A00D9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbhFHSsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235289AbhFHSqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:46:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6DF2613B6;
        Tue,  8 Jun 2021 18:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177440;
        bh=w2jsVu/cA/GWirc37MdF4OvML5NxXnBavGp42HLZVHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zH45wYWFI3tvPQ7Ro/vA2P3cc3wpd0MKBs0fBf200V1pwTrJGkKFezpW9CnSS1d0Q
         KALUMy0jSVt/6QVkvsOJ1Z/BT0ykjsenYEQab+jaFL9lhTq3yCwMWi4U9aPtD6OkH+
         mBSOd90RxrWQ9eGnUeCTny8OyN4dDTHMKWpvlyCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>
Subject: [PATCH 5.4 52/78] usb: dwc2: Fix build in periphal-only mode
Date:   Tue,  8 Jun 2021 20:27:21 +0200
Message-Id: <20210608175937.036827542@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

In branches to which 24d209dba5a3 ("usb: dwc2: Fix hibernation between
host and device modes.") has been back-ported, the bus_suspended member
of struct dwc2_hsotg is only present in builds that support host-mode.
To avoid having to pull in several more non-Fix commits in order to
get it to compile, wrap the usage of the member in a macro conditional.

Fixes: 24d209dba5a3 ("usb: dwc2: Fix hibernation between host and device modes.")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/core_intr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -712,7 +712,11 @@ static inline void dwc_handle_gpwrdn_dis
 	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
 
 	hsotg->hibernated = 0;
+
+#if IS_ENABLED(CONFIG_USB_DWC2_HOST) ||	\
+	IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
 	hsotg->bus_suspended = 0;
+#endif
 
 	if (gpwrdn & GPWRDN_IDSTS) {
 		hsotg->op_state = OTG_STATE_B_PERIPHERAL;


