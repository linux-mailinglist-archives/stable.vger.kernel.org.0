Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA7540DD2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354118AbiFGSuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354329AbiFGSqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAE7127183;
        Tue,  7 Jun 2022 11:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57392B82182;
        Tue,  7 Jun 2022 18:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19E8C385A5;
        Tue,  7 Jun 2022 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624846;
        bh=ELu3yy7yIcm3DofcKPU4yWrv9X+QqBqmt/yCt5gDrQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOe4RevE766tR1beOzNvlLjBpODTnumXNs1sF75LH5OwBCB/DREuBQwIDIMLVWabM
         JzzSOCVBIh6r/oRkKYIaWO3/3OUrlI8HRRfM9dLofdkmGhqYTL4J+oWyZXWfQcyzQZ
         DY6fiyYZT7WWa9kNvo7xtXVP4PzsGTLB3ItzNtK4JhKlr5swOgPK6zI4ovNYeiraeb
         Pxemh1MU0QCNbSYSBxDzHOXcj5DvLXJPj7nZXbSOtva6DHbG7+Hu0YAlbKc+0/vvy9
         tUkHpbavmi/uNj6LvpQ/p17AD9+yvMwdWnCUIIyXM9HwS50t3FkA5pplXuLfP1l1di
         sqLyf3uRcT8GA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Green <evgreen@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, bhelgaas@google.com,
        rafael.j.wysocki@intel.com, yj84.jang@samsung.com,
        christophe.leroy@csgroup.eu, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/34] USB: hcd-pci: Fully suspend across freeze/thaw cycle
Date:   Tue,  7 Jun 2022 13:59:46 -0400
Message-Id: <20220607180011.481266-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180011.481266-1-sashal@kernel.org>
References: <20220607180011.481266-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

[ Upstream commit 63acaa8e9c65dc34dc249440216f8e977f5d2748 ]

The documentation for the freeze() method says that it "should quiesce
the device so that it doesn't generate IRQs or DMA". The unspoken
consequence of not doing this is that MSIs aimed at non-boot CPUs may
get fully lost if they're sent during the period where the target CPU is
offline.

The current callbacks for USB HCD do not fully quiesce interrupts,
specifically on XHCI. Change to use the full suspend/resume flow for
freeze/thaw to ensure interrupts are fully quiesced. This fixes issues
where USB devices fail to thaw during hibernation because XHCI misses
its interrupt and cannot recover.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Evan Green <evgreen@chromium.org>
Link: https://lore.kernel.org/r/20220421103751.v3.2.I8226c7fdae88329ef70957b96a39b346c69a914e@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hcd-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 9e26b0143a59..db16efe293e0 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -604,10 +604,10 @@ const struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.suspend_noirq	= hcd_pci_suspend_noirq,
 	.resume_noirq	= hcd_pci_resume_noirq,
 	.resume		= hcd_pci_resume,
-	.freeze		= check_root_hub_suspended,
+	.freeze		= hcd_pci_suspend,
 	.freeze_noirq	= check_root_hub_suspended,
 	.thaw_noirq	= NULL,
-	.thaw		= NULL,
+	.thaw		= hcd_pci_resume,
 	.poweroff	= hcd_pci_suspend,
 	.poweroff_noirq	= hcd_pci_suspend_noirq,
 	.restore_noirq	= hcd_pci_resume_noirq,
-- 
2.35.1

