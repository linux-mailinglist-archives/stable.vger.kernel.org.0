Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72588395FA0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhEaON3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232190AbhEaOL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C81F96124C;
        Mon, 31 May 2021 13:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468465;
        bh=WEChJ6jb79usMwhfXxnCXY+Floj+im3Lq2Q0hut9XTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15pqmpNHYLB/a+Y0WfnJrim4Jat6Sbpn+g2Sb6937/ybX8M/4miYKM/6qf+C9TPQT
         yhnMYS2srO8vPEV7R2j/gFuMLxs2291uXGdqyGT3GVGh3S3f97ia6e2ahDPXeA+p2l
         LCopgxmgrXZJq98qUYRdr3/rqr+cbbGKGeQBlQdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.10 252/252] usb: core: reduce power-on-good delay time of root hub
Date:   Mon, 31 May 2021 15:15:17 +0200
Message-Id: <20210531130706.545241726@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 90d28fb53d4a51299ff324dede015d5cb11b88a2 upstream.

Return the exactly delay time given by root hub descriptor,
this helps to reduce resume time etc.

Due to the root hub descriptor is usually provided by the host
controller driver, if there is compatibility for a root hub,
we can fix it easily without affect other root hub

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1618017645-12259-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -148,8 +148,10 @@ static inline unsigned hub_power_on_good
 {
 	unsigned delay = hub->descriptor->bPwrOn2PwrGood * 2;
 
-	/* Wait at least 100 msec for power to become stable */
-	return max(delay, 100U);
+	if (!hub->hdev->parent)	/* root hub */
+		return delay;
+	else /* Wait at least 100 msec for power to become stable */
+		return max(delay, 100U);
 }
 
 static inline int hub_port_debounce_be_connected(struct usb_hub *hub,


