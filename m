Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F77349068
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhCYLem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232052AbhCYLcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 526F161A77;
        Thu, 25 Mar 2021 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671705;
        bh=SgKPuZd8oNEf6L+eoHlKEq1ZfoBGPgyZhkN5ZIJjqeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnSLYCDfQjUBOcWlO7Hngb7MoMRX/DkOTycjQMU0LDxsw1kL9upy1e1fIN3FJ8SNw
         LgrkVM6fMgYcYs7hiCsqBmgkMNtubCxO6sycSEye1lsRxEn6xdby/WkvJ+s7fU2EED
         UfUPnpbRxh8zDRDbalqD2RkY29XBp837ZI8YtFLIsXtKPHQsfZ1Cmkn//Y4ShazQgm
         NI4N0qU01/mzn2LtJk3MTTbR0Hd/kAG5o5JL0uhyaRPpLmIDheEDoj7UrdJ1HHeRRX
         8+3l3pTbfsVmeNmR0waOWk//C2fkjl+/GOBtVgqV7O+AGTcCl438YepaQxQiSP8S8R
         t3i6wg4fN4tfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/13] scsi: st: Fix a use after free in st_open()
Date:   Thu, 25 Mar 2021 07:28:08 -0400
Message-Id: <20210325112814.1928637-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112814.1928637-1-sashal@kernel.org>
References: <20210325112814.1928637-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit c8c165dea4c8f5ad67b1240861e4f6c5395fa4ac ]

In st_open(), if STp->in_use is true, STp will be freed by
scsi_tape_put(). However, STp is still used by DEBC_printk() after. It is
better to DEBC_printk() before scsi_tape_put().

Link: https://lore.kernel.org/r/20210311064636.10522-1-lyl2019@mail.ustc.edu.cn
Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 618422ea3a41..0d58227431e4 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1267,8 +1267,8 @@ static int st_open(struct inode *inode, struct file *filp)
 	spin_lock(&st_use_lock);
 	if (STp->in_use) {
 		spin_unlock(&st_use_lock);
-		scsi_tape_put(STp);
 		DEBC_printk(STp, "Device already in use.\n");
+		scsi_tape_put(STp);
 		return (-EBUSY);
 	}
 
-- 
2.30.1

