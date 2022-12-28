Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC51F65746C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 10:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiL1JGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 04:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiL1JGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 04:06:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA487B7E1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 01:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 763A2B80D17
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 09:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFF4C433EF;
        Wed, 28 Dec 2022 09:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672218401;
        bh=IYDsiismgEmOzBIc+wurXWRAobdSwRbb3hR55VYPmRs=;
        h=Subject:To:Cc:From:Date:From;
        b=FtZ+vgZW4iGKh7If6GgUV72Cf/eM8BOGc9Zccckw7bO1Zkr9RfKof/3H+6kXF2XO+
         d54Z9uEQ01KUepnYb/FNOvr+opwfx1DeyNkfjPvD2KeUCisqFQD4ahcpVJmKwdnlRj
         rH4veBw5wqZkFV1CFqgTYrhVKpJtgQ0eCmhmQPM0=
Subject: FAILED: patch "[PATCH] usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode" failed to apply to 4.19-stable tree
To:     sven@svenpeter.dev, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 10:06:28 +0100
Message-ID: <16722183882893@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

62c73bfea048 ("usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode")
07903626d988 ("usb: dwc3: core: Do not perform GCTL_CORE_SOFTRESET during bootup")
afbd04e66e5d ("usb: dwc3: core: Deprecate GCTL.CORESOFTRESET")
f88359e1588b ("usb: dwc3: core: Do core softreset when switch mode")
f580170f135a ("usb: dwc3: Add splitdisable quirk for Hisilicon Kirin Soc")
dc336b19e82d ("usb: dwc3: core: do not queue work if dr_mode is not USB_DR_MODE_OTG")
c2cd3452d5f8 ("usb: dwc3: support continuous runtime PM with dual role")
a0a465569b45 ("usb: dwc3: remove generic PHY calibrate() calls")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 62c73bfea048e66168df09da6d3e4510ecda40bb Mon Sep 17 00:00:00 2001
From: Sven Peter <sven@svenpeter.dev>
Date: Mon, 28 Nov 2022 17:15:26 +0100
Subject: [PATCH] usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode

dwc->desired_dr_role is changed by dwc3_set_mode inside a spinlock but
then read by __dwc3_set_mode outside of that lock. This can lead to a
race condition when very quick successive role switch events happen:

CPU A
	dwc3_set_mode(DWC3_GCTL_PRTCAP_HOST) // first role switch event
		spin_lock_irqsave(&dwc->lock, flags);
		dwc->desired_dr_role = mode; // DWC3_GCTL_PRTCAP_HOST
		spin_unlock_irqrestore(&dwc->lock, flags);
		queue_work(system_freezable_wq, &dwc->drd_work);

CPU B
	__dwc3_set_mode
		// ....
		spin_lock_irqsave(&dwc->lock, flags);
		// desired_dr_role is DWC3_GCTL_PRTCAP_HOST
		dwc3_set_prtcap(dwc, dwc->desired_dr_role);
		spin_unlock_irqrestore(&dwc->lock, flags);

CPU A
	dwc3_set_mode(DWC3_GCTL_PRTCAP_DEVICE) // second event
		spin_lock_irqsave(&dwc->lock, flags);
		dwc->desired_dr_role = mode; // DWC3_GCTL_PRTCAP_DEVICE
		spin_unlock_irqrestore(&dwc->lock, flags);

CPU B (continues running __dwc3_set_mode)
	switch (dwc->desired_dr_role) { // DWC3_GCTL_PRTCAP_DEVICE
	// ....
	case DWC3_GCTL_PRTCAP_DEVICE:
		// ....
		ret = dwc3_gadget_init(dwc);

We then have DWC3_GCTL.DWC3_GCTL_PRTCAPDIR = DWC3_GCTL_PRTCAP_HOST and
dwc->current_dr_role = DWC3_GCTL_PRTCAP_HOST but initialized the
controller in device mode. It's also possible to get into a state
where both host and device are intialized at the same time.
Fix this race by creating a local copy of desired_dr_role inside
__dwc3_set_mode while holding dwc->lock.

Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20221128161526.79730-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 1f348bc867c2..fc38a8b13efa 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -122,21 +122,25 @@ static void __dwc3_set_mode(struct work_struct *work)
 	unsigned long flags;
 	int ret;
 	u32 reg;
+	u32 desired_dr_role;
 
 	mutex_lock(&dwc->mutex);
+	spin_lock_irqsave(&dwc->lock, flags);
+	desired_dr_role = dwc->desired_dr_role;
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	pm_runtime_get_sync(dwc->dev);
 
 	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_OTG)
 		dwc3_otg_update(dwc, 0);
 
-	if (!dwc->desired_dr_role)
+	if (!desired_dr_role)
 		goto out;
 
-	if (dwc->desired_dr_role == dwc->current_dr_role)
+	if (desired_dr_role == dwc->current_dr_role)
 		goto out;
 
-	if (dwc->desired_dr_role == DWC3_GCTL_PRTCAP_OTG && dwc->edev)
+	if (desired_dr_role == DWC3_GCTL_PRTCAP_OTG && dwc->edev)
 		goto out;
 
 	switch (dwc->current_dr_role) {
@@ -164,7 +168,7 @@ static void __dwc3_set_mode(struct work_struct *work)
 	 */
 	if (dwc->current_dr_role && ((DWC3_IP_IS(DWC3) ||
 			DWC3_VER_IS_PRIOR(DWC31, 190A)) &&
-			dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG)) {
+			desired_dr_role != DWC3_GCTL_PRTCAP_OTG)) {
 		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 		reg |= DWC3_GCTL_CORESOFTRESET;
 		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
@@ -184,11 +188,11 @@ static void __dwc3_set_mode(struct work_struct *work)
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
-	dwc3_set_prtcap(dwc, dwc->desired_dr_role);
+	dwc3_set_prtcap(dwc, desired_dr_role);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-	switch (dwc->desired_dr_role) {
+	switch (desired_dr_role) {
 	case DWC3_GCTL_PRTCAP_HOST:
 		ret = dwc3_host_init(dwc);
 		if (ret) {

