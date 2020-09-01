Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C218C259B91
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgIAREF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbgIAPUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:20:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A9E0206EB;
        Tue,  1 Sep 2020 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973599;
        bh=1yPzK9t3GFlkQwdBVi7C7ZW6wopToJk1Y05XWH4ziTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIFwFnHN+RMAAjbm/qgq0Takxe2fUlqtymzSk3pKmWKmDB7VVRb6ZLDsmCpgPqKwh
         rc7ID21SufDpn/RIRi6NssKw5slOhFwqvYfXuFUkqraL3cU2x0nFjTAWH2v0JLuHFt
         Kw+QFJYyWutliVGWC3IJiCsS3SHkfnXovJlF6C4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/91] ceph: fix potential mdsc use-after-free crash
Date:   Tue,  1 Sep 2020 17:10:07 +0200
Message-Id: <20200901150929.790388450@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit fa9967734227b44acb1b6918033f9122dc7825b9 ]

Make sure the delayed work stopped before releasing the resources.

cancel_delayed_work_sync() will only guarantee that the work finishes
executing if the work is already in the ->worklist.  That means after
the cancel_delayed_work_sync() returns, it will leave the work requeued
if it was rearmed at the end. That can lead to a use after free once the
work struct is freed.

Fix it by flushing the delayed work instead of trying to cancel it, and
ensure that the work doesn't rearm if the mdsc is stopping.

URL: https://tracker.ceph.com/issues/46293
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f36ddfea4997e..06109314d93c8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3518,6 +3518,9 @@ static void delayed_work(struct work_struct *work)
 	dout("mdsc delayed_work\n");
 	ceph_check_delayed_caps(mdsc);
 
+	if (mdsc->stopping)
+		return;
+
 	mutex_lock(&mdsc->mutex);
 	renew_interval = mdsc->mdsmap->m_session_timeout >> 2;
 	renew_caps = time_after_eq(jiffies, HZ*renew_interval +
@@ -3851,7 +3854,16 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 {
 	dout("stop\n");
-	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
+	/*
+	 * Make sure the delayed work stopped before releasing
+	 * the resources.
+	 *
+	 * Because the cancel_delayed_work_sync() will only
+	 * guarantee that the work finishes executing. But the
+	 * delayed work will re-arm itself again after that.
+	 */
+	flush_delayed_work(&mdsc->delayed_work);
+
 	if (mdsc->mdsmap)
 		ceph_mdsmap_destroy(mdsc->mdsmap);
 	kfree(mdsc->sessions);
-- 
2.25.1



