Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A51A66C5D7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjAPQLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjAPQKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:10:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549B4298EC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C006102A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B26C433D2;
        Mon, 16 Jan 2023 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885202;
        bh=FVqygJ+YhGPY+7EHQUm2u2eaTIW3OhlNwjTo5g4bMpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfraE7y/TNNq5ZXgu/AqluRzVihEDXz4sJGOe3iR82MwPIoVW2ar0Xg5/BnQX9bRL
         KkMQlpzw9qOueXpU1QCQOfbE2kXI8TWcly+TsSCoNRjMYD90CfFPkLRj8DgjXKOeho
         c8RjEWIrKTdr7+5usxOKCQATfOyrO8swXF5Fa/OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/64] xhci: Add xhci_reset_halted_ep() helper function
Date:   Mon, 16 Jan 2023 16:51:34 +0100
Message-Id: <20230116154744.530647590@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit d8ac95001bea683d2088acb3e61613a27b8d2d5f ]

Create a separate helper function to issue reset endpont commands
to clear halted endpoints.

This is useful for cases where a halted endpoint is discovered while
completing another command, and the endpoint halt needs to be cleared
with a endpoint reset first.

No functional changes

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210129130044.206855-16-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1575120972e ("xhci: Prevent infinite loop in transaction errors recovery for streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index a0d210d3a3c6..b4a510450ac2 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -773,6 +773,26 @@ static void xhci_unmap_td_bounce_buffer(struct xhci_hcd *xhci,
 	seg->bounce_offs = 0;
 }
 
+static int xhci_reset_halted_ep(struct xhci_hcd *xhci, unsigned int slot_id,
+				unsigned int ep_index, enum xhci_ep_reset_type reset_type)
+{
+	struct xhci_command *command;
+	int ret = 0;
+
+	command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
+	if (!command) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	ret = xhci_queue_reset_ep(xhci, command, slot_id, ep_index, reset_type);
+done:
+	if (ret)
+		xhci_err(xhci, "ERROR queuing reset endpoint for slot %d ep_index %d, %d\n",
+			 slot_id, ep_index, ret);
+	return ret;
+}
+
 /*
  * When we get a command completion for a Stop Endpoint Command, we need to
  * unlink any cancelled TDs from the ring.  There are two ways to do that:
@@ -1929,8 +1949,9 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 				struct xhci_td *td,
 				enum xhci_ep_reset_type reset_type)
 {
-	struct xhci_command *command;
 	unsigned int slot_id = ep->vdev->slot_id;
+	int err;
+
 	/*
 	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
 	 * Device will be reset soon to recover the link so don't do anything
@@ -1938,13 +1959,11 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 	if (ep->vdev->flags & VDEV_PORT_ERROR)
 		return;
 
-	command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
-	if (!command)
-		return;
-
 	ep->ep_state |= EP_HALTED;
 
-	xhci_queue_reset_ep(xhci, command, slot_id, ep->ep_index, reset_type);
+	err = xhci_reset_halted_ep(xhci, slot_id, ep->ep_index, reset_type);
+	if (err)
+		return;
 
 	if (reset_type == EP_HARD_RESET) {
 		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
-- 
2.35.1



