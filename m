Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F53419B11
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhI0RPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236250AbhI0RMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 253436128A;
        Mon, 27 Sep 2021 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762530;
        bh=MbkHdspzcPTIe80Wb9E9CW+bEsiWvthVlZ37+Yg7yt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aryy3jzlaM9WzX485oAFzX2EiFugHwd25juELA1795FpMPSfSHjh/RrSWAGvF95wp
         jyjOCTK7vPQYY8gzEt3sF9wsa4b/0k26C6zFv6L80k3ZUxz6uPuG5qa5UsEZQ6ykn8
         4wPWK4AG2g/xBvmTMOSuq/JAFHmMGu7h+eDV8LwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.10 026/103] xhci: Set HCD flag to defer primary roothub registration
Date:   Mon, 27 Sep 2021 19:01:58 +0200
Message-Id: <20210927170226.635557357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit b7a0a792f864583207c593b50fd1b752ed89f4c1 upstream.

Set "HCD_FLAG_DEFER_RH_REGISTER" to hcd->flags in xhci_run() to defer
registering primary roothub in usb_add_hcd(). This will make sure both
primary roothub and secondary roothub will be registered along with the
second HCD. This is required for cold plugged USB devices to be detected
in certain PCIe USB cards (like Inateck USB card connected to AM64 EVM
or J7200 EVM).

CC: stable@vger.kernel.org # 5.4+
Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20210909064200.16216-3-kishon@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -693,6 +693,7 @@ int xhci_run(struct usb_hcd *hcd)
 		if (ret)
 			xhci_free_command(xhci, command);
 	}
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 


