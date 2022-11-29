Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746C663BFD1
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 13:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiK2MOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 07:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiK2MON (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 07:14:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E554D65
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 04:14:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 492D1B81178
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 12:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD323C433D6;
        Tue, 29 Nov 2022 12:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669724050;
        bh=Qx3CZwndC3QROGvbIbb+tw4HLCOgPKdij8epA/u2AjI=;
        h=Subject:To:From:Date:From;
        b=Hsp/hdxrpHZAUoKyWdebSJdxum822F6AMvglev1X/aP53durxBM4Tr9XU6d1TZC+y
         Dgy31vwql5Z7I+LmLlR8R5rmeLIXF6sXL+rBhi9a1EPpozAZtRkeC4cnjEcF7vRDGt
         K2Q3lj/y50dCqc5U5H2TEuezB4eRJoUMlTqftEaM=
Subject: patch "usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq" added to usb-next
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 29 Nov 2022 13:13:50 +0100
Message-ID: <1669724030247125@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 03a88b0bafbe3f548729d970d8366f48718c9b19 Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Mon, 28 Nov 2022 14:33:37 +0800
Subject: usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq

Can not set the @shared_hcd to NULL before decrease the usage count
by usb_put_hcd(), this will cause the shared hcd not released.

Fixes: 04284eb74e0c ("usb: xhci-mtk: add support runtime PM")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20221128063337.18124-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index cff3c4aea036..f7cbb08fc506 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -646,7 +646,6 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 
 dealloc_usb3_hcd:
 	usb_remove_hcd(xhci->shared_hcd);
-	xhci->shared_hcd = NULL;
 
 put_usb3_hcd:
 	usb_put_hcd(xhci->shared_hcd);
-- 
2.38.1


