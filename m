Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25DA1EAF12
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgFAS7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbgFAR5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFB57208A7;
        Mon,  1 Jun 2020 17:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034261;
        bh=ONTdpk3xlfrd0OQwHBCdfY+smB4CV44O5u7ylKVimdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJhcNGdr8YOeidQwYTVpw7aD4wQkT4PuUPRKb4gsXo791UMiHHuDCJIjPoPQpcP3b
         OTAlM77kUuBw4pX5qQ0GWhREMC0qTk/S7UWgcZ7fyQLsLP1AR0qdPnan/VMYUZQCj8
         j+QTLKigcI0rFvHrt1Cnr0Kp9SootTRTZk7VbYd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/61] gfs2: move privileged user check to gfs2_quota_lock_check
Date:   Mon,  1 Jun 2020 19:53:22 +0200
Message-Id: <20200601174014.647246562@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c2ca9566b764..fb9b1d702351 100644
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



