Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EC738A6B5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbhETK34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236818AbhETK21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:28:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FD1561C33;
        Thu, 20 May 2021 09:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504259;
        bh=2kfCO7LXG39FlNWL8826sbcj1qX6DzeJ2z1Uf48pomU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbLpQLUaNkHQwmmhiudNW8LnW7v8rxXGHIhPTHM1TVkjR1+pqgAjWfvnW8Da/6FQl
         Bnz0//TORhknHikmgB7UBN/pElyDjHqPEsquhZY00H2ICgnOlgdKvaSrm9rTFTSyhf
         p8bB7keP2OGpl50h1O2naIQfXjVOOUwCDNj7FmKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 163/323] staging: rtl8192u: Fix potential infinite loop
Date:   Thu, 20 May 2021 11:20:55 +0200
Message-Id: <20210520092125.691185703@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f9b9263a25dc3d2eaaa829e207434db6951ca7bc ]

The for-loop iterates with a u8 loop counter i and compares this
with the loop upper limit of riv->ieee80211->LinkDetectInfo.SlotNum
that is a u16 type. There is a potential infinite loop if SlotNum
is larger than the u8 loop counter. Fix this by making the loop
counter the same type as SlotNum.

Addresses-Coverity: ("Infinite loop")
Fixes: 8fc8598e61f6 ("Staging: Added Realtek rtl8192u driver to staging")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210407150308.496623-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/r8192U_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index b5941ae410d9..89ec4bb19e48 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3418,7 +3418,7 @@ static void rtl819x_update_rxcounts(struct r8192_priv *priv, u32 *TotalRxBcnNum,
 			     u32 *TotalRxDataNum)
 {
 	u16			SlotIndex;
-	u8			i;
+	u16			i;
 
 	*TotalRxBcnNum = 0;
 	*TotalRxDataNum = 0;
-- 
2.30.2



