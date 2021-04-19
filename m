Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B55364BD0
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbhDSUqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242588AbhDSUpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0E65613C9;
        Mon, 19 Apr 2021 20:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865092;
        bh=AwWX+CIzR0IFXAElx5wFS9CUiBr0mwtGqFIb5LHiv0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmJ8rniHJ1t2arHx+IGED2MjnW3Ra62DhGrs9imvlEHSuvP9Cstk5promztNdtHs0
         +USzxgfFzifz2Gz99VTeYZHVxYuB3xA7fezN+3LARtboUzQmpl/OA2cEmEqISXlDOl
         aI5SjvpVJfFRBBk43CKxh5rQdSP0BnfT6pXk0ZqpxdCWqHR2vlLg2S+YVFRnQe6YUo
         J5EtYIfSqEk5pknA+ty+kfbsMaJ34dsD76BnYLoF1MWGyuIp7Vedgt52FpTldJxkEr
         wiLSFwbCVaItoDt+d7rYD7cpk3l8gr6NdWeQXv2QFs790PhDv8w08uUpOHPJYLUJtI
         QXVYBCGXlk2uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 20/21] gcov: clang: fix clang-11+ build
Date:   Mon, 19 Apr 2021 16:44:18 -0400
Message-Id: <20210419204420.6375-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204420.6375-1-sashal@kernel.org>
References: <20210419204420.6375-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 04c53de57cb6435738961dace8b1b71d3ecd3c39 ]

With clang-11+, the code is broken due to my kvmalloc() conversion
(which predated the clang-11 support code) leaving one vmalloc() in
place.  Fix that.

Link: https://lkml.kernel.org/r/20210412214210.6e1ecca9cdc5.I24459763acf0591d5e6b31c7e3a59890d802f79c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gcov/clang.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/gcov/clang.c b/kernel/gcov/clang.c
index c466c7fbdece..b81f2823630d 100644
--- a/kernel/gcov/clang.c
+++ b/kernel/gcov/clang.c
@@ -369,7 +369,7 @@ static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
 	INIT_LIST_HEAD(&fn_dup->head);
 
 	cv_size = fn->num_counters * sizeof(fn->counters[0]);
-	fn_dup->counters = vmalloc(cv_size);
+	fn_dup->counters = kvmalloc(cv_size, GFP_KERNEL);
 	if (!fn_dup->counters) {
 		kfree(fn_dup);
 		return NULL;
-- 
2.30.2

