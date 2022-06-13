Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AA254895B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350325AbiFMLGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351890AbiFMLFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:05:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D447128C;
        Mon, 13 Jun 2022 03:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 739D860FFD;
        Mon, 13 Jun 2022 10:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836D8C3411C;
        Mon, 13 Jun 2022 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116480;
        bh=iPDGLaiCpDKpB218XQ4ilOz8blVhaF7quo/ECIy5Zx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYUj+rYKNdGG3ikclxStljMkdMGeM9+OBliN2Wk442zZ4xbSMqAVyzWzEM/RnL73+
         bQLILN+f3zTYuI7Vt0kWFt+mQWHTl12LC0ZI2J6H/T3MVNBi6hkqm/U+rpWOvweMI9
         7x+xhzXUSAW9vI6ujHFkeCL1eYVyMeLVCKa9qmho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Evan Green <evgreen@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 189/218] USB: hcd-pci: Fully suspend across freeze/thaw cycle
Date:   Mon, 13 Jun 2022 12:10:47 +0200
Message-Id: <20220613094926.349731531@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5340d433cdf0..18b3a5e518cd 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -632,10 +632,10 @@ const struct dev_pm_ops usb_hcd_pci_pm_ops = {
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



