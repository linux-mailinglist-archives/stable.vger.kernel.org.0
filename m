Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FB5421002
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbhJDNkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238392AbhJDNi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89C1C61452;
        Mon,  4 Oct 2021 13:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353446;
        bh=Ko+dduaZiB2EhbGu7/niHXZHWa8H/muRU8/PhXJN4hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbuHFIUCbNSCI2e23UWx14LER2V8dyftogEiTk7AG32yDsIuZF38c1pFgcf3Hf+bj
         cvBeoA2aiEc4eNwbUjZsvM+gXpqi+ZCb0XnkjN/gSGj/GXxuEgbBc1IP+WTP5LpkOz
         TId6jQDUYQpbXn1t5TmGowX7rRIeHbeAB/nkCR4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 098/172] RDMA/hns: Work around broken constant propagation in gcc 8
Date:   Mon,  4 Oct 2021 14:52:28 +0200
Message-Id: <20211004125048.149741508@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 14351f08ed5c8b888cdd95651152db7e096ee27f ]

gcc 8.3 and 5.4 throw this:

In function 'modify_qp_init_to_rtr',
././include/linux/compiler_types.h:322:38: error: call to '__compiletime_assert_1859' declared with attribute error: FIELD_PREP: value too large for the field
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
[..]
drivers/infiniband/hw/hns/hns_roce_common.h:91:52: note: in expansion of macro 'FIELD_PREP'
   *((__le32 *)ptr + (field_h) / 32) |= cpu_to_le32(FIELD_PREP(   \
                                                    ^~~~~~~~~~
drivers/infiniband/hw/hns/hns_roce_common.h:95:39: note: in expansion of macro '_hr_reg_write'
 #define hr_reg_write(ptr, field, val) _hr_reg_write(ptr, field, val)
                                       ^~~~~~~~~~~~~
drivers/infiniband/hw/hns/hns_roce_hw_v2.c:4412:2: note: in expansion of macro 'hr_reg_write'
  hr_reg_write(context, QPC_LP_PKTN_INI, lp_pktn_ini);

Because gcc has miscalculated the constantness of lp_pktn_ini:

	mtu = ib_mtu_enum_to_int(ib_mtu);
	if (WARN_ON(mtu < 0)) [..]
	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / mtu);

Since mtu is limited to {256,512,1024,2048,4096} lp_pktn_ini is between 4
and 8 which is compatible with the 4 bit field in the FIELD_PREP.

Work around this broken compiler by adding a 'can never be true'
constraint on lp_pktn_ini's value which clears out the problem.

Fixes: f0cb411aad23 ("RDMA/hns: Use new interface to modify QP context")
Link: https://lore.kernel.org/r/0-v1-c773ecb137bc+11f-hns_gcc8_jgg@nvidia.com
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c320891c8763..6cb4a4e10837 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4411,7 +4411,12 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	hr_qp->path_mtu = ib_mtu;
 
 	mtu = ib_mtu_enum_to_int(ib_mtu);
-	if (WARN_ON(mtu < 0))
+	if (WARN_ON(mtu <= 0))
+		return -EINVAL;
+#define MAX_LP_MSG_LEN 65536
+	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 64KB */
+	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / mtu);
+	if (WARN_ON(lp_pktn_ini >= 0xF))
 		return -EINVAL;
 
 	if (attr_mask & IB_QP_PATH_MTU) {
@@ -4419,10 +4424,6 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 		hr_reg_clear(qpc_mask, QPC_MTU);
 	}
 
-#define MAX_LP_MSG_LEN 65536
-	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 64KB */
-	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / mtu);
-
 	hr_reg_write(context, QPC_LP_PKTN_INI, lp_pktn_ini);
 	hr_reg_clear(qpc_mask, QPC_LP_PKTN_INI);
 
-- 
2.33.0



