Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3E213F5D0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388977AbgAPS7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388966AbgAPRGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4523F2192A;
        Thu, 16 Jan 2020 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194401;
        bh=NkGpowe9FnmmpR6ORNdzBt56niZjn5inrN0I8s/L6Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DY8XlMhkTXzhWCjgwA/8kJU4mHJ2xcGz12/XjzxhPom8palkKMmSVPs5XWZAUlxGT
         1Pt5EqXApsawyCSE6P39+L0b6xba4Gs9+VLgL+pF9vROW8DBYReLc7EMi/J3lx/MiO
         WeAWxYvvMZhqwhXj9LkStbSfxRtfUqEfM9Xp732c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minas Harutyunyan <minas.harutyunyan@synopsys.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 326/671] dwc2: gadget: Fix completed transfer size calculation in DDMA
Date:   Thu, 16 Jan 2020 11:59:24 -0500
Message-Id: <20200116170509.12787-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <minas.harutyunyan@synopsys.com>

[ Upstream commit 5acb4b970184d189d901192d075997c933b82260 ]

Fix calculation of transfer size on completion in function
dwc2_gadget_get_xfersize_ddma().

Added increment of descriptor pointer to move to next descriptor in
the loop.

Fixes: aa3e8bc81311 ("usb: dwc2: gadget: DDMA transfer start and complete")

Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 3f68edde0f03..f64d1cd08fb6 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2230,6 +2230,7 @@ static unsigned int dwc2_gadget_get_xfersize_ddma(struct dwc2_hsotg_ep *hs_ep)
 		if (status & DEV_DMA_STS_MASK)
 			dev_err(hsotg->dev, "descriptor %d closed with %x\n",
 				i, status & DEV_DMA_STS_MASK);
+		desc++;
 	}
 
 	return bytes_rem;
-- 
2.20.1

