Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61E74997D2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378286AbiAXVQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:16:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35602 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448372AbiAXVMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F56C6131F;
        Mon, 24 Jan 2022 21:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30496C340E5;
        Mon, 24 Jan 2022 21:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058750;
        bh=IjNxPGEtSYkVvnCwbHUvJvg0zijHBM+PZ9Fgl4BzepI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDgPvDMxi5maui4pDfdzJp3zWSTYQRPMXKfTIhEhp89li4R6Sf3T0whgFEGwV2iEk
         X6IQ/0Ng50oCOvCkyaJNBFFvXly0Rh40Hwwg9Lu9koYigRbehOHvK0tHHLMcS4mWVz
         q997VIK41FdjCIPpdfLUR72zQcRLeXMnMZgjcovc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0390/1039] usb: dwc2: do not gate off the hardware if it does not support clock gating
Date:   Mon, 24 Jan 2022 19:36:19 +0100
Message-Id: <20220124184138.426988331@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 34146c68083f1aef6709196b3dc888c1ceffd357 ]

We should not be clearing the HCD_FLAG_HW_ACCESSIBLE bit if the hardware
does not support clock gating.

Fixes: 50fb0c128b6e ("usb: dwc2: Add clock gating entering flow by system suspend")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20220104135922.734776-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 13c779a28e94f..f63a27d11fac8 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4399,11 +4399,12 @@ static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
 		 * If not hibernation nor partial power down are supported,
 		 * clock gating is used to save power.
 		 */
-		if (!hsotg->params.no_clock_gating)
+		if (!hsotg->params.no_clock_gating) {
 			dwc2_host_enter_clock_gating(hsotg);
 
-		/* After entering suspend, hardware is not accessible */
-		clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+			/* After entering suspend, hardware is not accessible */
+			clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+		}
 		break;
 	default:
 		goto skip_power_saving;
-- 
2.34.1



