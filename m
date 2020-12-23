Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3F82E170A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgLWDFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:05:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728517AbgLWCTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8EFC23332;
        Wed, 23 Dec 2020 02:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689905;
        bh=9RuZFnX4uC9UBBMIvUPh59HEIcLBxZzT1JmZAz0pnHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RX3PzY9rPZYA3rM/ivhjk4jLTFARiXjZtgQxKPyc6m3qWU4GeQZnryxTLp7+yG2T2
         YT2e75/X7m9W6ZzuHNkNh3omRLX20+g06zynsGA7mjXy0yvaVVd4jIHnMEuQuKpl22
         VekurcBBgK6CBQTwQ5Z/zA67aWNaMjB8FpxL4ClLACuqVkMuNlYXGxvAGVUDSx3BkQ
         7JiDGVhoh+uOVGbXSBLUrbXCkgEi/bI9/y07yqQ0Kpn1w+97Bq7BXxsZJj3GNEmxmq
         DS2BTl9vavdKb8MolnZ1HuUQ4uPJFwAfjQ2wybyjkU56xPxPPIjAcOVyArDC+wIKyR
         FEhos+rxELnIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 009/130] RDMA/siw: Fix typo of EAGAIN not -EAGAIN in siw_cm_work_handler()
Date:   Tue, 22 Dec 2020 21:16:12 -0500
Message-Id: <20201223021813.2791612-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 856c2998999958761b6a52208b4edb4d352c4037 ]

The rv cannot be 'EAGAIN' in the previous path, we should use '-EAGAIN' to
check it. For example:

Call trace:
 ->siw_cm_work_handler
	->siw_proc_mpareq
		->siw_recv_mpa_rr

Link: https://lore.kernel.org/r/20201028122509.47074-1-zhangqilong3@huawei.com
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index e3bac1a877bb7..738855cffc18e 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1055,7 +1055,7 @@ static void siw_cm_work_handler(struct work_struct *w)
 					    cep->state);
 			}
 		}
-		if (rv && rv != EAGAIN)
+		if (rv && rv != -EAGAIN)
 			release_cep = 1;
 		break;
 
-- 
2.27.0

