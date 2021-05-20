Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AE238A272
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhETJlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233075AbhETJjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:39:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 521F1613C1;
        Thu, 20 May 2021 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503086;
        bh=N3FxKqWZrTgdcyVZefZWFKOqV2K59cqXtACh8OPqPuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eV88D1r9t8ZNHTNubCG5wrdFpVtJa2dUNCOh407i1DjHTMpZAaaXFENs3lmd6DElv
         cVu/BRPSWVMNvjaf3uNrTsCnhcvOLDwaGFefFE/0tk3XM3DfiCJvRIKt2QBhEtQOBm
         WkNKENKrVhkvkqzdvIPGzdq8zJDiLtRg2GRNVYjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/425] xhci: check control context is valid before dereferencing it.
Date:   Thu, 20 May 2021 11:16:44 +0200
Message-Id: <20210520092132.569443616@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6c508d0313f7..fc07d68fdd15 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3148,6 +3148,14 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 
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



