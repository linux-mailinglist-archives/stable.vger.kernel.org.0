Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86693383660
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238822AbhEQPbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245410AbhEQP3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:29:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7463961CB9;
        Mon, 17 May 2021 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262251;
        bh=ox3u0FULZW0wD7jQkUcR29pizd25a1i7y6ZCeDn1omk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2fAK4L+MxYoRbVxFwqxP1EaNGEZuPYdWFwSuCekwQdKtuclF6uIE3dXGljU0SCOj
         mxhAudaaRS5B6vNE00eZafkkiatx0Q4yQjaPCb011yjN/i+E2ZSNi+7aJLYq72SJDS
         +IVSiu0mnA8qDwyMSohOQMDRXN5eixKGOxqnQ+zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/289] net: hns3: initialize the message content in hclge_get_link_mode()
Date:   Mon, 17 May 2021 16:01:11 +0200
Message-Id: <20210517140310.065152529@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 568a54bdf70b143f3e0befa298e22ad469ffc732 ]

The message sent to VF should be initialized, otherwise random
value of some contents may cause improper processing by the target.
So add a initialization to message in hclge_get_link_mode().

Fixes: 9194d18b0577 ("net: hns3: fix the problem that the supported port is empty")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 9c8004fc9dc4..e0254672831f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -519,7 +519,7 @@ static void hclge_get_link_mode(struct hclge_vport *vport,
 	unsigned long advertising;
 	unsigned long supported;
 	unsigned long send_data;
-	u8 msg_data[10];
+	u8 msg_data[10] = {};
 	u8 dest_vfid;
 
 	advertising = hdev->hw.mac.advertising[0];
-- 
2.30.2



