Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28260395CED
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhEaNkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232277AbhEaNh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:37:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42B7E613C1;
        Mon, 31 May 2021 13:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467571;
        bh=kNsR7JH7HUPqnQDYu7+mJD6fvOY6gA/unXCy4XOe1RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQdh1sTLKIrMD0kOp1OAbD6m9g1zp2p2/AWRIjoT8AnipqrtzK1Yi+1F17jVcoDbI
         0vMh2JAhjH2PfdHt8ObkqW6k07ng8zZD0xgdycvz7CmU7c0X8Bu4JoSkrtaPBa7Od0
         jCSmVKA4YaHanxoQVtfoLCFirCXVcERX+g8kN/pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 4.19 116/116] usb: core: reduce power-on-good delay time of root hub
Date:   Mon, 31 May 2021 15:14:52 +0200
Message-Id: <20210531130644.055697545@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
@@ -146,8 +146,10 @@ static inline unsigned hub_power_on_good
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


