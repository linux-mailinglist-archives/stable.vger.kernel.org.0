Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4727BFA580
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfKMCXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728401AbfKMBwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29332222CA;
        Wed, 13 Nov 2019 01:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609966;
        bh=m9VhWDbXbHgBh8aFo56pVeSLUAJfO+QY+O/6sQJbDBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFwxk2tLPmTc11n2IYUg7yF+lbXJUdgZkyizgVrVHHAr9zwOIairi+mVXswqjq063
         Xf6G5YniF1eGxae2hg0jznzu7fPp9sNhiYHQuCuxDkhDfYNQZ9T7HMjzpReBVR/tWD
         aQdPhGHjNMwnSVNUt2KXO3+36WwdulLaDrKVrwP0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     SolidHal <hal@halemmerich.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 097/209] usb: dwc2: disable power_down on rockchip devices
Date:   Tue, 12 Nov 2019 20:48:33 -0500
Message-Id: <20191113015025.9685-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SolidHal <hal@halemmerich.com>

[ Upstream commit c216765d3a1defda5e7e2dabd878f99f0cd2ebf2 ]

 The bug would let the usb controller enter partial power down,
 which was formally known as hibernate, upon boot if nothing was plugged
 in to the port. Partial power down couldn't be exited properly, so any
 usb devices plugged in after boot would not be usable.

 Before the name change, params.hibernation was false by default, so
 _dwc2_hcd_suspend() would skip entering hibernation. With the
 rename, _dwc2_hcd_suspend() was changed to use  params.power_down
 to decide whether or not to enter partial power down.

 Since params.power_down is non-zero by default, it needs to be set
 to 0 for rockchip devices to restore functionality.

 This bug was reported in the linux-usb thread:
 REGRESSION: usb: dwc2: USB device not seen after boot

 The commit that caused this regression is:
6d23ee9caa6790aea047f9aca7f3c03cb8d96eb6

Signed-off-by: SolidHal <hal@halemmerich.com>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/params.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc2/params.c b/drivers/usb/dwc2/params.c
index dff2c6e8d797c..a93415f33bf36 100644
--- a/drivers/usb/dwc2/params.c
+++ b/drivers/usb/dwc2/params.c
@@ -88,6 +88,7 @@ static void dwc2_set_rk_params(struct dwc2_hsotg *hsotg)
 	p->host_perio_tx_fifo_size = 256;
 	p->ahbcfg = GAHBCFG_HBSTLEN_INCR16 <<
 		GAHBCFG_HBSTLEN_SHIFT;
+	p->power_down = 0;
 }
 
 static void dwc2_set_ltq_params(struct dwc2_hsotg *hsotg)
-- 
2.20.1

