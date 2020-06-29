Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185D820D984
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387813AbgF2TsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387783AbgF2Tkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B5B248F0;
        Mon, 29 Jun 2020 15:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444446;
        bh=Ek0ULgVy39jBD8SSkFxugE25V40WPVHosBEnKWbkujI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrx5XoAmaBpirnA3kfGVDWs4BOgVCRXlW8Yr/edT00eC/Q8jbgdhUDOa0V5U2JId6
         LzH2IMje+ryDtHiCTw5ufhS9TRtX7+RG1xPO7ysMyX2wjsLdrSCt5ygCWaH/viTMLE
         5ysgdbVy4ftD+63hdA9qNqpBZTLOMyyMtPCc8xjw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/178] test_objagg: Fix potential memory leak in error handling
Date:   Mon, 29 Jun 2020 11:24:30 -0400
Message-Id: <20200629152523.2494198-126-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit a6379f0ad6375a707e915518ecd5c2270afcd395 ]

In case of failure of check_expect_hints_stats(), the resources
allocated by objagg_hints_get should be freed. The patch fixes
this issue.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_objagg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_objagg.c b/lib/test_objagg.c
index 72c1abfa154dc..da137939a4100 100644
--- a/lib/test_objagg.c
+++ b/lib/test_objagg.c
@@ -979,10 +979,10 @@ static int test_hints_case(const struct hints_case *hints_case)
 err_world2_obj_get:
 	for (i--; i >= 0; i--)
 		world_obj_put(&world2, objagg, hints_case->key_ids[i]);
-	objagg_hints_put(hints);
-	objagg_destroy(objagg2);
 	i = hints_case->key_ids_count;
+	objagg_destroy(objagg2);
 err_check_expect_hints_stats:
+	objagg_hints_put(hints);
 err_hints_get:
 err_check_expect_stats:
 err_world_obj_get:
-- 
2.25.1

