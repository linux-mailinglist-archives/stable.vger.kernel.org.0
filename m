Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF787416ECF
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 11:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244807AbhIXJYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 05:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244547AbhIXJYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 05:24:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1ADC60FDC;
        Fri, 24 Sep 2021 09:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632475362;
        bh=M8k35huH9cuh9vxkjeOj4RBk0Xv73LZFASaXIBx+e28=;
        h=Subject:To:Cc:From:Date:From;
        b=wWzeI5oSmgXzbYb6llWN1aeFchRmuYfGRMZ8BhH/mvgCvL+vesWcNkHJUBJuZ+y7T
         6m6f54k23wejFrbdbHpBA/PQVQQXfGd4Jg3rCbQm910Tsi5YWqb2vlLHxyoqW+4Wlf
         WCtZTNKQfhHKXtfRiKCc7O4KpRq2SK2iK8mxeXuE=
Subject: FAILED: patch "[PATCH] ceph: cancel delayed work instead of flushing on mdsc" failed to apply to 5.10-stable tree
To:     jlayton@kernel.org, idryomov@gmail.com, xiubli@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 11:22:39 +0200
Message-ID: <16324753594142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b4002173b7989588b6feaefc42edaf011b596782 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 27 Jul 2021 15:47:12 -0400
Subject: [PATCH] ceph: cancel delayed work instead of flushing on mdsc
 teardown

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

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d98a3eda0d4c..85934091e024 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4954,7 +4954,6 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_metric_destroy(&mdsc->metric);
 
-	flush_delayed_work(&mdsc->metric.delayed_work);
 	fsc->mdsc = NULL;
 	kfree(mdsc);
 	dout("mdsc_destroy %p done\n", mdsc);
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 5ac151eb0d49..04d5df29bbbf 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -302,6 +302,8 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
+	cancel_delayed_work_sync(&m->delayed_work);
+
 	percpu_counter_destroy(&m->total_inodes);
 	percpu_counter_destroy(&m->opened_inodes);
 	percpu_counter_destroy(&m->i_caps_mis);
@@ -309,8 +311,6 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
 
-	cancel_delayed_work_sync(&m->delayed_work);
-
 	ceph_put_mds_session(m->session);
 }
 

