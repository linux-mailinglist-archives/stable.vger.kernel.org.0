Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC9C27C846
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbgI2Lkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730556AbgI2Lkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B08A21941;
        Tue, 29 Sep 2020 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379620;
        bh=/+pliRggyOjEy8m8uK+MrMptQUHltTkK+F/HawNYwaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Psq5Z5mSlxRA/otudHeJtIQ9nRUU/dInMw5LkMKyYQSalaUzh5C3jmnrw58JU11o1
         AtPD1essE61UlkunFHXzi9fHogecg13fe/vuPAjwLWoXUzVgZp7BS2dJdSReWJxIxi
         zue42qSRR59i7eZBDmEJJDX5iXHLM/+69AmngwT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 244/388] dpaa2-eth: fix error return code in setup_dpni()
Date:   Tue, 29 Sep 2020 12:59:35 +0200
Message-Id: <20200929110022.292450723@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 97fff7c8de1e54e5326dfeb66085796864bceb64 ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 7a248cc1055a3..7af7cc7c8669a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2654,8 +2654,10 @@ static int setup_dpni(struct fsl_mc_device *ls_dev)
 
 	priv->cls_rules = devm_kzalloc(dev, sizeof(struct dpaa2_eth_cls_rule) *
 				       dpaa2_eth_fs_count(priv), GFP_KERNEL);
-	if (!priv->cls_rules)
+	if (!priv->cls_rules) {
+		err = -ENOMEM;
 		goto close;
+	}
 
 	return 0;
 
-- 
2.25.1



