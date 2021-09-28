Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D36741A7E0
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239143AbhI1F7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239195AbhI1F6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4C20611CA;
        Tue, 28 Sep 2021 05:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808603;
        bh=URTIX7csHgSfr/PXlRPi6sf11mamz8TaxWjqo7QXMAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIWaEYZTOdGTTnMBy7yAOj6bx+yOl06sSnnLfnXspkYotAhZ68vW975MJlOVE+szX
         rlF0h7QCt+9588dh9kawjQz7RKYntIaJAga67ym1/3GTAhuCtXPIXvqEpG8alfDRmX
         hqhpU4qB+KblD4vphi6NV2lUCVcHZxbviH6aUjcj9CeYTKWmju4NiRJIusyuOm5o7o
         F580ETeMaHvS8tAIeS/PesOuxDeg7/RSt3Y2Vrzi97dYxM4kJ1Pfp720yxnQA6kfti
         jQ4uCHVZDLVDv9IBy3G9hVCPC14YiJUz7sjWRY/zcpucBhRReKtu/KuqplyBaDSC0K
         Ivt99lXAiYGYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, changbin.du@intel.com
Subject: [PATCH AUTOSEL 5.14 39/40] tools/vm/page-types: remove dependency on opt_file for idle page tracking
Date:   Tue, 28 Sep 2021 01:55:23 -0400
Message-Id: <20210928055524.172051-39-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
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

