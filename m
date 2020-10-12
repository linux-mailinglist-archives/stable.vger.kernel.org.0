Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4987328B796
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389570AbgJLNo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbgJLNms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:42:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA1D221FF;
        Mon, 12 Oct 2020 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510152;
        bh=A+PWDisWF5gQ0qJTPnIYzVQrO/rRm/DfBYCRJEu2Fg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pUWgQEV5K7APf+w/igZF/EaI3koyOfSZiM0jQn597uIP8qfvaQwvrm9KFq/+6+tl
         0/NLeTlkQH0KhvqugouwZHfQ4QINESPjK2qzYPwCcWlSckJTKNrsO/q/xEc9IWPIuu
         7h8a28MN25o18fHygb2swctbJ3b9Oig1vtPNRV0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 62/85] r8169: fix RTL8168f/RTL8411 EPHY config
Date:   Mon, 12 Oct 2020 15:27:25 +0200
Message-Id: <20201012132635.833619719@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 709a16be0593c08190982cfbdca6df95e6d5823b ]

Mistakenly bit 2 was set instead of bit 3 as in the vendor driver.

Fixes: a7a92cf81589 ("r8169: sync PCIe PHY init with vendor driver 8.047.01")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 903212ad9bb2f..66c97049f52b7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4701,7 +4701,7 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 		{ 0x08, 0x0001,	0x0002 },
 		{ 0x09, 0x0000,	0x0080 },
 		{ 0x19, 0x0000,	0x0224 },
-		{ 0x00, 0x0000,	0x0004 },
+		{ 0x00, 0x0000,	0x0008 },
 		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
@@ -4718,7 +4718,7 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 		{ 0x06, 0x00c0,	0x0020 },
 		{ 0x0f, 0xffff,	0x5200 },
 		{ 0x19, 0x0000,	0x0224 },
-		{ 0x00, 0x0000,	0x0004 },
+		{ 0x00, 0x0000,	0x0008 },
 		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
-- 
2.25.1



