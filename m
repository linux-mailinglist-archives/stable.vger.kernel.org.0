Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A422F37CC8C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243806AbhELQpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243318AbhELQhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D0BE61E2E;
        Wed, 12 May 2021 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835351;
        bh=cjSIBgXnGPl+m0Usvm4nsW9hGyWmcBsvGR5V/xHOjkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z24z9kTOsv+j1DMM8YdPmR8ryrFarbqfYeS+txkf0QGyAHATzPFpFfc7/v8KzTF84
         L1QQQx7A6oLN0pZDG3iA+LlYz9JhoKl4nrfvVvXKqJfLSPNq1szWV7xvJr5sfCvRto
         SVWlpaYFQclNjp9z/YsQqNGs0NeRap+OHZpjJMbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 310/677] usb: cdnsp: Fixes issue with Configure Endpoint command
Date:   Wed, 12 May 2021 16:45:56 +0200
Message-Id: <20210512144847.511437660@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit 10076de33b5ed5b1e049593a611d2fd9eba60565 ]

Patch adds flag EP_UNCONFIGURED to detect whether endpoint was
unconfigured. This flag is set in cdnsp_reset_device after Reset Device
command. Among others this command disables all non control endpoints.
Flag is used in cdnsp_gadget_ep_disable to protect controller against
invoking Configure Endpoint command on disabled endpoint. Lack of this
protection in some cases caused that Configure Endpoint command completed
with Context State Error code completion.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c | 17 ++++++++++++-----
 drivers/usb/cdns3/cdnsp-gadget.h |  1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index d7d4bdd57f46..56707b6b0f57 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -727,7 +727,7 @@ int cdnsp_reset_device(struct cdnsp_device *pdev)
 	 * are in Disabled state.
 	 */
 	for (i = 1; i < CDNSP_ENDPOINTS_NUM; ++i)
-		pdev->eps[i].ep_state |= EP_STOPPED;
+		pdev->eps[i].ep_state |= EP_STOPPED | EP_UNCONFIGURED;
 
 	trace_cdnsp_handle_cmd_reset_dev(slot_ctx);
 
@@ -942,6 +942,7 @@ static int cdnsp_gadget_ep_enable(struct usb_ep *ep,
 
 	pep = to_cdnsp_ep(ep);
 	pdev = pep->pdev;
+	pep->ep_state &= ~EP_UNCONFIGURED;
 
 	if (dev_WARN_ONCE(pdev->dev, pep->ep_state & EP_ENABLED,
 			  "%s is already enabled\n", pep->name))
@@ -1023,9 +1024,13 @@ static int cdnsp_gadget_ep_disable(struct usb_ep *ep)
 		goto finish;
 	}
 
-	cdnsp_cmd_stop_ep(pdev, pep);
 	pep->ep_state |= EP_DIS_IN_RROGRESS;
-	cdnsp_cmd_flush_ep(pdev, pep);
+
+	/* Endpoint was unconfigured by Reset Device command. */
+	if (!(pep->ep_state & EP_UNCONFIGURED)) {
+		cdnsp_cmd_stop_ep(pdev, pep);
+		cdnsp_cmd_flush_ep(pdev, pep);
+	}
 
 	/* Remove all queued USB requests. */
 	while (!list_empty(&pep->pending_list)) {
@@ -1043,10 +1048,12 @@ static int cdnsp_gadget_ep_disable(struct usb_ep *ep)
 
 	cdnsp_endpoint_zero(pdev, pep);
 
-	ret = cdnsp_update_eps_configuration(pdev, pep);
+	if (!(pep->ep_state & EP_UNCONFIGURED))
+		ret = cdnsp_update_eps_configuration(pdev, pep);
+
 	cdnsp_free_endpoint_rings(pdev, pep);
 
-	pep->ep_state &= ~EP_ENABLED;
+	pep->ep_state &= ~(EP_ENABLED | EP_UNCONFIGURED);
 	pep->ep_state |= EP_STOPPED;
 
 finish:
diff --git a/drivers/usb/cdns3/cdnsp-gadget.h b/drivers/usb/cdns3/cdnsp-gadget.h
index 6bbb26548c04..783ca8ffde00 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -835,6 +835,7 @@ struct cdnsp_ep {
 #define EP_WEDGE		BIT(4)
 #define EP0_HALTED_STATUS	BIT(5)
 #define EP_HAS_STREAMS		BIT(6)
+#define EP_UNCONFIGURED		BIT(7)
 
 	bool skip;
 };
-- 
2.30.2



