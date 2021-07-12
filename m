Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E7C3C53BB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348514AbhGLHzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350647AbhGLHvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2F4161C31;
        Mon, 12 Jul 2021 07:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076025;
        bh=RzlQ6reBUB4IWa8Kauy0MswGDKw9aaN/XJLSrh7/6dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyHU27gOq27/GeRdtC+JIzCEf6Ul3MSAz40eFbKeOe/xsZ59/MF+kLRkdUvEr+e6n
         Iz+p45uAEreWmAOVKpmJrYqcQiOrSaI/U/OHRwscvuprlSjigt8toJb9X+zd/3Nj54
         30RZe1cLwoAxB0d/zUVU7qAYLhrqQc1ntUbPc25k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Md Haris Iqbal <haris.iqbal@ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 429/800] RDMA/rtrs-clt: Check state of the rtrs_clt_sess before reading its stats
Date:   Mon, 12 Jul 2021 08:07:32 +0200
Message-Id: <20210712061012.735221061@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit 41db63a7efe1c8c2dd282c1849a6ebfbbedbaf67 ]

When get_next_path_min_inflight is called to select the next path, it
iterates over the list of available rtrs_clt_sess (paths). It then reads
the number of inflight IOs for that path to select one which has the least
inflight IO.

But it may so happen that rtrs_clt_sess (path) is no longer in the
connected state because closing or error recovery paths can change the status
of the rtrs_clt_Sess.

For example, the client sent the heart-beat and did not get the
response, it would change the session status and stop IO processing.
The added checking of this patch can prevent accessing the broken path
and generating duplicated error messages.

It is ok if the status is changed after checking the status because
the error recovery path does not free memory and only tries to
reconnection. And also it is ok if the session is closed after checking
the status because closing the session changes the session status and
flush all IO beforing free memory. If the session is being accessed for
IO processing, the closing session will wait.

Fixes: 6a98d71daea18 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20210528113018.52290-13-jinpu.wang@ionos.com
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 0a794d748a7a..a563c9b9d52c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -814,6 +814,9 @@ static struct rtrs_clt_sess *get_next_path_min_inflight(struct path_it *it)
 	int inflight;
 
 	list_for_each_entry_rcu(sess, &clt->paths_list, s.entry) {
+		if (unlikely(READ_ONCE(sess->state) != RTRS_CLT_CONNECTED))
+			continue;
+
 		if (unlikely(!list_empty(raw_cpu_ptr(sess->mp_skip_entry))))
 			continue;
 
-- 
2.30.2



