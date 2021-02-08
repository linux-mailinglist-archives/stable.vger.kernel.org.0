Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A31A3137FC
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhBHPen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhBHPSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2225164EE3;
        Mon,  8 Feb 2021 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797158;
        bh=RzePf7hV+LpCF+q3I5E782D4lSKVs5lWAKS6C+yPs2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jx3Qp0KkFfyPnoShf1AmarHN69Uha4X6OCtvhHcnDE2FgCz+DCB8MymOs9BN4TRfZ
         WccL4yyElBTYA6xxkzsszwQWfTFZinzojOiPCGL32+Ez+gqJhPRzk5XwWZ60fkdjWO
         uMeErnmkOi1juu0PsCrlVT+hbYT4qNe7PE+IEbKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ikjoon Jang <ikjn@chromium.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.10 013/120] usb: xhci-mtk: break loop when find the endpoint to drop
Date:   Mon,  8 Feb 2021 16:00:00 +0100
Message-Id: <20210208145818.923818030@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit a50ea34d6dd00a12c9cd29cf7b0fa72816bffbcb upstream.

No need to check the following endpoints after finding the endpoint
wanted to drop.

Fixes: 54f6a8af3722 ("usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints")
Cc: stable <stable@vger.kernel.org>
Reported-by: Ikjoon Jang <ikjn@chromium.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1612255104-5363-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -689,8 +689,10 @@ void xhci_mtk_drop_ep_quirk(struct usb_h
 	sch_bw = &sch_array[bw_index];
 
 	list_for_each_entry_safe(sch_ep, tmp, &sch_bw->bw_ep_list, endpoint) {
-		if (sch_ep->ep == ep)
+		if (sch_ep->ep == ep) {
 			destroy_sch_ep(udev, sch_bw, sch_ep);
+			break;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_mtk_drop_ep_quirk);


