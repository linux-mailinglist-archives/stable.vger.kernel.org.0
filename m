Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57649419B9A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbhI0RUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237400AbhI0RS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:18:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E377D6128C;
        Mon, 27 Sep 2021 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762747;
        bh=by1ip3jYucQI0cqCROHvv+vTOYFCdkGMSrWXk+kcxMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cxf97rW0hVcBraxY0QWkOYkuKjPkhmB523ARcFy8zcWOdd9qPLIowRqCDOcn4mSRq
         NWPoGyoLYq59F74r83nKrUCRF+MkmBeyl0XxdOkXLsejVauHSxqDIqpEGIQaXF5rWl
         Ke3HHvE+h5d6mBfrjnj0OfgRfDi0dtN+1fMsOJ08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.14 037/162] xhci: Set HCD flag to defer primary roothub registration
Date:   Mon, 27 Sep 2021 19:01:23 +0200
Message-Id: <20210927170234.767260874@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
@@ -692,6 +692,7 @@ int xhci_run(struct usb_hcd *hcd)
 		if (ret)
 			xhci_free_command(xhci, command);
 	}
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 


