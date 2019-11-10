Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E32F6452
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfKJC6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729382AbfKJC4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82C582256E;
        Sun, 10 Nov 2019 02:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354119;
        bh=Y73+dY1Y0k2XuM4+cKQsdic8Xpu6IH+WkIG2UhOnRI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0JtwvucN9trG3O7QaeDTHJlk/2x0aVsqN56Zhj7y6YgPdxewMnnFYwFxkKQO1iwr
         gpaq9GVb2H+M2MEfe01+v7zN/7VwR5a3VANx/ii+aqCm6rS5CDdraLgA7cmRu6LS1t
         3xo8G/BJ7XmnOEqCuD8i9+kn0QJIGRnOO+bK2Znw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 107/109] fuse: use READ_ONCE on congestion_threshold and max_background
Date:   Sat,  9 Nov 2019 21:45:39 -0500
Message-Id: <20191110024541.31567-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill Tkhai <ktkhai@virtuozzo.com>

[ Upstream commit 2a23f2b8adbe4bd584f936f7ac17a99750eed9d7 ]

Since they are of unsigned int type, it's allowed to read them
unlocked during reporting to userspace. Let's underline this fact
with READ_ONCE() macroses.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 5be0339dcceb2..42bed87dd5ea9 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -107,7 +107,7 @@ static ssize_t fuse_conn_max_background_read(struct file *file,
 	if (!fc)
 		return 0;
 
-	val = fc->max_background;
+	val = READ_ONCE(fc->max_background);
 	fuse_conn_put(fc);
 
 	return fuse_conn_limit_read(file, buf, len, ppos, val);
@@ -144,7 +144,7 @@ static ssize_t fuse_conn_congestion_threshold_read(struct file *file,
 	if (!fc)
 		return 0;
 
-	val = fc->congestion_threshold;
+	val = READ_ONCE(fc->congestion_threshold);
 	fuse_conn_put(fc);
 
 	return fuse_conn_limit_read(file, buf, len, ppos, val);
-- 
2.20.1

