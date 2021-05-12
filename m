Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA26137CA57
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhELQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhELQUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:20:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55AB561448;
        Wed, 12 May 2021 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834383;
        bh=gCuyvvfFOZX6098VB3pUwmNlsQdTmZMlu0xuhWWufwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEuoRd/MmluAveKNTOJU5nSAeM/xNgjWg/lpCC904OyD3otEIUMjmMPIrI6Gk1wUc
         zuOgljbrND73nQdnPu7z9pe2nWn1kJ7AEi2Oc+Ma1kUlHIm4BIYAAUMRs43C2bQAH9
         vSjqEUhgGPGfhqmpWzKJKw7hEcWzWaCuC0Oeugm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 487/601] RDMA/rtrs-clt: destroy sysfs after removing session from active list
Date:   Wed, 12 May 2021 16:49:24 +0200
Message-Id: <20210512144843.880796411@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gioh Kim <gi-oh.kim@ionos.com>

[ Upstream commit 7f4a8592ff29f19c5a2ca549d0973821319afaad ]

A session can be removed dynamically by sysfs interface "remove_path" that
eventually calls rtrs_clt_remove_path_from_sysfs function.  The current
rtrs_clt_remove_path_from_sysfs first removes the sysfs interfaces and
frees sess->stats object. Second it removes the session from the active
list.

Therefore some functions could access non-connected session and access the
freed sess->stats object even-if they check the session status before
accessing the session.

For instance rtrs_clt_request and get_next_path_min_inflight check the
session status and try to send IO to the session.  The session status
could be changed when they are trying to send IO but they could not catch
the change and update the statistics information in sess->stats object,
and generate use-after-free problem.
(see: "RDMA/rtrs-clt: Check state of the rtrs_clt_sess before reading its
stats")

This patch changes the rtrs_clt_remove_path_from_sysfs to remove the
session from the active session list and then destroy the sysfs
interfaces.

Each function still should check the session status because closing or
error recovery paths can change the status.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20210412084002.33582-1-gi-oh.kim@ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index ee37c5af3a8c..4cd81d84cd18 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2799,8 +2799,8 @@ int rtrs_clt_remove_path_from_sysfs(struct rtrs_clt_sess *sess,
 	} while (!changed && old_state != RTRS_CLT_DEAD);
 
 	if (likely(changed)) {
-		rtrs_clt_destroy_sess_files(sess, sysfs_self);
 		rtrs_clt_remove_path_from_arr(sess);
+		rtrs_clt_destroy_sess_files(sess, sysfs_self);
 		kobject_put(&sess->kobj);
 	}
 
-- 
2.30.2



