Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809E149A2C3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365968AbiAXXwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843473AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6AEC06C5B3;
        Mon, 24 Jan 2022 13:15:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0F6261484;
        Mon, 24 Jan 2022 21:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6B2C340E4;
        Mon, 24 Jan 2022 21:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058936;
        bh=XiEZal2TU1ajBjFbZzAocbQPIe4D4ZjRyO1MiTh+6rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCqRP5jkIoFVAM1p5P2Q5fcjHFQIindRnGr1pDIZ9lp3o9BGAekVa67iFadg7xva8
         r/qnHzHl6Nz+N9ykD+ji/QnFlfGa1iOHSzqa05RyxM/ttzk5JKK8Pyi3hn8RWn+rfp
         mbyiEAVkYnuBjw0HnX0LVDZvI7whc8fHqvuFTAGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0451/1039] scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
Date:   Mon, 24 Jan 2022 19:37:20 +0100
Message-Id: <20220124184140.452294711@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 124cb69740c67..4390c8b9170cd 100644
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



