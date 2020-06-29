Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D023B20E6F9
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391472AbgF2VwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3814424653;
        Mon, 29 Jun 2020 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443967;
        bh=R7EbNfwBfhbKAwJL9cGsCE0UyhurDjirYYrMzZFv7YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrHu0aNqrupclbky3ZB66u1e+ZZp81S/AQRnF9fNc5h6et0vM+ZxaIzqawM4GMNor
         TNw3G0aspFqMhNA7JPSkOxuE7xkh44Cmc6a8tYlclRGnEamB5gGucxAoTNCkqKUv+R
         aLkN1wmA8zSdLq0VeZBbSeuGR2VybyO52y3Eqxp4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Prashant Malani <pmalani@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 071/265] usb: typec: mux: intel_pmc_mux: Fix DP alternate mode entry
Date:   Mon, 29 Jun 2020 11:15:04 -0400
Message-Id: <20200629151818.2493727-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 130206a88683d859f63ed6d4a56ab5c2b4930c8e upstream.

The PMC needs to be notified separately about HPD (hotplug
detected) signal being high after mode entry. There is a bit
"HPD High" in the Alternate Mode Request that the driver
already sets, but that bit is only valid when the
DisplayPort Alternate Mode is directly entered from
disconnected state.

Fixes: 5c4edcdbcd97 ("usb: typec: mux: intel: Fix DP_HPD_LVL bit field")
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Tested-by: Prashant Malani <pmalani@chromium.org>
Link: https://lore.kernel.org/r/20200529131753.15587-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index c22e5c4bbf1a9..e35508f5e1287 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -129,7 +129,8 @@ pmc_usb_mux_dp_hpd(struct pmc_usb_port *port, struct typec_mux_state *state)
 	msg[0] = PMC_USB_DP_HPD;
 	msg[0] |= port->usb3_port << PMC_USB_MSG_USB3_PORT_SHIFT;
 
-	msg[1] = PMC_USB_DP_HPD_IRQ;
+	if (data->status & DP_STATUS_IRQ_HPD)
+		msg[1] = PMC_USB_DP_HPD_IRQ;
 
 	if (data->status & DP_STATUS_HPD_STATE)
 		msg[1] |= PMC_USB_DP_HPD_LVL;
@@ -142,6 +143,7 @@ pmc_usb_mux_dp(struct pmc_usb_port *port, struct typec_mux_state *state)
 {
 	struct typec_displayport_data *data = state->data;
 	struct altmode_req req = { };
+	int ret;
 
 	if (data->status & DP_STATUS_IRQ_HPD)
 		return pmc_usb_mux_dp_hpd(port, state);
@@ -161,7 +163,14 @@ pmc_usb_mux_dp(struct pmc_usb_port *port, struct typec_mux_state *state)
 	if (data->status & DP_STATUS_HPD_STATE)
 		req.mode_data |= PMC_USB_ALTMODE_HPD_HIGH;
 
-	return pmc_usb_command(port, (void *)&req, sizeof(req));
+	ret = pmc_usb_command(port, (void *)&req, sizeof(req));
+	if (ret)
+		return ret;
+
+	if (data->status & DP_STATUS_HPD_STATE)
+		return pmc_usb_mux_dp_hpd(port, state);
+
+	return 0;
 }
 
 static int
-- 
2.25.1

