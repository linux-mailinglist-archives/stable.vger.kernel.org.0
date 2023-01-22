Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05612676E6A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjAVPKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjAVPKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:10:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1341F5D0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49BD460C61
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B090C433EF;
        Sun, 22 Jan 2023 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400214;
        bh=QeYUbsBTNguYOfCvKbdTiOdXNThjyDLsgrAfsXvBgP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHiCSb8kWoJiLXWq2G4w1KXkiT61Cq7a0UdHrfrfPKfxj7/FgRhxlDLVbHznlbv74
         OWrLWE6+NIGNJHb/DceJdPvMoJ1hIx9pyEiR5D9Fn9xZ+GaeO6Yy16xzn5hB3LUCmx
         ec1kmLtsC1TTO9ovZDw9tnmyGP1Q1sVmtQIA9Q1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 16/55] xhci: Add a flag to disable USB3 lpm on a xhci root port level.
Date:   Sun, 22 Jan 2023 16:04:03 +0100
Message-Id: <20230122150222.919479654@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 0522b9a1653048440da5f21747f21e498b9220d1 upstream.

One USB3 roothub port may support link power management, while another
root port on the same xHC can't due to different retimers used for
the ports.

This is the case with Intel Alder Lake, and possible future platforms
where retimers used for USB4 ports cause too long exit latecy to
enable native USB3 lpm U1 and U2 states.

Add a flag in the xhci port structure to indicate if the port is
lpm_incapable, and check it while calculating exit latency.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    8 ++++++++
 drivers/usb/host/xhci.h |    1 +
 2 files changed, 9 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4999,6 +4999,7 @@ static int xhci_enable_usb3_lpm_timeout(
 			struct usb_device *udev, enum usb3_link_state state)
 {
 	struct xhci_hcd	*xhci;
+	struct xhci_port *port;
 	u16 hub_encoded_timeout;
 	int mel;
 	int ret;
@@ -5012,6 +5013,13 @@ static int xhci_enable_usb3_lpm_timeout(
 			!xhci->devs[udev->slot_id])
 		return USB3_LPM_DISABLED;
 
+	/* If connected to root port then check port can handle lpm */
+	if (udev->parent && !udev->parent->parent) {
+		port = xhci->usb3_rhub.ports[udev->portnum - 1];
+		if (port->lpm_incapable)
+			return USB3_LPM_DISABLED;
+	}
+
 	hub_encoded_timeout = xhci_calculate_lpm_timeout(hcd, udev, state);
 	mel = calculate_max_exit_latency(udev, state, hub_encoded_timeout);
 	if (mel < 0) {
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1724,6 +1724,7 @@ struct xhci_port {
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
+	unsigned int		lpm_incapable:1;
 };
 
 struct xhci_hub {


