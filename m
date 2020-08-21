Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B913324DD1B
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgHURLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgHUQRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:17:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6780F22CF7;
        Fri, 21 Aug 2020 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026616;
        bh=v4s+MI7/SuEgVBe9uO88P02WbiyH4cpoaMFLoX+J+yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbDT8jGLQ4xwjtIF7kcNlJs9zyb6SC29q8TLYjYBUUM7gf0aZlxVYlmhZFiStIoOQ
         imw7LU//fyyrknMyFcBLZpGKJauaNg8ldZQ5FIzRZn8Af18ez+n6KEoojfVOiCr4L8
         ubxSCvVPF+wnDEkHQ2fT7rGWhPI6T3qdclHkaFxg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 56/61] ceph: fix potential mdsc use-after-free crash
Date:   Fri, 21 Aug 2020 12:15:40 -0400
Message-Id: <20200821161545.347622-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7c63abf5bea91..5e1d1070c8dfd 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4260,6 +4260,9 @@ static void delayed_work(struct work_struct *work)
 
 	dout("mdsc delayed_work\n");
 
+	if (mdsc->stopping)
+		return;
+
 	mutex_lock(&mdsc->mutex);
 	renew_interval = mdsc->mdsmap->m_session_timeout >> 2;
 	renew_caps = time_after_eq(jiffies, HZ*renew_interval +
@@ -4625,7 +4628,16 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
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

