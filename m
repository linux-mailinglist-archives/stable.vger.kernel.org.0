Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE574150DE8
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgBCQ0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729252AbgBCQ0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:26:49 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95EF82086A;
        Mon,  3 Feb 2020 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747208;
        bh=V/URwyR45V2UVqCc6dN8N9EyzaFjT5CgEyR/Gyu1eyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKRLO2EEq/pt5OBA4U7Bf2h313ByZa0ZXWoeUukXQOQHmX/1ia98P0+ffkhme3Org
         u1Dnqpb8AeZqBAvqsNltcvpuUGylLd0H0UnEsCGZqmgXYR6F1R6NGQ8zKURbFkkt01
         u2qBrdaj0uF/z9FuEnWLuRWNTtfcrkvqcXpQQOt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 57/68] r8152: get default setting of WOL before initializing
Date:   Mon,  3 Feb 2020 16:19:53 +0000
Message-Id: <20200203161914.352721176@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
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
index 3c037b76a0cc8..ba7cfc0895165 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4441,6 +4441,11 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	intf->needs_remote_wakeup = 1;
 
+	if (!rtl_can_wakeup(tp))
+		__rtl_set_wol(tp, 0);
+	else
+		tp->saved_wolopts = __rtl_get_wol(tp);
+
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
 	set_ethernet_addr(tp);
@@ -4454,10 +4459,6 @@ static int rtl8152_probe(struct usb_interface *intf,
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



