Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10D545BD8E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbhKXMjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344452AbhKXMgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:36:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052E2611EF;
        Wed, 24 Nov 2021 12:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756521;
        bh=o0XZXqnDb704faZ2mOpJknNPWdcexFvAZupVEmogmr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6vWufCBWtguYxsB5sh57Y5LQSPU8rkQFE8TCzPRajoFKkCnaSwnRDPEYQy8Vvx0Y
         oIw+lcODqK9Oz1/K5pBEGY/+1flXkfz0matqKamjfUajKTf+Uj47+QDqzgVy2YE9HU
         3yU51TPGUzWfR+Exsu5XSLS5NnvBzDfJaNuXA5Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 116/251] b43legacy: fix a lower bounds test
Date:   Wed, 24 Nov 2021 12:55:58 +0100
Message-Id: <20211124115714.255802117@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c1c8380b0320ab757e60ed90efc8b1992a943256 ]

The problem is that "channel" is an unsigned int, when it's less 5 the
value of "channel - 5" is not a negative number as one would expect but
is very high positive value instead.

This means that "start" becomes a very high positive value.  The result
of that is that we never enter the "for (i = start; i <= end; i++) {"
loop.  Instead of storing the result from b43legacy_radio_aci_detect()
it just uses zero.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Michael Büsch <m@bues.ch>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211006073542.GD8404@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/radio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/radio.c b/drivers/net/wireless/broadcom/b43legacy/radio.c
index 9501420340a91..5b1e8890305c1 100644
--- a/drivers/net/wireless/broadcom/b43legacy/radio.c
+++ b/drivers/net/wireless/broadcom/b43legacy/radio.c
@@ -299,7 +299,7 @@ u8 b43legacy_radio_aci_scan(struct b43legacy_wldev *dev)
 			    & 0x7FFF);
 	b43legacy_set_all_gains(dev, 3, 8, 1);
 
-	start = (channel - 5 > 0) ? channel - 5 : 1;
+	start = (channel > 5) ? channel - 5 : 1;
 	end = (channel + 5 < 14) ? channel + 5 : 13;
 
 	for (i = start; i <= end; i++) {
-- 
2.33.0



