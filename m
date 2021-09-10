Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DDD406B71
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhIJMcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233129AbhIJMcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C396E611C9;
        Fri, 10 Sep 2021 12:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277055;
        bh=24WADtF1nlCF5+DsbBKx77QjJcAUjTpmnx8sRSvWoek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkxCXHDgZT42rbjgpA7KNCJ1g+rDP4ZU6CgRtdfAGoQhNzD392LV+Epk34y2jWd86
         DIIIGbf5MvraZc0gOAW1901yHvwKw/oG6EMYWAuSR5Ni1M5qCWKq9ZWE9LpjTMbY8w
         DgumFN7+1vpZ+puKd3eyc9BljcPC/1WSHJt1THks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.14 10/23] usb: cdnsp: fix the wrong mult value for HS isoc or intr
Date:   Fri, 10 Sep 2021 14:30:00 +0200
Message-Id: <20210910122916.341946473@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit e9ab75f26eb9354dfc03aea3401b8cfb42cd6718 upstream.

usb_endpoint_maxp() only returns the bit[10:0] of wMaxPacketSize
of endpoint descriptor, not include bit[12:11] anymore, so use
usb_endpoint_maxp_mult() instead.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable@vger.kernel.org
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1628836253-7432-4-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-mem.c
+++ b/drivers/usb/cdns3/cdnsp-mem.c
@@ -882,7 +882,7 @@ static u32 cdnsp_get_endpoint_max_burst(
 	if (g->speed == USB_SPEED_HIGH &&
 	    (usb_endpoint_xfer_isoc(pep->endpoint.desc) ||
 	     usb_endpoint_xfer_int(pep->endpoint.desc)))
-		return (usb_endpoint_maxp(pep->endpoint.desc) & 0x1800) >> 11;
+		return usb_endpoint_maxp_mult(pep->endpoint.desc) - 1;
 
 	return 0;
 }


