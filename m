Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52D33C499C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbhGLGpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239096AbhGLGor (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EEBB611C0;
        Mon, 12 Jul 2021 06:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072039;
        bh=Cp9r/6DiavQ39O4xHOQMq0GHMp6ECWukRjvPnGBvsg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yl2NR6+OjzkWWm3yGhXGb9U5wk1v/PjC0+SMh0+swbt0hhQEbUWgVi6dpx1s7xG+P
         awcBLKNpH9B419UYQAQgx8Og0wn+owO1guMi4HguelFrh7KasdUxo1ZeBS5jPYvOEd
         DxZoJVPhf+cnvqTMolDpufi5kaoeLy0kmXXFRfHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/593] RDMA/rtrs-clt: Fix memory leak of not-freed sess->stats and stats->pcpu_stats
Date:   Mon, 12 Jul 2021 08:08:07 +0200
Message-Id: <20210712060921.709320804@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit 7ecd7e290bee0ab9cf75b79a367a4cc113cf8292 ]

sess->stats and sess->stats->pcpu_stats objects are freed
when sysfs entry is removed. If something wrong happens and
session is closed before sysfs entry is created,
sess->stats and sess->stats->pcpu_stats objects are not freed.

This patch adds freeing of them at three places:
1. When client uses wrong address and session creation fails.
2. When client fails to create a sysfs entry.
3. When client adds wrong address via sysfs add_path.

Fixes: 215378b838df0 ("RDMA/rtrs: client: sysfs interface functions")
Link: https://lore.kernel.org/r/20210528113018.52290-21-jinpu.wang@ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index dc44a9bfcdaa..46fad202a380 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2706,6 +2706,8 @@ struct rtrs_clt *rtrs_clt_open(struct rtrs_clt_ops *ops,
 		if (err) {
 			list_del_rcu(&sess->s.entry);
 			rtrs_clt_close_conns(sess, true);
+			free_percpu(sess->stats->pcpu_stats);
+			kfree(sess->stats);
 			free_sess(sess);
 			goto close_all_sess;
 		}
@@ -2714,6 +2716,8 @@ struct rtrs_clt *rtrs_clt_open(struct rtrs_clt_ops *ops,
 		if (err) {
 			list_del_rcu(&sess->s.entry);
 			rtrs_clt_close_conns(sess, true);
+			free_percpu(sess->stats->pcpu_stats);
+			kfree(sess->stats);
 			free_sess(sess);
 			goto close_all_sess;
 		}
@@ -2973,6 +2977,8 @@ int rtrs_clt_create_path_from_sysfs(struct rtrs_clt *clt,
 close_sess:
 	rtrs_clt_remove_path_from_arr(sess);
 	rtrs_clt_close_conns(sess, true);
+	free_percpu(sess->stats->pcpu_stats);
+	kfree(sess->stats);
 	free_sess(sess);
 
 	return err;
-- 
2.30.2



