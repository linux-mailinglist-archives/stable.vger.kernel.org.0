Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609091DEA49
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgEVOxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731108AbgEVOvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63822224A;
        Fri, 22 May 2020 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159109;
        bh=vcXZuq2+yMbWGoBhZSGMws23faRimjlbcAkjvX3KKms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvHPoESF1eVQpQmOjLcoVjPIt9Xgp7HUl9lRRmwqfs3mMFkbbIiXwT6+xS9NXXf74
         RE7cCtoPfk2iA8gQ0cDJZDaWGOL2Ro95uUB+7DNYgXI8mTXePXveJZ+0suaIfk5SxK
         wmT4LzLRlXoksjYjRG5NzqXBeEJZwlLuL9zgkzpw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 06/13] gfs2: move privileged user check to gfs2_quota_lock_check
Date:   Fri, 22 May 2020 10:51:35 -0400
Message-Id: <20200522145142.435086-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145142.435086-1-sashal@kernel.org>
References: <20200522145142.435086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 4ed0c30811cb4d30ef89850b787a53a84d5d2bcb ]

Before this patch, function gfs2_quota_lock checked if it was called
from a privileged user, and if so, it bypassed the quota check:
superuser can operate outside the quotas.
That's the wrong place for the check because the lock/unlock functions
are separate from the lock_check function, and you can do lock and
unlock without actually checking the quotas.

This patch moves the check to gfs2_quota_lock_check.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 3 +--
 fs/gfs2/quota.h | 3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index e700fb162664..a833e2e07167 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1039,8 +1039,7 @@ int gfs2_quota_lock(struct gfs2_inode *ip, kuid_t uid, kgid_t gid)
 	u32 x;
 	int error = 0;
 
-	if (capable(CAP_SYS_RESOURCE) ||
-	    sdp->sd_args.ar_quota != GFS2_QUOTA_ON)
+	if (sdp->sd_args.ar_quota != GFS2_QUOTA_ON)
 		return 0;
 
 	error = gfs2_quota_hold(ip, uid, gid);
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 836f29480be6..e3a6e2404d11 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -47,7 +47,8 @@ static inline int gfs2_quota_lock_check(struct gfs2_inode *ip,
 	int ret;
 
 	ap->allowed = UINT_MAX; /* Assume we are permitted a whole lot */
-	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
+	if (capable(CAP_SYS_RESOURCE) ||
+	    sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
 		return 0;
 	ret = gfs2_quota_lock(ip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (ret)
-- 
2.25.1

