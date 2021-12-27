Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE78480056
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhL0Ppq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbhL0Pnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:43:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592F7C07E5EF;
        Mon, 27 Dec 2021 07:41:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EABD4610B1;
        Mon, 27 Dec 2021 15:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF080C36AE7;
        Mon, 27 Dec 2021 15:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619699;
        bh=Rg7wJ3w0Bd+1f9ig/36zUZ27+cH7+Z8/jCqhK+cOZXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmCRbS+9vg1lrVeNLzo/MAQIcS/JJjB3/mVPMQnE5XJ8jZh2/HJELThr6TpcE0c50
         Y4A1sl5X85Ywb4MRNpE8uNOk+ht7dxEYyPZ0ZsHsupjXkx7LMQyb5+nPJ2H3YWygAa
         owyY+QYV6U9kgndMnkmb0M9IZWqvopho3EDLwNFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/128] drivers: net: smc911x: Check for error irq
Date:   Mon, 27 Dec 2021 16:30:13 +0100
Message-Id: <20211227151332.799348177@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit cb93b3e11d405f20a405a07482d01147ef4934a3 ]

Because platform_get_irq() could fail and return error irq.
Therefore, it might be better to check it if order to avoid the use of
error irq.

Fixes: ae150435b59e ("smsc: Move the SMC (SMSC) drivers")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smc911x.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index b008b4e8a2a5a..0641a1d392b86 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -2070,6 +2070,11 @@ static int smc911x_drv_probe(struct platform_device *pdev)
 
 	ndev->dma = (unsigned char)-1;
 	ndev->irq = platform_get_irq(pdev, 0);
+	if (ndev->irq < 0) {
+		ret = ndev->irq;
+		goto release_both;
+	}
+
 	lp = netdev_priv(ndev);
 	lp->netdev = ndev;
 #ifdef SMC_DYNAMIC_BUS_CONFIG
-- 
2.34.1



