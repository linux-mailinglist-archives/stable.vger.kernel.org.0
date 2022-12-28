Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC448657F33
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbiL1QDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbiL1QCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:02:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46C3192A9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC142B817F6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FEBC433EF;
        Wed, 28 Dec 2022 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243329;
        bh=Ga+jYqrPUaptjY8lEl3ZmIurSZV9s84ThLBf7KaNI08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnwKtDRneLuqFv5JE5QEDhmKjIziSPcKMPFL/R3Q2Aht5B0twidPu8MwQFKgi8ty3
         1ojhowbEzxTds7+nADH0DrEFnJtB6ngLvNG0hUBiurTsd6KzDhIaE5e+7UVphxN0at
         w1eVvXOsBrLKqKtbVPHdMHEoDCkvKAVCG3lnBnx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: [PATCH 5.15 709/731] usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode
Date:   Wed, 28 Dec 2022 15:43:36 +0100
Message-Id: <20221228144317.003740012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Peter <sven@svenpeter.dev>

commit 62c73bfea048e66168df09da6d3e4510ecda40bb upstream.

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
---
 drivers/usb/dwc3/core.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -120,21 +120,25 @@ static void __dwc3_set_mode(struct work_
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
@@ -162,7 +166,7 @@ static void __dwc3_set_mode(struct work_
 	 */
 	if (dwc->current_dr_role && ((DWC3_IP_IS(DWC3) ||
 			DWC3_VER_IS_PRIOR(DWC31, 190A)) &&
-			dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG)) {
+			desired_dr_role != DWC3_GCTL_PRTCAP_OTG)) {
 		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 		reg |= DWC3_GCTL_CORESOFTRESET;
 		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
@@ -182,11 +186,11 @@ static void __dwc3_set_mode(struct work_
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
-	dwc3_set_prtcap(dwc, dwc->desired_dr_role);
+	dwc3_set_prtcap(dwc, desired_dr_role);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-	switch (dwc->desired_dr_role) {
+	switch (desired_dr_role) {
 	case DWC3_GCTL_PRTCAP_HOST:
 		ret = dwc3_host_init(dwc);
 		if (ret) {


