Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6825937CC82
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbhELQpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239308AbhELQhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:37:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FD1B61E28;
        Wed, 12 May 2021 16:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835329;
        bh=7LkAsLNAlS1dbgDJRDy5s7AMirJLGCClujm3q+LXeiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQk5ZK6mk3ihK/pIhuJcSG7j6pE+cTMru7QiLvzol/4gBMr3eHOnMko6onT6VDBRw
         zgeLQ6y0r9V7qAVPIf0QF8hWdxHQawqW2wJ8s56VZzi3iebj9iWMXYR2pZEDNBkjgF
         46pd66vtyNfhe8UrOi/7cu9E27lYkpSdSh4OMdlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 265/677] staging: rtl8192u: Fix potential infinite loop
Date:   Wed, 12 May 2021 16:45:11 +0200
Message-Id: <20210512144846.036274800@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 9fc4adc83d77..b5a313649f44 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3210,7 +3210,7 @@ static void rtl819x_update_rxcounts(struct r8192_priv *priv, u32 *TotalRxBcnNum,
 			     u32 *TotalRxDataNum)
 {
 	u16			SlotIndex;
-	u8			i;
+	u16			i;
 
 	*TotalRxBcnNum = 0;
 	*TotalRxDataNum = 0;
-- 
2.30.2



