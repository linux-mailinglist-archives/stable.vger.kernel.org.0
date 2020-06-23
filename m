Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7340B205D10
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388021AbgFWUIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387960AbgFWUIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DA902064B;
        Tue, 23 Jun 2020 20:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942903;
        bh=3aoChUl2UDZ0+bckNEqzvaEEiD5ZmCZpEvLq7LeN2lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iH3rxNdiNiQtn32j8r57yU8vpaFggpj++EL8J82XG/Y0sPAsXKA6MSH8F9umqTvUS
         6mX2k9s4Pd4+uWgbECE1CC8tmDDRUAwQ8GfEPa6cx9iFn8jMZ0BOVtQ3LvIMcDGf79
         DgDJZAXeGXD/qi0EJG3RwFtryom49AeM8hOXcfL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 181/477] remoteproc/mediatek: fix invalid use of sizeof in scp_ipi_init()
Date:   Tue, 23 Jun 2020 21:52:58 +0200
Message-Id: <20200623195416.141650809@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2bead57c9cf9b..ac13e7b046a60 100644
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



