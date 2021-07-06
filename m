Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE03BCE96
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhGFL0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhGFLWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6399261C82;
        Tue,  6 Jul 2021 11:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570271;
        bh=OLYz9Fhx4UCce3belqp6thG8WF8rjYVJA9ABbB28Ka4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgBViOdj5lkNm7oNONIoO+Gr04jsevzXGQraQ/bgLCDJ57rwj26RBo1LKZCVJX8CJ
         0OyjYNBFz6hozNB3LeHiyI8KhMOAsFZtrm39nVu022OmfiA7ZP797OmgTaW7aZMQwj
         h0il4yBajuftoYT1asfAgUWH25atXXft1GiTXFabazrPd5D7yQK8HhtGIvalDuY0PD
         lHCaK85vRmQNZDrQFguS5qNkKBxyUXltrVqxyH3cnsdEqzjvsA362XluAQSmXIrOLx
         WiFXd/3EY2PnhJu4rlObWdKPDil6AfLk+D/SmtCH3dhfH2edbQdoPOQgKZb/ktOw/O
         intfkRMOZQLlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 165/189] IB/isert: Align target max I/O size to initiator size
Date:   Tue,  6 Jul 2021 07:13:45 -0400
Message-Id: <20210706111409.2058071-165-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit 109d19a5eb3ddbdb87c43bfd4bcf644f4569da64 ]

Since the Linux iser initiator default max I/O size set to 512KB and since
there is no handshake procedure for this size in iser protocol, set the
default max IO size of the target to 512KB as well.

For changing the default values, there is a module parameter for both
drivers.

Link: https://lore.kernel.org/r/20210524085215.29005-1-mgurtovoy@nvidia.com
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 4 ++--
 drivers/infiniband/ulp/isert/ib_isert.h | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 18266f07c58d..de3fc05fd2e8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -35,10 +35,10 @@ static const struct kernel_param_ops sg_tablesize_ops = {
 	.get = param_get_int,
 };
 
-static int isert_sg_tablesize = ISCSI_ISER_DEF_SG_TABLESIZE;
+static int isert_sg_tablesize = ISCSI_ISER_MIN_SG_TABLESIZE;
 module_param_cb(sg_tablesize, &sg_tablesize_ops, &isert_sg_tablesize, 0644);
 MODULE_PARM_DESC(sg_tablesize,
-		 "Number of gather/scatter entries in a single scsi command, should >= 128 (default: 256, max: 4096)");
+		 "Number of gather/scatter entries in a single scsi command, should >= 128 (default: 128, max: 4096)");
 
 static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 6c5af13db4e0..ca8cfebe26ca 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -65,9 +65,6 @@
  */
 #define ISER_RX_SIZE		(ISCSI_DEF_MAX_RECV_SEG_LEN + 1024)
 
-/* Default I/O size is 1MB */
-#define ISCSI_ISER_DEF_SG_TABLESIZE 256
-
 /* Minimum I/O size is 512KB */
 #define ISCSI_ISER_MIN_SG_TABLESIZE 128
 
-- 
2.30.2

