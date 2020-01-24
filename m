Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3567147B42
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732558AbgAXJmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbgAXJmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:42:05 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B531A20718;
        Fri, 24 Jan 2020 09:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858925;
        bh=Q05n3pFYLWclM3W5I8rQAaZ1i3N0gOCqBQNfC7Nji6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Za67siOWaQyQpydVSF1M4giRSiv7I8g9bViduhhWGrHdSXse6/erYu0LYamA4CTHm
         YJvBj1Sya6sao89MahkZV4itvwBC4uwAvaO8FjqrXWyBbM0XeJNmJUXkD7VmUiz3Dy
         cZxDwQALOI1cQX/yrxF8QRx/Yj28lbIFJz75rqcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hewenliang <hewenliang4@huawei.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/102] kselftests: cgroup: Avoid the reuse of fd after it is deallocated
Date:   Fri, 24 Jan 2020 10:31:22 +0100
Message-Id: <20200124092818.894685869@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0fc1b6d4b0f9c..62a27ab3c2f3e 100644
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



