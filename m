Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F8613E20C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgAPQxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730694AbgAPQxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA3E321582;
        Thu, 16 Jan 2020 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193592;
        bh=NbCpVGtI8d6CdI6OvixVfZhojY75tA9jR5b/KGp4u8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSdJis2gpgTI2CZXtPIbjplJGo3ulVExtCt7NPOML1itdm0WMOCyHGY4cjRIGvhDl
         +WyL3sQKyxqee1/BHf3AnpZcvw+vRNfBg6vS1bXjW1WJfbdobQQ1rMpeHomzDmqXeQ
         uYYT6yPAr1bUTTmIQO1/BjeWwXSPcw2K/wMWJPsw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hewenliang <hewenliang4@huawei.com>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 132/205] kselftests: cgroup: Avoid the reuse of fd after it is deallocated
Date:   Thu, 16 Jan 2020 11:41:47 -0500
Message-Id: <20200116164300.6705-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hewenliang <hewenliang4@huawei.com>

[ Upstream commit d671fa6393d6788fc65555d4643b71cb3a361f36 ]

It is necessary to set fd to -1 when inotify_add_watch() fails in
cg_prepare_for_wait. Otherwise the fd which has been closed in
cg_prepare_for_wait may be misused in other functions such as
cg_enter_and_wait_for_frozen and cg_freeze_wait.

Fixes: 5313bfe425c8 ("selftests: cgroup: add freezer controller self-tests")
Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_freezer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index 0fc1b6d4b0f9..62a27ab3c2f3 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -72,6 +72,7 @@ static int cg_prepare_for_wait(const char *cgroup)
 	if (ret == -1) {
 		debug("Error: inotify_add_watch() failed\n");
 		close(fd);
+		fd = -1;
 	}
 
 	return fd;
-- 
2.20.1

