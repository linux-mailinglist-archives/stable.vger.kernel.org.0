Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C7A439C50
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhJYRCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234264AbhJYRC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 406FD60EE3;
        Mon, 25 Oct 2021 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181207;
        bh=k6hRgrW1wvRBZh7M1MsTSIZZUcz0slUi4Br1HntwG1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0l/iyJvjENm7b/0dXw6qg+NY/jhSszxFPEEQ0RVABmiz4SNz1hRbOdPGwJ+fchri
         2eu9a6QtDkkE8PRkP86Fr+WEaQqIeqmPu3lCWW45iMprR3swjstNy+8ZId6gbAFc9E
         DQgrUYIGEHeJNDTGd/nSbMLPmqnR0gfo8G8/JPyakKTUuYeGK3Wpeh/ecuBc/CS1JP
         8Uo1TkL614pTQh3V28kcj46rGtnm4uora0xEg3vNFo96xvIcnMqpRHWM8Q8/Cz0PFZ
         l9fm6lwWz8svN0UCdhFjmeMgLPTpy/t55OELaMwb/BJPofmy3wIPF+JHoZY2JJqNHR
         mm9fTvdIEiHtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 10/18] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
Date:   Mon, 25 Oct 2021 12:59:23 -0400
Message-Id: <20211025165939.1393655-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025165939.1393655-1-sashal@kernel.org>
References: <20211025165939.1393655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 06634d5b6e923ed0d4772aba8def5a618f44c7fe ]

The driver probing function should return < 0 for failure, otherwise
kernel will treat value > 0 as success.

Link: https://lore.kernel.org/r/1634522181-31166-1-git-send-email-zheyuma97@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 37ab71b6a8a7..5eed11042f78 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4071,7 +4071,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 					ql_dbg_pci(ql_dbg_init, ha->pdev,
 					    0xe0ee, "%s: failed alloc dsd\n",
 					    __func__);
-					return 1;
+					return -ENOMEM;
 				}
 				ha->dif_bundle_kallocs++;
 
-- 
2.33.0

