Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDDF420FD2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbhJDNix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237668AbhJDNgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C7261053;
        Mon,  4 Oct 2021 13:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353395;
        bh=Xz0TUOjXF0iUnwdvQFRiT9f0vxgEg38Ef9OUoCkHeck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKFEa4SRFAiRbLxkH3H1lQGSCN/347+jhy2yipd7hoUeqOxn/gc9srlQrMxzUEWTF
         hNCeTjQTVh5Y58Wokaj4s7G5sKbg2qHG7B+xx781LhP6m3kSG7kS1shx/EbKTYe++6
         gcw8pyJfhNB0LFoIN3xdVU3O25m7E/htRT3zWW3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 112/172] RDMA/hns: Fix the size setting error when copying CQE in clean_cq()
Date:   Mon,  4 Oct 2021 14:52:42 +0200
Message-Id: <20211004125048.601056832@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit cc26aee100588a3f293921342a307b6309ace193 ]

The size of CQE is different for different versions of hardware, so the
driver needs to specify the size of CQE explicitly.

Fixes: 09a5f210f67e ("RDMA/hns: Add support for CQE in size of 64 Bytes")
Link: https://lore.kernel.org/r/20210927125557.15031-2-liangwenpeng@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 6cb4a4e10837..0ccb0c453f6a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3306,7 +3306,7 @@ static void __hns_roce_v2_cq_clean(struct hns_roce_cq *hr_cq, u32 qpn,
 			dest = get_cqe_v2(hr_cq, (prod_index + nfreed) &
 					  hr_cq->ib_cq.cqe);
 			owner_bit = hr_reg_read(dest, CQE_OWNER);
-			memcpy(dest, cqe, sizeof(*cqe));
+			memcpy(dest, cqe, hr_cq->cqe_size);
 			hr_reg_write(dest, CQE_OWNER, owner_bit);
 		}
 	}
-- 
2.33.0



