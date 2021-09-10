Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216CC406370
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhIJArs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234681AbhIJAYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBC9960FDA;
        Fri, 10 Sep 2021 00:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233370;
        bh=+bbSYnYh3eWZeyqcYc6ojoVXcgufeRBdHKCtNwPluPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eg4ubBrIAXX79ZqkLJKHJUTIV1HZXZwigYbA6Iv5lrPBAE4oFBt4O+/uZeREDlGAL
         WIkv30BRso3IqNDWnXWfvFHa+mr0xlLQmsOg9klS0WJw/a8iaB69Lf5I8nc06De1lM
         cC9dRzWmaRidsULDb8QBk1Atg/H4lRnXoIxYo89qwUp+HH0CI0QPj88cL58kJlWEO4
         Lgv/JDpVjbENlHrtfOx/B7mpZhZbWZqwzjhdC942euZeHYZPsBMnWPXROw9G3OaLaG
         erQycgWxP1yJ1H7ifI0GFxpZ9vmoNu/HG5Oy5brW9MWLM8zSo1N+ZOaq40sG5gtgZ4
         fsjd5Jpbr6ktA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 12/25] fs: dlm: fix return -EINTR on recovery stopped
Date:   Thu,  9 Sep 2021 20:22:20 -0400
Message-Id: <20210910002234.176125-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002234.176125-1-sashal@kernel.org>
References: <20210910002234.176125-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit aee742c9928ab4f5f4e0b00f41fb2d2cffae179e ]

This patch will return -EINTR instead of 1 if recovery is stopped. In
case of ping_members() the return value will be checked if the error is
-EINTR for signaling another recovery was triggered and the whole
recovery process will come to a clean end to process the next one.
Returning 1 will abort the recovery process and can leave the recovery
in a broken state.

It was reported with the following kernel log message attached and a gfs2
mount stopped working:

"dlm: bobvirt1: dlm_recover_members error 1"

whereas 1 was returned because of a conversion of "dlm_recovery_stopped()"
to an errno was missing which this patch will introduce. While on it all
other possible missing errno conversions at other places were added as
they are done as in other places.

It might be worth to check the error case at this recovery level,
because some of the functionality also returns -ENOBUFS and check why
recovery ends in a broken state. However this will fix the issue if
another recovery was triggered at some points of recovery handling.

Reported-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/dir.c      | 4 +++-
 fs/dlm/member.c   | 4 +++-
 fs/dlm/recoverd.c | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index d975851a7e1e..c4de04ef8b01 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -87,8 +87,10 @@ int dlm_recover_directory(struct dlm_ls *ls)
 		for (;;) {
 			int left;
 			error = dlm_recovery_stopped(ls);
-			if (error)
+			if (error) {
+				error = -EINTR;
 				goto out_free;
+			}
 
 			error = dlm_rcom_names(ls, memb->nodeid,
 					       last_name, last_len);
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 0bc43b35d2c5..30f73cea20cc 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -435,8 +435,10 @@ static int ping_members(struct dlm_ls *ls)
 
 	list_for_each_entry(memb, &ls->ls_nodes, list) {
 		error = dlm_recovery_stopped(ls);
-		if (error)
+		if (error) {
+			error = -EINTR;
 			break;
+		}
 		error = dlm_rcom_status(ls, memb->nodeid, 0);
 		if (error)
 			break;
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 6f4e1d42d733..87c7de67ea9e 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -127,8 +127,10 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 	dlm_recover_waiters_pre(ls);
 
 	error = dlm_recovery_stopped(ls);
-	if (error)
+	if (error) {
+		error = -EINTR;
 		goto fail;
+	}
 
 	if (neg || dlm_no_directory(ls)) {
 		/*
-- 
2.30.2

