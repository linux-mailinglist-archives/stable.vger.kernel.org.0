Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA6439C76
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhJYRDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhJYRC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0343E610A0;
        Mon, 25 Oct 2021 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181233;
        bh=X+98h8tgx1L4hbX+neIkisyY/dxDOpM5yhhp19fq/AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng7OQhCGEmlncNcsP4dqs0241XF+D351bRIKZlrQE/x70d7toQXYjFLgnK5MgliJo
         uU+LC8YZswEeG3yRBLeR6CTyfDV+Fv6spZrKn8nYGIo90BtZKYD9sSg1fulqlKQf6V
         sa13O0tGDUyP57fFhJw1Twlw26LGtdqIlFropZ2dPZlbM+evgjqerqwd2uKnV70SjW
         ZPEN8sdGEPDV4Ot22GTiLmagNkbN7EH9JgvPzfa7V+SB0p93f/J3a3A/sZdGYJOSZu
         94W3FEwGlYX1szqXWtcRSorMv4FtsWEDyr+DsTfBAaLLnmQrVkJ6jI9p5mZHRUsWov
         +8UoeHrvJg5zQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/13] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
Date:   Mon, 25 Oct 2021 13:00:14 -0400
Message-Id: <20211025170023.1394358-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170023.1394358-1-sashal@kernel.org>
References: <20211025170023.1394358-1-sashal@kernel.org>
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
index 4af794c46d17..a4a8bc2b4192 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4077,7 +4077,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 					ql_dbg_pci(ql_dbg_init, ha->pdev,
 					    0xe0ee, "%s: failed alloc dsd\n",
 					    __func__);
-					return 1;
+					return -ENOMEM;
 				}
 				ha->dif_bundle_kallocs++;
 
-- 
2.33.0

