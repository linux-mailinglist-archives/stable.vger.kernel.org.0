Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CDC38EEBB
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhEXPzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233985AbhEXPwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:52:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA41B613E4;
        Mon, 24 May 2021 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870734;
        bh=ZLvKPy560rOp4foRSQ0/RNlaixVa3FYvRKhxtV5t04U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTAc0O0kSk7Cq9eVHqD7D1X2edjn8z+ao1B55O7Upi5QffRPK3Sztv+iMatkyYnNM
         T3GqfFjP3yOcp1hiHQ6FGK4j7tHEmHH7p3Mca4b66lArfRGiFzZQuQ3JKdWMALk4Em
         JJgjRDJBcTw2S80UIkapd0qIRCd6OVc0s0FvUw3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/104] scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()
Date:   Mon, 24 May 2021 17:25:05 +0200
Message-Id: <20210524152333.176560633@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 5cb289bf2d7c34ca1abd794ce116c4f19185a1d4 ]

Fix to return a negative error code from the error handling case instead of
0 as done elsewhere in this function.

Link: https://lore.kernel.org/r/20210514090952.6715-1-thunder.leizhen@huawei.com
Fixes: a9083016a531 ("[SCSI] qla2xxx: Add ISP82XX support.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b3ba0de5d4fb..0563c9530dca 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1066,7 +1066,8 @@ qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
 		return ret;
 	}
 
-	if (qla82xx_flash_set_write_enable(ha))
+	ret = qla82xx_flash_set_write_enable(ha);
+	if (ret < 0)
 		goto done_write;
 
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_WDATA, data);
-- 
2.30.2



