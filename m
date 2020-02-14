Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341EA15F1EC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388172AbgBNSEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731159AbgBNPzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B411D222C4;
        Fri, 14 Feb 2020 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695735;
        bh=fKgzkNovUzgTf8pbQsgdrFyVGaFJHfBMFNKzV/qWmos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSlAkNBgpHNkXael2tglTgn6xHhTgMTiohT2NNYUa49Prv75FUFW0mN6bCkLZkQv8
         8ECiA6ZHbXZXYIGzRwKAzaJs42dzgenAJqqoyJP2BxiyAv4yYd1eI9Si4WYzhMkBBv
         u6DTAv877xOaEPFv+ua5TmzF+lQQpwx8OzLogrfs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 309/542] selftests: Uninitialized variable in test_cgcore_proc_migration()
Date:   Fri, 14 Feb 2020 10:45:01 -0500
Message-Id: <20200214154854.6746-309-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 192c197cbca599321de95a4cf15c2fa0681140d3 ]

The "c_threads" variable is used in the error handling code before it
has been initialized

Fixes: 11318989c381 ("selftests: cgroup: Add task migration tests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index c5ca669feb2bd..e19ce940cd6a2 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -369,7 +369,7 @@ static void *dummy_thread_fn(void *arg)
 static int test_cgcore_proc_migration(const char *root)
 {
 	int ret = KSFT_FAIL;
-	int t, c_threads, n_threads = 13;
+	int t, c_threads = 0, n_threads = 13;
 	char *src = NULL, *dst = NULL;
 	pthread_t threads[n_threads];
 
-- 
2.20.1

