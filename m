Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339493960CD
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhEaObi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhEaO3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED0C61C29;
        Mon, 31 May 2021 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468914;
        bh=WEChJ6jb79usMwhfXxnCXY+Floj+im3Lq2Q0hut9XTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvKr9cJI9Ic8HiVaAd8GVHqTGLJqJavm9iG5BXftCiom+yrvpNm+mpoNHd+dCq5AX
         xZXuQ9kouT59/JFQ4T1KMUhgK23WmIR7F2o4Oh6W3GU2Y9E9e4nbziwUzGeWe0NRSu
         ujFjUwitBmA4i3JENEpZX8rT6hcwDlL+fyto5ZcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.4 177/177] usb: core: reduce power-on-good delay time of root hub
Date:   Mon, 31 May 2021 15:15:34 +0200
Message-Id: <20210531130654.044538261@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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


