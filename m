Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F601FE6DD
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgFRCg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbgFRBNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 660CF21974;
        Thu, 18 Jun 2020 01:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442829;
        bh=Ks1RrpJw1/aYJi7gT9X2bELgsCWGYuhIaPzvUzs48Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKYZaQjzX/pS5pgLOhG0ThtpZDnJYmAaTcmtDB1bMF1xCWBQZSl+ZDmY4Exe6HxGm
         pM4F6cobB7RCJ7PtCBPWzhQ9VaKKtoKWavMwBdFUo7J9O/60+kb1ZRwtRnxGcQwY7Y
         cZLjnBQVnxMUlI5Kc60ToJdUy0/COmmbIf/SiP2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrice Gasnier <fabrice.gasnier@st.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 264/388] usb: dwc2: gadget: move gadget resume after the core is in L0 state
Date:   Wed, 17 Jun 2020 21:06:01 -0400
Message-Id: <20200618010805.600873-264-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
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
index 876ff31261d5..55f1d14fc414 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -416,10 +416,13 @@ static void dwc2_handle_wakeup_detected_intr(struct dwc2_hsotg *hsotg)
 			if (ret && (ret != -ENOTSUPP))
 				dev_err(hsotg->dev, "exit power_down failed\n");
 
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
 		if (hsotg->params.power_down)
 			return;
-- 
2.25.1

