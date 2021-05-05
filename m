Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144F0373FE7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhEEQcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234122AbhEEQc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1165613B4;
        Wed,  5 May 2021 16:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232292;
        bh=uvsdfGNEu6fT7UN+VgqEadQGzd7+VAPyiU9OSLHDgc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVKqz4N8i+cZVLKLgT9gESW1uXMTFxn+7nYLSw739J8vPxpuiqHc9o6Z9Iz5kWfpm
         7mlVbYuChILYZn9yDFugGw/G8v4d2UR5LbAAKpLrTiN12xdnUCCYeEveO0ApkKIrpU
         9IXvhxfGxOQhGfNyL4OhtgVL5JluthjEPnA5rVrjpXTzGeBGVjt24JpQMzblsQuY/9
         tI2SpGVxOyL2oOrUAAAxIIa5f/iD1LfqOOh5sWxOA3BqDSVve8t+OXTJ4QJD3spdRw
         3oaKDwLx96nely2uF5qLVnPNWVmnFwmhp2opib4hhlRwdgSA3h2ekFbbTrMOTgSBXo
         HCW57/3c4mK1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 005/116] fs: dlm: add errno handling to check callback
Date:   Wed,  5 May 2021 12:29:33 -0400
Message-Id: <20210505163125.3460440-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 8aa9540b49e0833feba75dbf4f45babadd0ed215 ]

This allows to return individual errno values for the config attribute
check callback instead of returning invalid argument only.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 582bffa09a66..8439610c266a 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -125,7 +125,7 @@ static ssize_t cluster_cluster_name_store(struct config_item *item,
 CONFIGFS_ATTR(cluster_, cluster_name);
 
 static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
-			   int *info_field, bool (*check_cb)(unsigned int x),
+			   int *info_field, int (*check_cb)(unsigned int x),
 			   const char *buf, size_t len)
 {
 	unsigned int x;
@@ -137,8 +137,11 @@ static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
 	if (rc)
 		return rc;
 
-	if (check_cb && check_cb(x))
-		return -EINVAL;
+	if (check_cb) {
+		rc = check_cb(x);
+		if (rc)
+			return rc;
+	}
 
 	*cl_field = x;
 	*info_field = x;
@@ -161,14 +164,20 @@ static ssize_t cluster_##name##_show(struct config_item *item, char *buf)     \
 }                                                                             \
 CONFIGFS_ATTR(cluster_, name);
 
-static bool dlm_check_zero(unsigned int x)
+static int dlm_check_zero(unsigned int x)
 {
-	return !x;
+	if (!x)
+		return -EINVAL;
+
+	return 0;
 }
 
-static bool dlm_check_buffer_size(unsigned int x)
+static int dlm_check_buffer_size(unsigned int x)
 {
-	return (x < DEFAULT_BUFFER_SIZE);
+	if (x < DEFAULT_BUFFER_SIZE)
+		return -EINVAL;
+
+	return 0;
 }
 
 CLUSTER_ATTR(tcp_port, dlm_check_zero);
-- 
2.30.2

