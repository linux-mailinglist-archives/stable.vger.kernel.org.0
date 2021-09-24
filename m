Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30FE4173BA
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345843AbhIXM7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345502AbhIXM62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F70161359;
        Fri, 24 Sep 2021 12:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487949;
        bh=meQaol9N4At2p4QAx5S9vy6GohX72d19BCZa0U+/tqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrLmIogdNYbxvXd+W6HQq9ucv+4C5AE5iMVFwDgMv9wP6VQuTU0zcoTowOBAdvOb3
         baOrpJL/PabuzUEzQsKWCcrfZwiC2CqtAqQRPynXTg+H4vX7JiYmk/Wer6BTRbKro6
         U0fqzt2CnVGyWO46zaBTS8yzYwLnxP9zMw56WCYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.14 024/100] ceph: cancel delayed work instead of flushing on mdsc teardown
Date:   Fri, 24 Sep 2021 14:43:33 +0200
Message-Id: <20210924124342.251566373@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit b4002173b7989588b6feaefc42edaf011b596782 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    1 -
 fs/ceph/metric.c     |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4912,7 +4912,6 @@ void ceph_mdsc_destroy(struct ceph_fs_cl
 
 	ceph_metric_destroy(&mdsc->metric);
 
-	flush_delayed_work(&mdsc->metric.delayed_work);
 	fsc->mdsc = NULL;
 	kfree(mdsc);
 	dout("mdsc_destroy %p done\n", mdsc);
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -302,6 +302,8 @@ void ceph_metric_destroy(struct ceph_cli
 	if (!m)
 		return;
 
+	cancel_delayed_work_sync(&m->delayed_work);
+
 	percpu_counter_destroy(&m->total_inodes);
 	percpu_counter_destroy(&m->opened_inodes);
 	percpu_counter_destroy(&m->i_caps_mis);
@@ -309,8 +311,6 @@ void ceph_metric_destroy(struct ceph_cli
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
 
-	cancel_delayed_work_sync(&m->delayed_work);
-
 	ceph_put_mds_session(m->session);
 }
 


