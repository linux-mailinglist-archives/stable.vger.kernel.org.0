Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D949E38AAC5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbhETLRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238612AbhETLPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B069261D5C;
        Thu, 20 May 2021 10:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505340;
        bh=t4XaliKOt2XlK6EB741wYuZCHq9e08TmshK17TBViBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbsVewaJXucxYE20vs5zwnkW03rdjrKKWP7Q6NlGgmXdub684MVgEahJXKVZZQ0S8
         Xd+sSIX07jqQC7OlxVwm19zkrutnjYRQ9gJ/NRKxGglEcK9+R17z4WeoiE+7q+y+2L
         1xJL7xQ3cNpVWO++ohp7Tlo6eufWuCxVs8voFaXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 091/190] staging: rtl8192u: Fix potential infinite loop
Date:   Thu, 20 May 2021 11:22:35 +0200
Message-Id: <20210520092105.216799095@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 1e0d2a33787e..72dabbf19bc7 100644
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



