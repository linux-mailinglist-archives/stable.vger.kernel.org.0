Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190F8582EFF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbiG0RUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241827AbiG0RTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763777A514;
        Wed, 27 Jul 2022 09:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48393B821AC;
        Wed, 27 Jul 2022 16:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976ABC433C1;
        Wed, 27 Jul 2022 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940240;
        bh=e7ZRv2aecf6ctDZd+OHUCvxL1ffQxSvAwxPQGF0uR9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOjdlK3HMhWoQlbvLvHWtMf+oW0JoE9xZSx3b8AFWx8yEcR2omLXyr7URaLHBq674
         OsWR863HSNmScvTw3fg6LIrm6XlciLaFiX40vJjhRr8xUVBj6eea9mDH3Y0T3JEVnh
         /KeVPHWZ88dC5NYb8d+0y0ycbgqxXPZZEYZai1iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/201] xhci: Set HCD flag to defer primary roothub registration
Date:   Wed, 27 Jul 2022 18:10:59 +0200
Message-Id: <20220727161034.246013417@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit b7a4f9b5d0e4b6dd937678c546c0b322dd1a4054 ]

Set "HCD_FLAG_DEFER_RH_REGISTER" to hcd->flags in xhci_run() to defer
registering primary roothub in usb_add_hcd() if xhci has two roothubs.
This will make sure both primary roothub and secondary roothub will be
registered along with the second HCD.
This is required for cold plugged USB devices to be detected in certain
PCIe USB cards (like Inateck USB card connected to AM64 EVM or J7200 EVM).

This patch has been added and reverted earier as it triggered a race
in usb device enumeration.
That race is now fixed in 5.16-rc3, and in stable back to 5.4
commit 6cca13de26ee ("usb: hub: Fix locking issues with address0_mutex")
commit 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0
race")

[minor rebase change, and commit message update -Mathias]

CC: stable@vger.kernel.org # 5.4+
Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20220510091630.16564-3-kishon@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a4e99f8668b3..d76c10f9ad80 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -693,6 +693,8 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
+
 	xhci_create_dbc_dev(xhci);
 
 	xhci_debugfs_init(xhci);
-- 
2.35.1



