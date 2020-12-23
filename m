Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75332E1770
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgLWCSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727990AbgLWCSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB0922A83;
        Wed, 23 Dec 2020 02:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689808;
        bh=jUTVGPKaUv0dLokQQNpWd1K4DlKDte1jQwHqFUCqreY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igB9VK2E0ctLkgo1/UC0P/3yA4JxmS+NB630ZsWGlqMTTY5pVSPV4ruE9bSKijk78
         2SJ/db2GSKETU40Yhiea8FkOym9dzCACOjajklWfI+K2XX/w16VgPlxWjlZ1Fs6qP0
         cXGKpLM0s2nXFHjAKdEYZp2qyeNmroge4Fyd3+9ZlNotEKKVk4iq8YdEX09UQMvmAf
         8Efm7h8EYL6BF5Z9V9XHem95Fuk37QHCR5SYfz5VWlP6gxApSwCJm6CBRQ7ac2blq4
         2w057e/aYiiy3ir8cQ3o4M7Aavdmw/u3Kz7cnpGo74ZOrRpR99Zf9kwIW1+K4mokGg
         GUAj+nIWz7IhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 017/217] RDMA/siw: Fix typo of EAGAIN not -EAGAIN in siw_cm_work_handler()
Date:   Tue, 22 Dec 2020 21:13:06 -0500
Message-Id: <20201223021626.2790791-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index 66764f7ef072a..1f9e15b715048 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1047,7 +1047,7 @@ static void siw_cm_work_handler(struct work_struct *w)
 					    cep->state);
 			}
 		}
-		if (rv && rv != EAGAIN)
+		if (rv && rv != -EAGAIN)
 			release_cep = 1;
 		break;
 
-- 
2.27.0

