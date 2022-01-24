Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C98B499038
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344709AbiAXT7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41030 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357912AbiAXTxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:53:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00E51B8122C;
        Mon, 24 Jan 2022 19:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0DAC340E5;
        Mon, 24 Jan 2022 19:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053997;
        bh=6O4ixEgbR8ruLiZx+ckm3RWsZX2EjjJUpSSMui6IHzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ru9wGlPbhVVwZbT9WuzwCKDPIEDbweuQwXvlwhzJ39JzskVUz+A1E0Ev3X4ulMih
         Gdn63lZ9fjuSIoxho7pTyeMTAkaKuZRYToob2GwRzMDh9+Xb0OiWgiJ4rqzCev25fR
         82crgsbf4kpmG3QIBgS092fI/nBd2jvhrZf/XRvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/563] scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
Date:   Mon, 24 Jan 2022 19:40:09 +0100
Message-Id: <20220124184032.865459407@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 5d751628a6340..9b318958d78cc 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1323,7 +1323,9 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 	int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
 	int rv = -1;
 
-	WARN_ON(q_index >= PM8001_MAX_INB_NUM);
+	if (WARN_ON(q_index >= pm8001_ha->max_q_num))
+		return -EINVAL;
+
 	spin_lock_irqsave(&circularQ->iq_lock, flags);
 	rv = pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
 			&pMessage);
-- 
2.34.1



