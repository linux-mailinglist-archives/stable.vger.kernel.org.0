Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BAF34C669
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhC2IHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232228AbhC2IGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:06:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 330C86193C;
        Mon, 29 Mar 2021 08:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005175;
        bh=QYYBqPgpf6rdxTRU5J/O3iAC7Ni8jeHSeg2wLg/r/Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6f4ZfBlo2x/lg9EFk89sgqvlnp9MWYBzZUGQD3VTjD+bDUMs7nnwvFwMrkeKzta1
         hSVf/I1GwhE6WOmaA4xhDSUnGuPebc8uduES+xJaenetNk+QZKtQy+qgk29GK20Rfk
         09VBL8Lv7CQTjSoPHtQSY7XkSLcnl6jrOXNRZadU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Manish Rangankar <mrangankar@marvell.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/59] scsi: qedi: Fix error return code of qedi_alloc_global_queues()
Date:   Mon, 29 Mar 2021 09:58:31 +0200
Message-Id: <20210329075610.553655128@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit f69953837ca5d98aa983a138dc0b90a411e9c763 ]

When kzalloc() returns NULL to qedi->global_queues[i], no error return code
of qedi_alloc_global_queues() is assigned.  To fix this bug, status is
assigned with -ENOMEM in this case.

Link: https://lore.kernel.org/r/20210308033024.27147-1-baijiaju1990@gmail.com
Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index a742b8856776..b0a404d4e676 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1354,6 +1354,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		if (!qedi->global_queues[i]) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to allocation global queue %d.\n", i);
+			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
 
-- 
2.30.1



