Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02FE3741E7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhEEQmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235558AbhEEQjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:39:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E21726162A;
        Wed,  5 May 2021 16:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232461;
        bh=uvsdfGNEu6fT7UN+VgqEadQGzd7+VAPyiU9OSLHDgc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A55MNqz5Z1Zfs4GjeBZjy/XKbK7hBr9PBnBqJzkMQ85lZIZqNSHGf3Tba6KbJVZ/w
         avchdgBR9UrO3nJxKpEua16EDPfXiHwONTPh5FzoWCtTB0/EMBmBUMv4HTi2FN6tYA
         QfOP5cK1PB5OZhLM3GJpjpBPzHPDMrEJ45QLLfkdbWcXjkkHMaqi0A+XjJ5wRryXe6
         ynxQKJL2eNmWncqWKZLioDrimSO+y49AXJcyv0UD6zQGm47fE/lgT4W4bxYnj/sc5e
         nZxxaqUK0IG1NHYDaUyATm2czt2rv5D+l1iSv4XKrSecunYaD4fWb8dBX4j0LP3elL
         C34Ahh62s5b4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.11 005/104] fs: dlm: add errno handling to check callback
Date:   Wed,  5 May 2021 12:32:34 -0400
Message-Id: <20210505163413.3461611-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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

