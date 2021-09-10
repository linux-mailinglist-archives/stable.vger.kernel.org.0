Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18344063B3
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhIJAse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232791AbhIJAZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5482C60FC0;
        Fri, 10 Sep 2021 00:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233430;
        bh=UQToEynTTH0O8w4C8FPx+PcceWcTJYy1Ud3L+ztV8K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2TN5hFs2HK16qcdDtEhsg5jIOlfZBM2XgLwK9yJ65qsjm47x3+o4qriIeHBpCri6
         MyJwsSfIxg1zbVGAKIOSEqp0fI3hKQAavu95achA6p0K9Zj/xdFFhNEJ8ZGKFybyg4
         rCaZ7WSbchtPKjM+B3ReyRkcz3bt6DGfYLTCFS6hQ5wYK1gbN0gikGpIEWZ1zipmDz
         YYxr/FCF/9j+S7JLzZvmi/KrdAgy0KktRbMAANQWmt/KF0a+e5fj8CNHdzS4ZVbmfd
         gEqj2sIVcaquGYYENYYlHaZanp1r6eVGjvuYfhKLwdfVcObwKx8aELtIEbbGh+MFn4
         rxGthoJQls4ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.9 08/17] fs: dlm: fix return -EINTR on recovery stopped
Date:   Thu,  9 Sep 2021 20:23:29 -0400
Message-Id: <20210910002338.176677-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002338.176677-1-sashal@kernel.org>
References: <20210910002338.176677-1-sashal@kernel.org>
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
index a47ae99f7bcb..e8a5bdc39634 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -437,8 +437,10 @@ static int ping_members(struct dlm_ls *ls)
 
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
index 6859b4bf971e..206c8b29429a 100644
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

