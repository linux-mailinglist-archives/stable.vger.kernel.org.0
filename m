Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46606374398
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhEEQvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236124AbhEEQrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E7F061948;
        Wed,  5 May 2021 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232613;
        bh=um87pZxXXqt+kHc2F/4E0dxQC1yETfmXXG1blnyBF7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKbADiZaWwHlZ65O6VxZ6oFGS4+DaxwuA+3bR1csvRbpW0vvP1UmBssGYQd51qOlv
         p90TfrEQQNtQVpUQQQH9xc7knkz3cRifLjnw0DoR16dpKnjSAnkEAIBslz63n+bvbV
         ZOFg7iiCNvzCQ/JrwbrkMAdJGrewA9AKW23ftkLgMgQkidr5q5jK3NiT1+Hlfywm+X
         kvYfePVJyYO4YOXMSVZU7Fg3SQcVqIzlOyUczCcaX8FsVO3355+/EfKqOWlV9f1Yh8
         xMdRxm+HHVFjWKPkyo1rMgHixAetk5onHE6Xw3ei3cb4aKJXkZMsd7A8wKeE8qAL/L
         TlF5CqS5imsZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 03/85] fs: dlm: add errno handling to check callback
Date:   Wed,  5 May 2021 12:35:26 -0400
Message-Id: <20210505163648.3462507-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 49c5f9407098..73e6643903af 100644
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

