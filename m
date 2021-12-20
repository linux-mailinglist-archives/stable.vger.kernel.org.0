Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553AE47AF8C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbhLTPO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239682AbhLTPM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:12:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6A1C08EBB0;
        Mon, 20 Dec 2021 06:56:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A7ADB80EA3;
        Mon, 20 Dec 2021 14:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C76BC36AE7;
        Mon, 20 Dec 2021 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012215;
        bh=w1xIGX/Xy+QzyzD3lyYqHDydm6v+LvlETH0E9elbBHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWZB2uYHh7vZrNxcqKwvPvvgEjpbYpgy8Nfd4NJuO3CpWDSY6rLjm3vb4WpD4xQlU
         XadwWge6ua4TC4FyhfLUaTS+6iADv5vweiQWLxC/ClQjKbVRinna4p2WGuasJUJIvb
         hdZJKdEAycLPQBiV4k9NzqsK7t+q9zFjbV7pYwLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.15 121/177] usb: xhci-mtk: fix list_del warning when enable list debug
Date:   Mon, 20 Dec 2021 15:34:31 +0100
Message-Id: <20211220143044.148958063@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit ccc14c6cfd346e85c3ecb970975afd5132763437 upstream.

There is warning of 'list_del corruption' when enable list debug
(CONFIG_DEBUG_LIST=y), fix it by using list_del_init()

Fixes: 4ce186665e7c ("usb: xhci-mtk: Do not use xhci's virt_dev in drop_endpoint")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20211209025422.17108-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -781,7 +781,7 @@ int xhci_mtk_check_bandwidth(struct usb_
 
 	ret = xhci_check_bandwidth(hcd, udev);
 	if (!ret)
-		INIT_LIST_HEAD(&mtk->bw_ep_chk_list);
+		list_del_init(&mtk->bw_ep_chk_list);
 
 	return ret;
 }


