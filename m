Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5D03783E7
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhEJKsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhEJKpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B93256199E;
        Mon, 10 May 2021 10:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642961;
        bh=whyFaAlnwnzms0kmPscrjuOUj5e4DfyjYwtoS7ROKJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgU7cPPycLFUCPdzQkiAfGtya33Rrdyws+OVnWJ5NEuhDrNNhaXqbWYT6Cu9Vc97i
         TSay5VNRVFY5gh8nQcLON5LeIoJoP67ZNBlM0U9BS/IuEcNynAphDpH522IhWrSYhY
         jwv0kiljNk8vJJQg72mcoJjVWh7ba65OZWpKG0u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/299] xhci: check control context is valid before dereferencing it.
Date:   Mon, 10 May 2021 12:18:03 +0200
Message-Id: <20210510102007.789233667@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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
index c449de6164b1..384076e169f4 100644
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



