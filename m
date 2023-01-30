Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CAF6812EF
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237715AbjA3O0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbjA3O01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:26:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4407240BD6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:25:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 091536108C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9E3C433D2;
        Mon, 30 Jan 2023 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088680;
        bh=k3bSMYbHXAqJNfRWYV7iFWl3pG7fMlZCmQT5LLZ3joc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thayr+ZlZjUgBgErJOOteV5S2aiasP1uIJ0dWB0qijZ3mkA1TKn5T1w+8Zyaw/ipf
         rmiVIg7e/deAtBzg7gzlsyRrMc0v/bH/rxYLalOwLnF5PTFYomhywunWsgsJ3SGcPG
         pzxYJBDrnIPuLGe5pIUaYc7Yzqzo4ygzQbuRdy5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Adrian Zaharia <Adrian.Zaharia@windriver.com>
Subject: [PATCH 5.10 100/143] xhci: Set HCD flag to defer primary roothub registration
Date:   Mon, 30 Jan 2023 14:52:37 +0100
Message-Id: <20230130134310.977989068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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

From: Kishon Vijay Abraham I <kishon@ti.com>

commit b7a4f9b5d0e4b6dd937678c546c0b322dd1a4054 upstream.

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
Signed-off-by: Adrian Zaharia <Adrian.Zaharia@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -696,6 +696,8 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
+
 	xhci_dbc_init(xhci);
 
 	xhci_debugfs_init(xhci);


