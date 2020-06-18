Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6131FE799
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgFRCmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbgFRBMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF521214DB;
        Thu, 18 Jun 2020 01:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442727;
        bh=lmsOjpJfu1F/07xtNKZqZw1bsoKKOBllErHB92ejtMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZ6MzIOaugBA/g2Wf9m1vzM4ijJcm03pDC4uK7O2uWisbMydpPHo3Q/mJ+MDZC1D6
         YJxu32lDkhGdgICn/zxdfDylij2Y02UQBmr4687lt5TyBu8Vmw02EH+4XvxWY5OMx/
         nu8y/Liz7m9tt/gGBJuiHvXt0ZTSTvZFRCi9gsEI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Hulk Robot <hulkci@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 184/388] remoteproc/mediatek: fix invalid use of sizeof in scp_ipi_init()
Date:   Wed, 17 Jun 2020 21:04:41 -0400
Message-Id: <20200618010805.600873-184-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 8096f80a5c09b716be207eb042c4e40d6cdefbd2 ]

sizeof() when applied to a pointer typed expression gives the
size of the pointer, not that of the pointed data.

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: 63c13d61eafe ("remoteproc/mediatek: add SCP support for mt8183")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20200509084237.36293-1-weiyongjun1@huawei.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index 2bead57c9cf9..ac13e7b046a6 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -132,8 +132,8 @@ static int scp_ipi_init(struct mtk_scp *scp)
 		(struct mtk_share_obj __iomem *)(scp->sram_base + recv_offset);
 	scp->send_buf =
 		(struct mtk_share_obj __iomem *)(scp->sram_base + send_offset);
-	memset_io(scp->recv_buf, 0, sizeof(scp->recv_buf));
-	memset_io(scp->send_buf, 0, sizeof(scp->send_buf));
+	memset_io(scp->recv_buf, 0, sizeof(*scp->recv_buf));
+	memset_io(scp->send_buf, 0, sizeof(*scp->send_buf));
 
 	return 0;
 }
-- 
2.25.1

