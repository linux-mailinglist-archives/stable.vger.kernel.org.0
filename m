Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D545EA06D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbiIZKh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiIZKfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:35:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6D252810;
        Mon, 26 Sep 2022 03:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90954B80915;
        Mon, 26 Sep 2022 10:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E23C433C1;
        Mon, 26 Sep 2022 10:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187699;
        bh=vurixT+IAkm87enXMQlTqreARwuSLXbBG6K3jdg9MvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhY1KGbUHujO75XmDf4TFZlO959xaFXPj3HWSUWHjeg/4RYrByMnak5BUrfF43N3o
         1XMwuTEWniPDxLk++v1d6WJWtT4UUmOMfsFK4Xpjb4q4Ra3EPzYaPT7o1BUhLiGI6D
         x0agu5cduZgvkuu/6ORA9X4/oH8UGFvuTN6ocv5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/120] usb: dwc3: Issue core soft reset before enabling run/stop
Date:   Mon, 26 Sep 2022 12:11:03 +0200
Message-Id: <20220926100751.752939929@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 0066472de157439d58454f4a55786f1045ea5681 ]

It is recommended by the Synopsis databook to issue a DCTL.CSftReset
when reconnecting from a device-initiated disconnect routine.  This
resolves issues with enumeration during fast composition switching
cases, which result in an unknown device on the host.

Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220316011358.3057-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 040f2dbd2010 ("usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c   |  2 +-
 drivers/usb/dwc3/core.h   |  2 ++
 drivers/usb/dwc3/gadget.c | 11 +++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f4655665a1b5..a9c49b2ce511 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -227,7 +227,7 @@ u32 dwc3_core_fifo_space(struct dwc3_ep *dep, u8 type)
  * dwc3_core_soft_reset - Issues core soft reset and PHY reset
  * @dwc: pointer to our context structure
  */
-static int dwc3_core_soft_reset(struct dwc3 *dwc)
+int dwc3_core_soft_reset(struct dwc3 *dwc)
 {
 	u32		reg;
 	int		retries = 1000;
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index a93c61bc5a7d..f320b989abd2 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1422,6 +1422,8 @@ bool dwc3_has_imod(struct dwc3 *dwc);
 int dwc3_event_buffers_setup(struct dwc3 *dwc);
 void dwc3_event_buffers_cleanup(struct dwc3 *dwc);
 
+int dwc3_core_soft_reset(struct dwc3 *dwc);
+
 #if IS_ENABLED(CONFIG_USB_DWC3_HOST) || IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)
 int dwc3_host_init(struct dwc3 *dwc);
 void dwc3_host_exit(struct dwc3 *dwc);
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 079919b85d87..b95fc2ae8074 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2088,6 +2088,17 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 						dwc->ev_buf->length;
 		}
 	} else {
+		/*
+		 * In the Synopsys DWC_usb31 1.90a programming guide section
+		 * 4.1.9, it specifies that for a reconnect after a
+		 * device-initiated disconnect requires a core soft reset
+		 * (DCTL.CSftRst) before enabling the run/stop bit.
+		 */
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		dwc3_core_soft_reset(dwc);
+		spin_lock_irqsave(&dwc->lock, flags);
+
+		dwc3_event_buffers_setup(dwc);
 		__dwc3_gadget_start(dwc);
 	}
 
-- 
2.35.1



