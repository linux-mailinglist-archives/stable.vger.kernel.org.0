Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF96382E5D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237786AbhEQOGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237802AbhEQOGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:06:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CCD5611EE;
        Mon, 17 May 2021 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260292;
        bh=uvsdfGNEu6fT7UN+VgqEadQGzd7+VAPyiU9OSLHDgc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuHY+cqS6C93koDDpmytlyOXkz7AtsSBQA+lSuM/kD3TzoGQcQBs6xB3072L1L6a2
         W4a+vxMmvfHIyriLtvEry07w4TQENOQHFOnozec/ICFRuz5DG/8r7UdyIEGO+/TOyw
         yvl2dc9MSGPZ5pF2ZFSDWDzMlgITg4XXf3skZPvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 016/363] fs: dlm: add errno handling to check callback
Date:   Mon, 17 May 2021 15:58:02 +0200
Message-Id: <20210517140303.125614758@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



