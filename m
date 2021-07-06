Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE4E3BCFBC
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbhGFLbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhGFLZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4FC961D4E;
        Tue,  6 Jul 2021 11:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570370;
        bh=x1TvY+knuN5gDF07XZ/Q+PwYNswhi2uTCeBf1ReKKX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9fS3Z2q96kw/eHwteFJCBsc0lzO9pR/AaPhPV86YjYeFTlvVRQZKvmVtbWVokxJu
         WXNmJDbro3RXWUYjO79VmSrjr6DJ9xKXI4GvM8aKNp4nZsIOEx3miqJW720Gtoftm9
         pklWXNHZyWJsfn5q+3pptMi9h35EoXWsK6R1fQ6rPD6gF4JSnPVpFDa69f8ka1czYL
         IdKUfnc2725dv6eeCUSujlxyUav8ebjqTE1IkceLL86KDH/VqQnTHP6Rd3BYa6CFwn
         9GtRT0zz/bahuUNhhShGUi/Fh8p+yLTOSmt7hR6BWGjBWiavja1KN8Hp8UqTi/zQha
         uhgRoEcilEGCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        kernel test robot <lkp@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 047/160] RDMA/rtrs: Change MAX_SESS_QUEUE_DEPTH
Date:   Tue,  6 Jul 2021 07:16:33 -0400
Message-Id: <20210706111827.2060499-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit 3a98ea7041b7d18ac356da64823c2ba2f8391b3e ]

Max IB immediate data size is 2^28 (MAX_IMM_PAYL_BITS)
and the minimum chunk size is 4096 (2^12).
Therefore the maximum sess_queue_depth is 65536 (2^16).

Link: https://lore.kernel.org/r/20210528113018.52290-6-jinpu.wang@ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-pri.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index 8caad0a2322b..51c60f542876 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -47,12 +47,15 @@ enum {
 	MAX_PATHS_NUM = 128,
 
 	/*
-	 * With the size of struct rtrs_permit allocated on the client, 4K
-	 * is the maximum number of rtrs_permits we can allocate. This number is
-	 * also used on the client to allocate the IU for the user connection
-	 * to receive the RDMA addresses from the server.
+	 * Max IB immediate data size is 2^28 (MAX_IMM_PAYL_BITS)
+	 * and the minimum chunk size is 4096 (2^12).
+	 * So the maximum sess_queue_depth is 65536 (2^16) in theory.
+	 * But mempool_create, create_qp and ib_post_send fail with
+	 * "cannot allocate memory" error if sess_queue_depth is too big.
+	 * Therefore the pratical max value of sess_queue_depth is
+	 * somewhere between 1 and 65536 and it depends on the system.
 	 */
-	MAX_SESS_QUEUE_DEPTH = 4096,
+	MAX_SESS_QUEUE_DEPTH = 65536,
 
 	RTRS_HB_INTERVAL_MS = 5000,
 	RTRS_HB_MISSED_MAX = 5,
-- 
2.30.2

