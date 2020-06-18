Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970961FDEE0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbgFRBga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732700AbgFRBbF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:31:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF7121941;
        Thu, 18 Jun 2020 01:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443864;
        bh=IJoStkf2FQtkyKrZXkzARkzrGmNX62cBYKhIiI+8/kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyCPfWDDRBrgO+5MeJfUKgjivgEOwdv1MUzIzcaAtR8BxDh0Dj5zizfGUGXdn0ZqN
         sfwk2r/kPHLR0187zACGGKjpDeKEWfc17LNX4AcH91phwchN2d9Z+0EfB7cVDVgNXS
         G48C6h7a5iXicnj3/f5GTXNxSFjNGMTAeE/4bjcs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrice Gasnier <fabrice.gasnier@st.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 46/60] usb: dwc2: gadget: move gadget resume after the core is in L0 state
Date:   Wed, 17 Jun 2020 21:29:50 -0400
Message-Id: <20200618013004.610532-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618013004.610532-1-sashal@kernel.org>
References: <20200618013004.610532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 8c935deacebb8fac8f41378701eb79d12f3c2e2d ]

When the remote wakeup interrupt is triggered, lx_state is resumed from L2
to L0 state. But when the gadget resume is called, lx_state is still L2.
This prevents the resume callback to queue any request. Any attempt
to queue a request from resume callback will result in:
- "submit request only in active state" debug message to be issued
- dwc2_hsotg_ep_queue() returns -EAGAIN

Call the gadget resume routine after the core is in L0 state.

Fixes: f81f46e1f530 ("usb: dwc2: implement hibernation during bus suspend/resume")

Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/core_intr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index 27daa42788b1..796d60d49ac5 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -363,10 +363,13 @@ static void dwc2_handle_wakeup_detected_intr(struct dwc2_hsotg *hsotg)
 			if (ret && (ret != -ENOTSUPP))
 				dev_err(hsotg->dev, "exit hibernation failed\n");
 
+			/* Change to L0 state */
+			hsotg->lx_state = DWC2_L0;
 			call_gadget(hsotg, resume);
+		} else {
+			/* Change to L0 state */
+			hsotg->lx_state = DWC2_L0;
 		}
-		/* Change to L0 state */
-		hsotg->lx_state = DWC2_L0;
 	} else {
 		if (hsotg->core_params->hibernation) {
 			dwc2_writel(GINTSTS_WKUPINT, hsotg->regs + GINTSTS);
-- 
2.25.1

