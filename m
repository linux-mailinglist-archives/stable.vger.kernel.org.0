Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AC73CAA17
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbhGOTLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243234AbhGOTJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EABBA613F5;
        Thu, 15 Jul 2021 19:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375923;
        bh=e6O7bjXegayPtUa0HPvRQvDMvyDvMEVHzqqEcAPT+RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOP/Bpwkl9PFowwn6p/fpGESoUoJckDdr8MFY0GHifTglI0UEB+EHNh5HMjLekiLy
         rfldWo0nhjAWWEICaxtZFsK6+B3X1UUz2JQ3Il33/DVfX8PrnnFBfBYuj1cMpCO5uz
         VDYLZYQkej9xDohhrtTjDYcbAUijDaEpBtly1yR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        kernel test robot <lkp@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 051/266] RDMA/rtrs: Change MAX_SESS_QUEUE_DEPTH
Date:   Thu, 15 Jul 2021 20:36:46 +0200
Message-Id: <20210715182623.175183253@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 86e65cf30cab..d957bbf1ddd3 100644
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



