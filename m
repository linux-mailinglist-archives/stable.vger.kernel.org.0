Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7EE409FCB
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245145AbhIMWfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347811AbhIMWfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CCA6112D;
        Mon, 13 Sep 2021 22:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572434;
        bh=tptuobY4veaU1Xj5h+terfJeMBpui5AQbXtKgviqD2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hzqx+tw45eXMZ6WFvs5XuERE2FCIJVjqZ7PUYjXP/AFzNbNNnon1Ofn0Gio36hr3m
         g02MhHOzMQyNOVZt9mE6Fvg4DxeTJY4hC9z2tUYYanpbqSzrojys6zRK755GakMPY9
         21yw/epSdq3eApNZVNNgAcM6xIgmD8cy+qXHYk/mXPdSCV+bkzaSoQ0UWu/6MC8W65
         5JPS1SKTZ6SpteLMKmfSpNd+b0HVZASh3hYYpVXjz7HrXfEPWEPmTs4xXlICXhMTDl
         nC20f7cVod98PosPvbap7EH4IY8sdFWWfCd4bRFkl0FeuTvd45iT4a4QcfGS503BwZ
         93BpdFsVpcblA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 11/25] ceph: fix memory leak on decode error in ceph_handle_caps
Date:   Mon, 13 Sep 2021 18:33:25 -0400
Message-Id: <20210913223339.435347-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 2ad32cf09bd28a21e6ad1595355a023ed631b529 ]

If we hit a decoding error late in the frame, then we might exit the
function without putting the pool_ns string. Ensure that we always put
that reference on the way out of the function.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 39db97f149b9..c2d654156783 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4134,8 +4134,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 done:
 	mutex_unlock(&session->s_mutex);
 done_unlocked:
-	ceph_put_string(extra_info.pool_ns);
 	iput(inode);
+out:
+	ceph_put_string(extra_info.pool_ns);
 	return;
 
 flush_cap_releases:
@@ -4150,7 +4151,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 bad:
 	pr_err("ceph_handle_caps: corrupt message\n");
 	ceph_msg_dump(msg);
-	return;
+	goto out;
 }
 
 /*
-- 
2.30.2

