Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1474C7349
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbiB1ReZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238281AbiB1RdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:33:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E48F8F62E;
        Mon, 28 Feb 2022 09:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F08DE61357;
        Mon, 28 Feb 2022 17:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BCAC340E7;
        Mon, 28 Feb 2022 17:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069375;
        bh=jrevI2wUOcNqKkewXA85Iooudq2LITR6Is9Rtg9RFdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/8xEPia5XMaoQfzuJ1/+v59hMWg0jwOZzxQ1eFm7J05KyidhlcunhVFqKqZ4DZrk
         VSCs5NWjM4SBRM1NweMAIF6OAxQuHVVn8OfKY8zOUAtK0ranp7cthXZbk4AsYUvwOT
         nAiZEMeZA8Oqqreny4Ln2CWR/ZCo0gbxmWHfBqY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Puma Hsu <pumahsu@google.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 32/34] xhci: re-initialize the HC during resume if HCE was set
Date:   Mon, 28 Feb 2022 18:24:38 +0100
Message-Id: <20220228172211.092582378@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
References: <20220228172207.090703467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Puma Hsu <pumahsu@google.com>

commit 8b328f8002bcf29ef517ee4bf234e09aabec4d2e upstream.

When HCE(Host Controller Error) is set, it means an internal
error condition has been detected. Software needs to re-initialize
the HC, so add this check in xhci resume.

Cc: stable@vger.kernel.org
Signed-off-by: Puma Hsu <pumahsu@google.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220215123320.1253947-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1083,6 +1083,7 @@ int xhci_resume(struct xhci_hcd *xhci, b
 	int			retval = 0;
 	bool			comp_timer_running = false;
 	bool			pending_portevent = false;
+	bool			reinit_xhc = false;
 
 	if (!hcd->state)
 		return 0;
@@ -1099,10 +1100,11 @@ int xhci_resume(struct xhci_hcd *xhci, b
 	set_bit(HCD_FLAG_HW_ACCESSIBLE, &xhci->shared_hcd->flags);
 
 	spin_lock_irq(&xhci->lock);
-	if ((xhci->quirks & XHCI_RESET_ON_RESUME) || xhci->broken_suspend)
-		hibernated = true;
 
-	if (!hibernated) {
+	if (hibernated || xhci->quirks & XHCI_RESET_ON_RESUME || xhci->broken_suspend)
+		reinit_xhc = true;
+
+	if (!reinit_xhc) {
 		/*
 		 * Some controllers might lose power during suspend, so wait
 		 * for controller not ready bit to clear, just as in xHC init.
@@ -1135,12 +1137,17 @@ int xhci_resume(struct xhci_hcd *xhci, b
 			spin_unlock_irq(&xhci->lock);
 			return -ETIMEDOUT;
 		}
-		temp = readl(&xhci->op_regs->status);
 	}
 
-	/* If restore operation fails, re-initialize the HC during resume */
-	if ((temp & STS_SRE) || hibernated) {
+	temp = readl(&xhci->op_regs->status);
+
+	/* re-initialize the HC on Restore Error, or Host Controller Error */
+	if (temp & (STS_SRE | STS_HCE)) {
+		reinit_xhc = true;
+		xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
+	}
 
+	if (reinit_xhc) {
 		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
 				!(xhci_all_ports_seen_u0(xhci))) {
 			del_timer_sync(&xhci->comp_mode_recovery_timer);


