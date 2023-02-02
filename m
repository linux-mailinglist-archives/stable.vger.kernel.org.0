Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E8668755F
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjBBFpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjBBFpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:45:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F6A37B46;
        Wed,  1 Feb 2023 21:45:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB5BD61783;
        Thu,  2 Feb 2023 05:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CC1C433D2;
        Thu,  2 Feb 2023 05:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675316726;
        bh=gTyWdbMQBkC6bj2L7uRC+LIn00TYkfea/W2V8Ev9Cfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXBa8TdiOhzgbCB7WRvrT5ADcJIuaKB97mPE95Zc7EPVXvPq+wcLlbwa4s8opZRnP
         BRL8M7CLTUpwAKPtU3NuqTMjplzmn9RGqxVEb7RrGv7JsMT6DFngJgKVscCwITjxBi
         U2QbvmFVihP+Lh9okXkpQy4Zy675b+hLY85XKIuoBIsFHBrK/2rX0nAj+lbjTOWFHI
         TrGby2TffvqjR/RF6FDnMLvOmpPYXWn/Z/bgxoYeh5UnAhMOTXP+CAoqq3m0122cit
         28Id6Z4mnSOzjct6pk3h2G2vKvR+nidq/zs6DuzuSzFJ+PLPW/NIOCXRW5CwQLlwGF
         /YCtWwuVD4TEQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Huang Ying <ying.huang@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org
Subject: [PATCH 4.14 11/16] exit: Allow oops_limit to be disabled
Date:   Wed,  1 Feb 2023 21:44:01 -0800
Message-Id: <20230202054406.221721-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202054406.221721-1-ebiggers@kernel.org>
References: <20230202054406.221721-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit de92f65719cd672f4b48397540b9f9eff67eca40 upstream.

In preparation for keeping oops_limit logic in sync with warn_limit,
have oops_limit == 0 disable checking the Oops counter.

Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/sysctl/kernel.txt | 5 +++--
 kernel/exit.c                   | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 7b04c616c5901..b6124a4475fb7 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -519,8 +519,9 @@ scanned for a given scan.
 oops_limit:
 
 Number of kernel oopses after which the kernel should panic when
-``panic_on_oops`` is not set. Setting this to 0 or 1 has the same effect
-as setting ``panic_on_oops=1``.
+``panic_on_oops`` is not set. Setting this to 0 disables checking
+the count. Setting this to  1 has the same effect as setting
+``panic_on_oops=1``. The default value is 10000.
 
 ==============================================================
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 138b110bf83a1..73103e008a627 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -984,7 +984,7 @@ void __noreturn make_task_dead(int signr)
 	 * To make sure this can't happen, place an upper bound on how often the
 	 * kernel may oops without panic().
 	 */
-	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit))
+	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit) && oops_limit)
 		panic("Oopsed too often (kernel.oops_limit is %d)", oops_limit);
 
 	do_exit(signr);
-- 
2.39.1

