Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B0E3C4DDB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242977AbhGLHP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240067AbhGLHOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:14:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CA0D61151;
        Mon, 12 Jul 2021 07:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073861;
        bh=ZHPtdMtLw+LRQMoNHxOGGo1Ztxl6VU7JJPy7gPvtOSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cm8cKMckuf2PgEad02UpJ/gJmRoN6BwxKVHL77AOqk35k0lO/EoA7+6mw9nh2xvl0
         GxRLmCr491TFmTsGM8R8PfAs7K3R/YeM+WFYxjFV7ILe8Ojkup2KtdJ2BL3MrCn60L
         lo50biayHLvs2M7hOulsDr0Y4H/ddXar8hDxx4VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Md Haris Iqbal <haris.iqbal@ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 383/700] RDMA/rtrs-clt: Check state of the rtrs_clt_sess before reading its stats
Date:   Mon, 12 Jul 2021 08:07:46 +0200
Message-Id: <20210712061017.119323222@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 959ba0462ef0..cb6f5c7610a0 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -805,6 +805,9 @@ static struct rtrs_clt_sess *get_next_path_min_inflight(struct path_it *it)
 	int inflight;
 
 	list_for_each_entry_rcu(sess, &clt->paths_list, s.entry) {
+		if (unlikely(READ_ONCE(sess->state) != RTRS_CLT_CONNECTED))
+			continue;
+
 		if (unlikely(!list_empty(raw_cpu_ptr(sess->mp_skip_entry))))
 			continue;
 
-- 
2.30.2



