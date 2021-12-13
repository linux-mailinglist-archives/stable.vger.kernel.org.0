Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB514726BD
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhLMJyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbhLMJvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:51:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E00C08E857;
        Mon, 13 Dec 2021 01:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5092ACE0E29;
        Mon, 13 Dec 2021 09:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE75FC00446;
        Mon, 13 Dec 2021 09:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388670;
        bh=hiA75hrDbvhs9K9HBmABCcwv89YXozl550sSAsakBsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOHelFuKgWqay78kr0xALrPfgat5BBm4jLuHvptjDOWiDRk79UwNEMQWgLcoS7Pdi
         nX15Kj27/yk3uftkYD9hXv8bsLHb1XeWCKlmgOgcuhXMu+AHTW+ljpuidb2/ywrpzW
         6RZ+r1tCA82iPpfcs3c26AnVp0sJVX3GNSOpC0a4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 24/88] iavf: restore MSI state on reset
Date:   Mon, 13 Dec 2021 10:29:54 +0100
Message-Id: <20211213092934.055192410@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

commit 7e4dcc13965c57869684d57a1dc6dd7be589488c upstream.

If the PF experiences an FLR, the VF's MSI and MSI-X configuration will
be conveniently and silently removed in the process. When this happens,
reset recovery will appear to complete normally but no traffic will
pass. The netdev watchdog will helpfully notify everyone of this issue.

To prevent such public embarrassment, restore MSI configuration at every
reset. For normal resets, this will do no harm, but for VF resets
resulting from a PF FLR, this will keep the VF working.

Fixes: 5eae00c57f5e ("i40evf: main driver core")
Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2151,6 +2151,7 @@ static void iavf_reset_task(struct work_
 	}
 
 	pci_set_master(adapter->pdev);
+	pci_restore_msi_state(adapter->pdev);
 
 	if (i == IAVF_RESET_WAIT_COUNT) {
 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",


