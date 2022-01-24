Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921534993A2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386042AbiAXUe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53486 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384043AbiAXU2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:28:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 792B26150D;
        Mon, 24 Jan 2022 20:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A118C340E5;
        Mon, 24 Jan 2022 20:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056125;
        bh=ZzxFbQW2xAG/P4ZtqS8idql9d5dCZsMQurf939RG6pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCqS90HNx8XKJyaQgBgxi4PBWQ5bl44k1hVVe0HWI2M3ehmtwcCi1qNpoUcftBoTC
         TtdvLjwRWwTZ/bg+Gu6xNHPnJHFpn5dqRUNuMBOW2GKZfmU3x317WWKUXhgSgq48Pg
         x/lxNPa+pHyaDtzUEEHTu2ddXZpjQzciridEiOjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 380/846] scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
Date:   Mon, 24 Jan 2022 19:38:17 +0100
Message-Id: <20220124184114.046825070@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 606c54ae975ad3af540b505b46b55a687501711f ]

Starting from commit 05c6c029a44d ("scsi: pm80xx: Increase number of
supported queues") driver initializes only max_q_num queues.  Do not use an
invalid queue if the WARN_ON condition is true.

Link: https://lore.kernel.org/r/20211101232825.2350233-4-ipylypiv@google.com
Fixes: 7640e1eb8c5d ("scsi: pm80xx: Make mpi_build_cmd locking consistent")
Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 639b7e38a1947..880e1f356defc 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1325,7 +1325,9 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 	int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
 	int rv;
 
-	WARN_ON(q_index >= PM8001_MAX_INB_NUM);
+	if (WARN_ON(q_index >= pm8001_ha->max_q_num))
+		return -EINVAL;
+
 	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	rv = pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
 			&pMessage);
-- 
2.34.1



