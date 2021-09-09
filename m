Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C838B404BD5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhIILx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242139AbhIILv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 530AF6127C;
        Thu,  9 Sep 2021 11:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187847;
        bh=4F/FtUHaVA8ntObtQdHZamsH2x118d5OxzvWksJvNb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsKhzW22YxAzO8zupYh3C5b/FrImsLCW+HDMrm4lDsnKP7j/Z4MfRg84Rkr3lfiSZ
         Nhjj8aQhswRp1VLu4Lfn+0ar0jwkTBTQNjcBDIbvZl0+JrP/28BxeAdVJVuV9j+AUh
         +rfYka/IzufZU3OK0wdYbCxzey+7wZHZnbAscaisP2foQI7yJ8QG2EjNAwgV3isWuD
         PEJRqEMWMDfDlrLssAULxSOBsReC7GaxVg/qlIWnldhdPp9JbBzs8793ONettuWV/P
         p2+t5C/jLhNWPm4rP78ZrMb4ltn9eQ9qksIEc4r/cKhehexz09SBRMC69/3OmxLZ/j
         ccnvgygpwobRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Aiuto <fabioaiuto83@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.14 139/252] staging: rtl8723bs: fix right side of condition
Date:   Thu,  9 Sep 2021 07:39:13 -0400
Message-Id: <20210909114106.141462-139-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit e3678dc1ea40425b7218c20e2fe7b00a72f23a41 ]

TxNum value is compared against ODM_RF_PATH_D,
which is inconsistent. Compare it against
RF_MAX_TX_NUM, as in other places in the same file.

Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/147631fe6f4f5de84cc54a62ba71d739b92697be.1628329348.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/hal/hal_com_phycfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
index bb7941aee0c4..fcf31f6d4b36 100644
--- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
+++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
@@ -463,7 +463,7 @@ static void PHY_StoreTxPowerByRateNew(
 	if (RfPath > ODM_RF_PATH_D)
 		return;
 
-	if (TxNum > ODM_RF_PATH_D)
+	if (TxNum > RF_MAX_TX_NUM)
 		return;
 
 	for (i = 0; i < rateNum; ++i) {
-- 
2.30.2

