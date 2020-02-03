Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCF3150DA0
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbgBCQpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgBCQaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:23 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE6DC20838;
        Mon,  3 Feb 2020 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747423;
        bh=uZnpqr58FAIQr5basJhVzbytWtXZYs6Nk1b4vihknk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIX67rs54LNIFDQPhY1gnmgpsWYycJ+vs2U19Bqyn2kdzq+7n7eF6g13axOl8OrPr
         199goSdsDomqBseKii+NmAq3qdOa01e7FkE/SMyP+x7bzRjF1DBvqlcjYQsUVe9OMW
         U6q06pD3sBRiRYF8P/kWqHUEsX6w5dVBltweKnO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 78/89] r8152: get default setting of WOL before initializing
Date:   Mon,  3 Feb 2020 16:20:03 +0000
Message-Id: <20200203161926.425684713@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 9583a3638dc07cc1878f41265e85ed497f72efcb ]

Initailization would reset runtime suspend by tp->saved_wolopts, so
the tp->saved_wolopts should be set before initializing.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0083c60f5cdff..a7f9c1886bd4c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5244,6 +5244,11 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	intf->needs_remote_wakeup = 1;
 
+	if (!rtl_can_wakeup(tp))
+		__rtl_set_wol(tp, 0);
+	else
+		tp->saved_wolopts = __rtl_get_wol(tp);
+
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
 	set_ethernet_addr(tp);
@@ -5257,10 +5262,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 		goto out1;
 	}
 
-	if (!rtl_can_wakeup(tp))
-		__rtl_set_wol(tp, 0);
-
-	tp->saved_wolopts = __rtl_get_wol(tp);
 	if (tp->saved_wolopts)
 		device_set_wakeup_enable(&udev->dev, true);
 	else
-- 
2.20.1



