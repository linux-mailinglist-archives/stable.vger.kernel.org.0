Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48D54174C4
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346123AbhIXNKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346844AbhIXNIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A0E460F39;
        Fri, 24 Sep 2021 12:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488226;
        bh=lx1LhdKj95FfU9ceJD3dWpyV9B7g4S1HDUpYyQ475KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9uKMnI2Io81hMqXOXsRpRzXDfFhXLzxAj/P6yCH/e/VworbE2RYk8n9kIOhoPMyP
         qiabrJFkwBwHcNF2w4iSNiGRA3DWLPOI2vVhpm2IpzGGolHB+CxaUEhB2izwKpHYFQ
         4h798r5SOurIVIfPKATH1gFhtr31z1WdyBO42V8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/63] ceph: cancel delayed work instead of flushing on mdsc teardown
Date:   Fri, 24 Sep 2021 14:44:31 +0200
Message-Id: <20210924124335.340513745@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b4002173b7989588b6feaefc42edaf011b596782 ]

The first thing metric_delayed_work does is check mdsc->stopping,
and then return immediately if it's set. That's good since we would
have already torn down the metric structures at this point, otherwise,
but there is no locking around mdsc->stopping.

It's possible that the ceph_metric_destroy call could race with the
delayed_work, in which case we could end up with the delayed_work
accessing destroyed percpu variables.

At this point in the mdsc teardown, the "stopping" flag has already been
set, so there's no benefit to flushing the work. Move the work
cancellation in ceph_metric_destroy ahead of the percpu variable
destruction, and eliminate the flush_delayed_work call in
ceph_mdsc_destroy.

Fixes: 18f473b384a6 ("ceph: periodically send perf metrics to MDSes")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 1 -
 fs/ceph/metric.c     | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8cbbb611e0ca..46606fb5b886 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4859,7 +4859,6 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_metric_destroy(&mdsc->metric);
 
-	flush_delayed_work(&mdsc->metric.delayed_work);
 	fsc->mdsc = NULL;
 	kfree(mdsc);
 	dout("mdsc_destroy %p done\n", mdsc);
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 3b2ef8ee544e..9e0a0e26294e 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -224,6 +224,8 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
+	cancel_delayed_work_sync(&m->delayed_work);
+
 	percpu_counter_destroy(&m->total_inodes);
 	percpu_counter_destroy(&m->opened_inodes);
 	percpu_counter_destroy(&m->i_caps_mis);
@@ -231,8 +233,6 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
 
-	cancel_delayed_work_sync(&m->delayed_work);
-
 	ceph_put_mds_session(m->session);
 }
 
-- 
2.33.0



