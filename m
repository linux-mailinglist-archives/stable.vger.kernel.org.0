Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D225AECD5
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiIFOAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240939AbiIFN7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA5680F7C;
        Tue,  6 Sep 2022 06:42:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF989B818CB;
        Tue,  6 Sep 2022 13:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226A7C433C1;
        Tue,  6 Sep 2022 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471747;
        bh=fN7cZVjC+OW/cpWJCRT+Rzh//C1Y7CHWisjr2KHqC4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgzJ1Xv4drpGhDkq4s55/TdbcJfVqlIYQrVHD3Ob+YUsl22JvkLWAoBYO46rg/itz
         z9bfAY2sIV8o2sbqfPpZwRPHrapsN/KvD2yj5gejtvbpOoU8YemaepPZd/w8lqgQBY
         tcMtsSGO/tz9myidYFU09N8hA8odgIPLVsTLS2Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Sheplyakov <asheplyakov@basealt.ru>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 024/155] xhci: Fix null pointer dereference in remove if xHC has only one roothub
Date:   Tue,  6 Sep 2022 15:29:32 +0200
Message-Id: <20220906132830.449841834@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 4a593a62a9e3a25ab4bc37f612e4edec144f7f43 ]

The remove path in xhci platform driver tries to remove and put both main
and shared hcds even if only a main hcd exists (one roothub)

This causes a null pointer dereference in reboot for those controllers.

Check that the shared_hcd exists before trying to remove it.

Fixes: e0fe986972f5 ("usb: host: xhci-plat: prepare operation w/o shared hcd")
Reported-by: Alexey Sheplyakov <asheplyakov@basealt.ru>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220825150840.132216-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 044855818cb11..a8641b6536eea 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -398,12 +398,17 @@ static int xhci_plat_remove(struct platform_device *dev)
 	pm_runtime_get_sync(&dev->dev);
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
-	usb_remove_hcd(shared_hcd);
-	xhci->shared_hcd = NULL;
+	if (shared_hcd) {
+		usb_remove_hcd(shared_hcd);
+		xhci->shared_hcd = NULL;
+	}
+
 	usb_phy_shutdown(hcd->usb_phy);
 
 	usb_remove_hcd(hcd);
-	usb_put_hcd(shared_hcd);
+
+	if (shared_hcd)
+		usb_put_hcd(shared_hcd);
 
 	clk_disable_unprepare(clk);
 	clk_disable_unprepare(reg_clk);
-- 
2.35.1



