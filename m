Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D8D370C6F
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbhEBOGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232151AbhEBOFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A68A4613B0;
        Sun,  2 May 2021 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964298;
        bh=v7fHhnwRDs/ST4nEXkbIvaAJ0Gcbqcq/Zz0OMgHmWV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sk/y58DzyxjI9zdqzarKwn7st2d72Jl67RmgtEAY6vV5K6OF2mTx7vE3ZwzJTfL8o
         1KfjYdcssnEiDPpb/jKnv8Zl3XsEYjxIz5c0ddr98zsbH8+SFYZsEFYYk62VwrkzU6
         YUAP0oOdtoFhMsenwQnvIcnYZ7mG6BaoW/DJ57CRv9HEDzuY40Fwd+TEhj2Np0cq5s
         IBRxQOY1I7rPOzuiEYQg/HfXZL7FHrCZqa317UGinUcBoJ7E7488L/yox7J/pgzQ5c
         sLotNoM2wc3SSXjyBfhmlXSY8RS+0J17l3QZxbK7nV81t6sf23eoVOMHr4pmml5YXY
         2/aPmCloxtZMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/34] xhci: check control context is valid before dereferencing it.
Date:   Sun,  2 May 2021 10:04:19 -0400
Message-Id: <20210502140434.2719553-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 597899d2f7c5619c87185ee7953d004bd37fd0eb ]

Don't dereference ctrl_ctx before checking it's valid.
Issue reported by Klockwork

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210406070208.3406266-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index b5080bc1689e..143e4002e561 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3227,6 +3227,14 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 
 	/* config ep command clears toggle if add and drop ep flags are set */
 	ctrl_ctx = xhci_get_input_control_ctx(cfg_cmd->in_ctx);
+	if (!ctrl_ctx) {
+		spin_unlock_irqrestore(&xhci->lock, flags);
+		xhci_free_command(xhci, cfg_cmd);
+		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
+				__func__);
+		goto cleanup;
+	}
+
 	xhci_setup_input_ctx_for_config_ep(xhci, cfg_cmd->in_ctx, vdev->out_ctx,
 					   ctrl_ctx, ep_flag, ep_flag);
 	xhci_endpoint_copy(xhci, cfg_cmd->in_ctx, vdev->out_ctx, ep_index);
-- 
2.30.2

