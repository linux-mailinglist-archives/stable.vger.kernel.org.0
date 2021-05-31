Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82F7395C11
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhEaN1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhEaNZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:25:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37C6E613CD;
        Mon, 31 May 2021 13:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467262;
        bh=gX9fkF68UPNOyurxx7ugEYnJ8bb41xHeA4OZQgPhuJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWxxXNWxf/MQ2uSo5BoDk1G6ow6L3FD6ndXbDvx79QJSq+tXaCNwdFZPSp2gmMici
         IAfk8pJOm85xiacxsAOd8INhUISYWqTz3bu5/HWSO5qbR+USj/k2N3RRF7cR3LGt3l
         q2m6ApmFBAS0mHHB/BP3BzmjmM10DfKCnn1drKo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 4.9 66/66] usb: core: reduce power-on-good delay time of root hub
Date:   Mon, 31 May 2021 15:14:39 +0200
Message-Id: <20210531130638.339303847@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
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
@@ -151,8 +151,10 @@ static inline unsigned hub_power_on_good
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


