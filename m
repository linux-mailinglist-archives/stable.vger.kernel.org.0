Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28473833DB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbhEQPCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241412AbhEQPBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8290161482;
        Mon, 17 May 2021 14:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261623;
        bh=Vkdazf81eNPntKsn1XK0QZ1xNKS8Daz7i776niXDBOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nSygSrsMOOXgSvPwGVtnKAIxq6KbgMnKrAk3GsvkdJt6RBtYZeTTGX+25W86Lgd/
         hiOPlSg5EiRW9et1G/OQQESTEu5d1X4up8X2Fl4fF6ng7cXb+yo7RQafIRpQW2Y/i1
         jI8Idge1EONl+Dv3UgzRJ4UYwdt4Y4odZsz7iNe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/141] net: hns3: initialize the message content in hclge_get_link_mode()
Date:   Mon, 17 May 2021 16:01:59 +0200
Message-Id: <20210517140245.032258768@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
index f5da28a60d00..23a706a1765a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -455,7 +455,7 @@ static void hclge_get_link_mode(struct hclge_vport *vport,
 	unsigned long advertising;
 	unsigned long supported;
 	unsigned long send_data;
-	u8 msg_data[10];
+	u8 msg_data[10] = {};
 	u8 dest_vfid;
 
 	advertising = hdev->hw.mac.advertising[0];
-- 
2.30.2



