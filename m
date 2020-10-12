Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F9828B7ED
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgJLNrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389878AbgJLNqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8163B20838;
        Mon, 12 Oct 2020 13:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510383;
        bh=LALDaeGrz2gF+G/AAZvbCxIIC/B/T4SyRdSYDE8vgdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YY2ugYM9z/qyqcA2tqYvnb3/QeEHV6lntTPngrMb+A52HHIJtwIwrw7Jb70eJOOw7
         zUV+XSG7KCjtRMg9JwNs+YWVX+Fp1X3KF2m5p5DukXB8JCPnlELP6g8AaGEPckdfmY
         umKjv2UFwpkp3tLUj8HiEwGN7WrCMDUQJ7447F3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 075/124] r8169: fix RTL8168f/RTL8411 EPHY config
Date:   Mon, 12 Oct 2020 15:31:19 +0200
Message-Id: <20201012133150.488302310@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
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
index a5d54fa012213..fe173ea894e2c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2958,7 +2958,7 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 		{ 0x08, 0x0001,	0x0002 },
 		{ 0x09, 0x0000,	0x0080 },
 		{ 0x19, 0x0000,	0x0224 },
-		{ 0x00, 0x0000,	0x0004 },
+		{ 0x00, 0x0000,	0x0008 },
 		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
@@ -2975,7 +2975,7 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 		{ 0x06, 0x00c0,	0x0020 },
 		{ 0x0f, 0xffff,	0x5200 },
 		{ 0x19, 0x0000,	0x0224 },
-		{ 0x00, 0x0000,	0x0004 },
+		{ 0x00, 0x0000,	0x0008 },
 		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
-- 
2.25.1



