Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D755499398
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385939AbiAXUet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53096 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351194AbiAXU2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:28:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1651161512;
        Mon, 24 Jan 2022 20:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDB8C340E7;
        Mon, 24 Jan 2022 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056093;
        bh=kQOPCzJ23KjmzmDDzdiGqkriF7MkqANtBTl5JNAMDM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eL/8Y5Fphm4D+QQgGjjAjCtr+vILIZ0MBAFJOvG/3nawGgx0UHMXf08EC8y9tb/Yz
         NjIamYr4dFCkQ8ooJWwGKvj26IwOW+eTaxFJPu6u0wVCcOh5MeTiqghVUYyr/AyICy
         GYnlU2Crbwrau1YflyLvlU1otZDv8Xtrsaf8hvQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 325/846] usb: dwc2: do not gate off the hardware if it does not support clock gating
Date:   Mon, 24 Jan 2022 19:37:22 +0100
Message-Id: <20220124184112.112781068@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index a215ec9e172e6..657dbd50faf11 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4403,11 +4403,12 @@ static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
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



