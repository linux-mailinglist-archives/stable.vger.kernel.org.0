Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68C6472827
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhLMKIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbhLMKGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:06:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E95C08E92E;
        Mon, 13 Dec 2021 01:51:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C934B80E12;
        Mon, 13 Dec 2021 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716DCC00446;
        Mon, 13 Dec 2021 09:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389059;
        bh=2do02VBQ0EAtfIjgoQ5YBaSP/HB6Cg8sTaaPHb+Vx80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiUGMXA6KQXRFSjD6LFt60yl0nBYIYpsp79CbMhFSUIzzt/hUAGUPfZGPv562vMj9
         Ptfb0VHBEOgWGhFuZHbEjBd8abDO0cLjxAiZUoV3w4Cy/i/YwfTMCwSCnkvYsbXSdP
         PHf277PLXeYWlqOlAeD9LVpAvTl1kekVXk0EF5jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 103/132] xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime suspending
Date:   Mon, 13 Dec 2021 10:30:44 +0100
Message-Id: <20211213092942.626329449@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 811ae81320da53a5670c36970cefacca8519f90e upstream.

When the xHCI is quirked with XHCI_RESET_ON_RESUME, runtime resume
routine also resets the controller.

This is bad for USB drivers without reset_resume callback, because
there's no subsequent call of usb_dev_complete() ->
usb_resume_complete() to force rebinding the driver to the device. For
instance, btusb device stops working after xHCI controller is runtime
resumed, if the controlled is quirked with XHCI_RESET_ON_RESUME.

So always take XHCI_RESET_ON_RESUME into account to solve the issue.

Cc: <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211210141735.1384209-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3893,7 +3893,6 @@ static void xhci_free_dev(struct usb_hcd
 	struct xhci_slot_ctx *slot_ctx;
 	int i, ret;
 
-#ifndef CONFIG_USB_DEFAULT_PERSIST
 	/*
 	 * We called pm_runtime_get_noresume when the device was attached.
 	 * Decrement the counter here to allow controller to runtime suspend
@@ -3901,7 +3900,6 @@ static void xhci_free_dev(struct usb_hcd
 	 */
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		pm_runtime_put_noidle(hcd->self.controller);
-#endif
 
 	ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
 	/* If the host is halted due to driver unload, we still need to free the
@@ -4053,14 +4051,12 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 
 	xhci_debugfs_create_slot(xhci, slot_id);
 
-#ifndef CONFIG_USB_DEFAULT_PERSIST
 	/*
 	 * If resetting upon resume, we can't put the controller into runtime
 	 * suspend if there is a device attached.
 	 */
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		pm_runtime_get_noresume(hcd->self.controller);
-#endif
 
 	/* Is this a LS or FS device under a HS hub? */
 	/* Hub or peripherial? */


