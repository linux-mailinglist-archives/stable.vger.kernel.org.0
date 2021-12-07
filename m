Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0103846B487
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 08:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhLGHyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 02:54:05 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:40820 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231486AbhLGHyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 02:54:05 -0500
X-UUID: 2be38e4284fd4345875d49023e9974bc-20211207
X-UUID: 2be38e4284fd4345875d49023e9974bc-20211207
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 973175977; Tue, 07 Dec 2021 15:50:32 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Tue, 7 Dec 2021 15:50:30 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkcas11.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 7 Dec 2021 15:50:27 +0800
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Wenbin Mei <wenbin.mei@mediatek.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, <stable@vger.kernel.org>
Subject: [RESEND PATCH v1] mmc: mediatek: free the ext_csd when mmc_get_ext_csd success
Date:   Tue, 7 Dec 2021 15:50:13 +0800
Message-ID: <20211207075013.22911-1-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If mmc_get_ext_csd success, the ext_csd are not freed.
Add the missing kfree() calls.

Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Fixes: c4ac38c6539b ("mmc: mtk-sd: Add HS400 online tuning support")
Cc: stable@vger.kernel.org
---
 drivers/mmc/host/mtk-sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 943940b44e83..632775217d35 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2291,8 +2291,10 @@ static int msdc_execute_hs400_tuning(struct mmc_host *mmc, struct mmc_card *card
 			sdr_set_field(host->base + PAD_DS_TUNE,
 				      PAD_DS_TUNE_DLY1, i);
 		ret = mmc_get_ext_csd(card, &ext_csd);
-		if (!ret)
+		if (!ret) {
 			result_dly1 |= (1 << i);
+			kfree(ext_csd);
+		}
 	}
 	host->hs400_tuning = false;
 
-- 
2.25.1

