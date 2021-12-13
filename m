Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F25A472F0E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhLMOXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238700AbhLMOXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:23:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A96C061748
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 06:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12112610A4
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 14:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66E1C34601;
        Mon, 13 Dec 2021 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639405432;
        bh=kha737Dw3kMdAxNdJyF18A6qiH5ZS3/53TAgJvVASfs=;
        h=Subject:To:From:Date:From;
        b=yjmDYM4fIBj/fnaA9ju8DggaOEJ1bwyIQVVDKgt6sCDjyQDJZJ7Gvg0MscLTYT6kU
         IoyS0C8Yrqxe4CqR2XEp5k5xoIxisXCOCb0mCOKORo5/aIty6+mxIZmGcHwCq41jjl
         wcNz9h1s/JGmE2lLrWqgJxKd1HDLc/E1qPLOcRa4=
Subject: patch "usb: xhci-mtk: fix list_del warning when enable list debug" added to usb-linus
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 15:23:49 +0100
Message-ID: <16394054291341@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci-mtk: fix list_del warning when enable list debug

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ccc14c6cfd346e85c3ecb970975afd5132763437 Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Thu, 9 Dec 2021 10:54:22 +0800
Subject: usb: xhci-mtk: fix list_del warning when enable list debug

There is warning of 'list_del corruption' when enable list debug
(CONFIG_DEBUG_LIST=y), fix it by using list_del_init()

Fixes: 4ce186665e7c ("usb: xhci-mtk: Do not use xhci's virt_dev in drop_endpoint")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20211209025422.17108-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index 1edef7527c11..edbfa82c6565 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -781,7 +781,7 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 
 	ret = xhci_check_bandwidth(hcd, udev);
 	if (!ret)
-		INIT_LIST_HEAD(&mtk->bw_ep_chk_list);
+		list_del_init(&mtk->bw_ep_chk_list);
 
 	return ret;
 }
-- 
2.34.1


