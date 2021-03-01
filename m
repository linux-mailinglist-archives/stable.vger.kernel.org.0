Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7678D328A71
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbhCASRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239059AbhCASJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CABEC651BD;
        Mon,  1 Mar 2021 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618981;
        bh=Z+ePCZ6pyYhGogbtygU64S4KMEAnTB0mryGtOaQL6f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vO7AmONTZ/Y+tWvdDzcb1hdYO6Fo9ixyyhbwq1Sqylr/XpRb8/oo/fNYGpFqV/lkD
         2v6AB55M6NrGAB0/MHu2xviJfbN72meaPu+Zhax6xABjygqRUYB9OWp9LRk6GkHwPw
         fklPqLrUGHw5dmKH7dhsirAcfB/tVf1yONKtGpWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Lutz Pogrell <lutz.pogrell@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/663] RDMA/rtrs-srv: Use sysfs_remove_file_self for disconnect
Date:   Mon,  1 Mar 2021 17:08:56 +0100
Message-Id: <20210301161156.079296550@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit f991fdac813f1598a9bb17b602ce04812ba9148c ]

Remove self first to avoid deadlock, we don't want to
use close_work to remove sess sysfs.

Fixes: 91b11610af8d ("RDMA/rtrs: server: sysfs interface functions")
Link: https://lore.kernel.org/r/20201217141915.56989-5-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Tested-by: Lutz Pogrell <lutz.pogrell@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 07fbb063555d3..3c5dfe21bba68 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -53,6 +53,8 @@ static ssize_t rtrs_srv_disconnect_store(struct kobject *kobj,
 	sockaddr_to_str((struct sockaddr *)&sess->s.dst_addr, str, sizeof(str));
 
 	rtrs_info(s, "disconnect for path %s requested\n", str);
+	/* first remove sysfs itself to avoid deadlock */
+	sysfs_remove_file_self(&sess->kobj, &attr->attr);
 	close_sess(sess);
 
 	return count;
-- 
2.27.0



