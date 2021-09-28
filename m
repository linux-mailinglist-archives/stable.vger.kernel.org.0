Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0E441A836
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239164AbhI1GCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239377AbhI1GAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B16AC60E9B;
        Tue, 28 Sep 2021 05:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808635;
        bh=jxfqHxqQwEtOlyX/LI/jnQF+Sx6R2yAlljBmVdzjwks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1OHOJE2p8QP9hoJM1rVo2ghI5UdM8ScuOfWbxHSuu53rbjGZauUpYFclY3HgGQQ/
         K5ijVlSMZqcy67B2hA3V9DrDtv+WeM+PoJYu7BTzis0YWSDrlYVCtFiTbSQwwNnm4m
         JNtxgw8GC9hJLtPoDgV0S1vbmkm9LhWwBBHgC14mUbg1NvbQYKK02N92z3zsf8mOas
         kzcaA2SuSViFExaop7dc4+LIdR3o3i9CG3/BHcYlkP3OGyTlgUMpZMDg8xawCQObfp
         4lqIrVQD+VrqohRcsuTtVISUUg1XIOZus+yGNZFRbtKs32MqSHyO+9hfOKh04ZtEO9
         9/yy/1L2kSUOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, changbin.du@intel.com
Subject: [PATCH AUTOSEL 5.4 11/11] tools/vm/page-types: remove dependency on opt_file for idle page tracking
Date:   Tue, 28 Sep 2021 01:57:04 -0400
Message-Id: <20210928055704.172814-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055704.172814-1-sashal@kernel.org>
References: <20210928055704.172814-1-sashal@kernel.org>
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
index 58c0eab71bca..d2e836b2d16b 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -1329,7 +1329,7 @@ int main(int argc, char *argv[])
 	if (opt_list && opt_list_mapcnt)
 		kpagecount_fd = checked_open(PROC_KPAGECOUNT, O_RDONLY);
 
-	if (opt_mark_idle && opt_file)
+	if (opt_mark_idle)
 		page_idle_fd = checked_open(SYS_KERNEL_MM_PAGE_IDLE, O_RDWR);
 
 	if (opt_list && opt_pid)
-- 
2.33.0

