Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8A641A80B
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbhI1GBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239424AbhI1F7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0522F6137D;
        Tue, 28 Sep 2021 05:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808624;
        bh=URTIX7csHgSfr/PXlRPi6sf11mamz8TaxWjqo7QXMAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/V43on3xHpWqxeMNWPGnaLCawspZRS8vPae/0UdDPrImkPfAuMHkm8lhlE0ii6M/
         2mZQf3CgLRt7KCJNpb4dTDlCiIMb3u7ddYmGdzu3U8660+4Jyp6b+SlN3qaRI2JVV8
         qG81ZVB9b1xY3mvUtjg7F+eQN2bHrCuRF5m7OAggypBXI9wEtFp20ZaepoOgLAG29J
         N+ejm2cL9V8B0DJ41Glds+kNT4KhvnE2JnQNMxbZ5LaBPatSA1ZibPq37zeoKsNM5B
         l3ZaQ2AQjsuiFIMdYr44JLqWec0UY5chzhARV5t7LEa2ztBDm7iSQ4llOFC2TyNch2
         urQ0SEsd7O6ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, changbin.du@intel.com
Subject: [PATCH AUTOSEL 5.10 23/23] tools/vm/page-types: remove dependency on opt_file for idle page tracking
Date:   Tue, 28 Sep 2021 01:56:44 -0400
Message-Id: <20210928055645.172544-23-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

[ Upstream commit ebaeab2fe87987cef28eb5ab174c42cd28594387 ]

Idle page tracking can also be used for process address space, not only
file mappings.

Without this change, using with '-i' option for process address space
encounters below errors reported.

  $ sudo ./page-types -p $(pidof bash) -i
  mark page idle: Bad file descriptor
  mark page idle: Bad file descriptor
  mark page idle: Bad file descriptor
  mark page idle: Bad file descriptor
  ...

Link: https://lkml.kernel.org/r/20210917032826.10669-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/vm/page-types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 0517c744b04e..f62f10c988db 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -1331,7 +1331,7 @@ int main(int argc, char *argv[])
 	if (opt_list && opt_list_mapcnt)
 		kpagecount_fd = checked_open(PROC_KPAGECOUNT, O_RDONLY);
 
-	if (opt_mark_idle && opt_file)
+	if (opt_mark_idle)
 		page_idle_fd = checked_open(SYS_KERNEL_MM_PAGE_IDLE, O_RDWR);
 
 	if (opt_list && opt_pid)
-- 
2.33.0

