Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEF741A879
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbhI1GFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239324AbhI1GA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:00:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91984613A2;
        Tue, 28 Sep 2021 05:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808645;
        bh=vItgBdU7Zpij+YFPmETvQ4GYWk6GNPFn4Vv0M4mh/zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQayqJ2xPYInnhxjCiN9GiS0VbV+FbLvhKwqQNjRJcbQ0VTEjogPlwJ9I2GgvEP0u
         aLD0zICi+dt5LyV52yxMKKhXq7ZqjSuU3Eb2Hhar3MKq899VUWmNm1BWrd0RLbHvt7
         eo9l5Eax7CqTG97VAkZxrD3UXx2ttX7HRNQVNOTYFzg+OxFNK7XFFyRLYN+2ut+Zaf
         Rn6EpbenfsAAp9K6Zy4ASuyt/mW3wlMnKi7hv11WmJ/U2C3mQD4u5ppOLROPF7srbf
         V2JK2bMxIeY934pEmwl9fkgZpZZ7cZqQNn4tw5QBjhqvfBNbIcWHl5HLoDzpPiniZV
         7F78rCfdfDMJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, changbin.du@intel.com
Subject: [PATCH AUTOSEL 4.19 10/10] tools/vm/page-types: remove dependency on opt_file for idle page tracking
Date:   Tue, 28 Sep 2021 01:57:16 -0400
Message-Id: <20210928055716.172951-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055716.172951-1-sashal@kernel.org>
References: <20210928055716.172951-1-sashal@kernel.org>
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
index 1ff3a6c0367b..89063b967b6b 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -1341,7 +1341,7 @@ int main(int argc, char *argv[])
 	if (opt_list && opt_list_mapcnt)
 		kpagecount_fd = checked_open(PROC_KPAGECOUNT, O_RDONLY);
 
-	if (opt_mark_idle && opt_file)
+	if (opt_mark_idle)
 		page_idle_fd = checked_open(SYS_KERNEL_MM_PAGE_IDLE, O_RDWR);
 
 	if (opt_list && opt_pid)
-- 
2.33.0

