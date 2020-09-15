Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE2E26B55C
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgIOXmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F366323C1A;
        Tue, 15 Sep 2020 14:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179913;
        bh=BFTTLcTWONJd8p/WOaJbTTYUGOs6+qxRFrZ5EOhjsa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfxInEdTGful1wSV+e08/TQFlLw2O/cPv3BHHMBXrtfKSdAVuH3CmuuhIhtONG7wy
         qBYWhnpFAr3nQwaU1VxgOTEG6FuD64/cFHu+Z8uqnfOITjDbCWtEM4CAzKeUFeQq8a
         dtozQBRL0Y5Gmj33i7lSto32qKbjVTFN1NJRrrUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 035/177] Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled"
Date:   Tue, 15 Sep 2020 16:11:46 +0200
Message-Id: <20200915140655.318806860@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 318af7b80b6a6751520cf2b71edb8c45abb9d9d8 ]

Use of the new -flive-patching flag was introduced with the following
commit:

  43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")

This flag has several drawbacks:

- It disables some optimizations, so it can have a negative effect on
  performance.

- According to the GCC documentation it's not compatible with LTO, which
  will become a compatibility issue as LTO support gets upstreamed in
  the kernel.

- It was intended to be used for source-based patch generation tooling,
  as opposed to binary-based patch generation tooling (e.g.,
  kpatch-build).  It probably should have at least been behind a
  separate config option so as not to negatively affect other livepatch
  users.

- Clang doesn't have the flag, so as far as I can tell, this method of
  generating patches is incompatible with Clang, which like LTO is
  becoming more mainstream.

- It breaks GCC's implicit noreturn detection for local functions.  This
  is the cause of several "unreachable instruction" objtool warnings.

- The broken noreturn detection is an obvious GCC regression, but we
  haven't yet gotten GCC developers to acknowledge that, which doesn't
  inspire confidence in their willingness to keep the feature working as
  optimizations are added or changed going forward.

- While there *is* a distro which relies on this flag for their distro
  livepatch module builds, there's not a publicly documented way to
  create safe livepatch modules with it.  Its use seems to be based on
  tribal knowledge.  It serves no benefit to those who don't know how to
  use it.

  (In fact, I believe the current livepatch documentation and samples
  are misleading and dangerous, and should be corrected.  Or at least
  amended with a disclaimer.  But I don't feel qualified to make such
  changes.)

Also, we have an idea for using objtool to detect function changes,
which could potentially obsolete the need for this flag anyway.

At this point the flag has no benefits for upstream which would
counteract the above drawbacks.  Revert it until it becomes more ready.

This reverts commit 43bd3a95c98e1a86b8b55d97f745c224ecff02b9.

Fixes: 43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Makefile b/Makefile
index 36eab48d1d4a6..3299cc45c1dd0 100644
--- a/Makefile
+++ b/Makefile
@@ -876,10 +876,6 @@ KBUILD_CFLAGS_KERNEL += -ffunction-sections -fdata-sections
 LDFLAGS_vmlinux += --gc-sections
 endif
 
-ifdef CONFIG_LIVEPATCH
-KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
-endif
-
 ifdef CONFIG_SHADOW_CALL_STACK
 CC_FLAGS_SCS	:= -fsanitize=shadow-call-stack
 KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
-- 
2.25.1



