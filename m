Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB77863B0EC
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 19:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiK1SRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 13:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiK1SQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 13:16:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCA22A245
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 10:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F651CE0F14
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 18:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A49C433D6;
        Mon, 28 Nov 2022 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669658424;
        bh=75IN4mxBTXvYTffrwGuQgNUzthVRubmSo4XF8jzkHX0=;
        h=Subject:To:From:Date:From;
        b=jQp2jyOjQTvQHx8aHB/naNozLeMI7uTDpPEx0xhaffrfGQvzYpl2NLpFGZWrlyTxQ
         xLwKfyt/0bIBBZVQR7fp2OTQSCeZsWnKs881gYaa1pQSIJ+zPiBOSzxU5e8aA6/Ppn
         VxNukzKH4iZ4916z6MoMgDFSNK1e28+q6asFAHnk=
Subject: patch "usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq" added to usb-testing
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Nov 2022 18:59:59 +0100
Message-ID: <166965839919365@kroah.com>
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
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 0113f5d4e0620fbb86ed66dc1adbbeab5a2d1560 Mon Sep 17 00:00:00 2001
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


