Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7250122F071
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732283AbgG0OYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730144AbgG0OYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:24:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A672083E;
        Mon, 27 Jul 2020 14:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859878;
        bh=WIIPYcX+La5dUgPvwyLCdvuORcDgdMxo2o+Zea3h6QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDwVuNgOpfMZj54Zzm4moOueVfpJNq4HIZe9dxUGYmFYDB0WRiL/i0D7vkgjX5Uy0
         Jg3Q0B06Fc2XSm/+kl8m2vsm9GGTwDvJeiTn3GgC9ou4QORSjW4ffYyMwn0+5+lkiK
         urdV4eM0LUWANDoPAMgK6xmAa/aANhJL34ZYpngc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.7 140/179] usb: xhci-mtk: fix the failure of bandwidth allocation
Date:   Mon, 27 Jul 2020 16:05:15 +0200
Message-Id: <20200727134939.456486086@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 5ce1a24dd98c00a57a8fa13660648abf7e08e3ef upstream.

The wMaxPacketSize field of endpoint descriptor may be zero
as default value in alternate interface, and they are not
actually selected when start stream, so skip them when try to
allocate bandwidth.

Cc: stable <stable@vger.kernel.org>
Fixes: 0cbd4b34cda9 ("xhci: mediatek: support MTK xHCI host controller")
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1594360672-2076-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mtk-sch.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -557,6 +557,10 @@ static bool need_bw_sch(struct usb_host_
 	if (is_fs_or_ls(speed) && !has_tt)
 		return false;
 
+	/* skip endpoint with zero maxpkt */
+	if (usb_endpoint_maxp(&ep->desc) == 0)
+		return false;
+
 	return true;
 }
 


