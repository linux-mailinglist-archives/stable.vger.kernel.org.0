Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E62D34C797
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhC2IQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhC2IOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73E706044F;
        Mon, 29 Mar 2021 08:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005691;
        bh=CrpmpYp6iEDvJ3ElKc0pQLCS9txrJmAob1jp4rhsW0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dasrwGkPwn4jVFvANbjqKDUacWsZ1wqLpEUr8F6n7/K7sfLmTn3YVdfwzOjUxUDlh
         1TaY4gj5wte0DXIsc4AJbZCuNnRMmjyPfWi3A2Diz6/xdJdj8Uq/vfm6UtAIe3dzal
         h1kBtcxRTPKWeiytIfbOjvYWASiEb4I5HKUKmspA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Davies <robdavies1977@gmail.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/111] r8152: limit the RX buffer size of RTL8153A for USB 2.0
Date:   Mon, 29 Mar 2021 09:58:31 +0200
Message-Id: <20210329075617.978652956@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit f91a50d8b51b5c8ef1cfb08115a005bba4250507 ]

If the USB host controller is EHCI, the throughput is reduced from
300Mb/s to 60Mb/s, when the rx buffer size is modified from 16K to
32K.

According to the EHCI spec, the maximum size of the qTD is 20K.
Therefore, when the driver uses more than 20K buffer, the latency
time of EHCI would be increased. And, it let the RTL8153A get worse
throughput.

However, the driver uses alloc_pages() for rx buffer, so I limit
the rx buffer to 16K rather than 20K.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205923
Fixes: ec5791c202ac ("r8152: separate the rx buffer size")
Reported-by: Robert Davies <robdavies1977@gmail.com>
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 486cf511d2bf..f6d643ecaf39 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5529,7 +5529,10 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153_runtime_enable;
-		tp->rx_buf_sz		= 32 * 1024;
+		if (tp->udev->speed < USB_SPEED_SUPER)
+			tp->rx_buf_sz	= 16 * 1024;
+		else
+			tp->rx_buf_sz	= 32 * 1024;
 		tp->eee_en		= true;
 		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
 		break;
-- 
2.30.1



