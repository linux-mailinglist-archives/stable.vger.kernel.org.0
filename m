Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464B53CA6D2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbhGOSuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238902AbhGOSsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:48:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7FA613D0;
        Thu, 15 Jul 2021 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374756;
        bh=9upz0cKdc/qYU4JjyOzTGWrs6l3cCYP97s9qfpHPtkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIdQzNPC5pLite2TEQvzyTPf8iKnMYBp71BuGIgLtt/RjVyOzS7bat685iaJOrg4S
         zgjPow5QikNczcuZJ3gXb/Cwj+wy7FK9916W4hMRK6Xq/ugM7aIJO/EZHYVUBfWjZA
         I2walqfvG6beHGMnHWj0di5y1bp1avrnxfef6L5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/215] mISDN: fix possible use-after-free in HFC_cleanup()
Date:   Thu, 15 Jul 2021 20:36:25 +0200
Message-Id: <20210715182601.001549719@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 009fc857c5f6fda81f2f7dd851b2d54193a8e733 ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 56bd2e9db6ed..e501cb03f211 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2342,7 +2342,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.30.2



