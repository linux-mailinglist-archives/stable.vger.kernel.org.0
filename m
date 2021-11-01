Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2065D44188B
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhKAJtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234131AbhKAJrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C2646141B;
        Mon,  1 Nov 2021 09:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759061;
        bh=X9al5Ox2tYwRmBoKuwReQVJhWQJeMQKbHbPC+NjVTpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEQU8H60WRRzOxxA3GpxxhcvYxP4k3DegK3sAOsZW+VqE/s4RukjOBrjSgFnWM2r4
         JeW39zZCU5IKBnF3Mv32Ybf4SXfKau6G+B3IzKafsC074ms2RrNKa9rHFMiIIhgo3f
         bhV3HD5EOn3QuVtlxmpPghR7tDyyMpGbyGGd4uVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 097/125] RDMA/irdma: Set VLAN in UD work completion correctly
Date:   Mon,  1 Nov 2021 10:17:50 +0100
Message-Id: <20211101082551.528725591@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit cc07b73ef11d11d4359fb104d0199b22451dd3d8 ]

Currently VLAN is reported in UD work completion when VLAN id is zero,
i.e. no VLAN case.

Report VLAN in UD work completion only when VLAN id is non-zero.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://lore.kernel.org/r/20211019151654.1943-1-shiraz.saleem@intel.com
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index fa393c5ea397..4261705fa19d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3405,9 +3405,13 @@ static void irdma_process_cqe(struct ib_wc *entry,
 		}
 
 		if (cq_poll_info->ud_vlan_valid) {
-			entry->vlan_id = cq_poll_info->ud_vlan & VLAN_VID_MASK;
-			entry->wc_flags |= IB_WC_WITH_VLAN;
+			u16 vlan = cq_poll_info->ud_vlan & VLAN_VID_MASK;
+
 			entry->sl = cq_poll_info->ud_vlan >> VLAN_PRIO_SHIFT;
+			if (vlan) {
+				entry->vlan_id = vlan;
+				entry->wc_flags |= IB_WC_WITH_VLAN;
+			}
 		} else {
 			entry->sl = 0;
 		}
-- 
2.33.0



