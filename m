Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA75334CA81
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhC2Iip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234771AbhC2IhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98138619BC;
        Mon, 29 Mar 2021 08:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006997;
        bh=uYF5F0D2Fc1nmTn3DBFUzrcUK4K49xvVym1WKs43eZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bz9FklwWIgg4aih1xxMoxTJMXYJqEzj/j6a+/UQki3SQn86ibLfa+mgxGIj1zefuj
         4/1j+e3/TjZ/Alq0GY3XkGY1DfyVFmd4BgB3JMeu94TTpuV+c4cTDn8YlFlkZb/feN
         5ck9WSzQOP5xNSlydTb9ubi8GbyLLtFk4Q9DTRvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Davies <robdavies1977@gmail.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 182/254] r8152: limit the RX buffer size of RTL8153A for USB 2.0
Date:   Mon, 29 Mar 2021 09:58:18 +0200
Message-Id: <20210329075639.120186789@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index fd5ca11c4cbb..390d9e1fa7fe 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6502,7 +6502,10 @@ static int rtl_ops_init(struct r8152 *tp)
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



