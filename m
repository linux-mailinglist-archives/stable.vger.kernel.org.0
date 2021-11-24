Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175D245BA03
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbhKXMG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241048AbhKXMGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:06:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F0B61050;
        Wed, 24 Nov 2021 12:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755388;
        bh=mMAxgwm8tJgR6S6mgYeF1h7XYG2gqEXAi+5jCppwvzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+EPOdntOq8uzzH39RotTmIwRzoniP/qv77E13162vgXQvmAoTQ4KC868J1RwfVdp
         QIJK758aC+X/FcoqSZw5CHYNjCIPR9+DLBVnfxBIoXhSrIOxZe2pd7GFZqRKka/+4H
         fJAS0ozBVBRKaG3f+zaFuPwY40YRxQDw3757j96Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 077/162] b43: fix a lower bounds test
Date:   Wed, 24 Nov 2021 12:56:20 +0100
Message-Id: <20211124115700.804953767@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9b793db5fca44d01f72d3564a168171acf7c4076 ]

The problem is that "channel" is an unsigned int, when it's less 5 the
value of "channel - 5" is not a negative number as one would expect but
is very high positive value instead.

This means that "start" becomes a very high positive value.  The result
of that is that we never enter the "for (i = start; i <= end; i++) {"
loop.  Instead of storing the result from b43legacy_radio_aci_detect()
it just uses zero.

Fixes: ef1a628d83fc ("b43: Implement dynamic PHY API")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Michael Büsch <m@bues.ch>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211006073621.GE8404@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/b43/phy_g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 462310e6e88fb..a706605cef9a8 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -2295,7 +2295,7 @@ static u8 b43_gphy_aci_scan(struct b43_wldev *dev)
 	b43_phy_mask(dev, B43_PHY_G_CRS, 0x7FFF);
 	b43_set_all_gains(dev, 3, 8, 1);
 
-	start = (channel - 5 > 0) ? channel - 5 : 1;
+	start = (channel > 5) ? channel - 5 : 1;
 	end = (channel + 5 < 14) ? channel + 5 : 13;
 
 	for (i = start; i <= end; i++) {
-- 
2.33.0



