Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EDF3C2441
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhGINVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232059AbhGINVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87DAF613B6;
        Fri,  9 Jul 2021 13:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836747;
        bh=CGm9XhMgrZ+2Q/0XN6jqh1tZS11gHciFs96Ptbuce3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CA2ZWAAScrWD0M9fWL5WOKmUkOcZJXrwjym/m6NxMWqOBlK324ewvcSyFs9MTTLjy
         BLzzysM8dMJXyCHs/sNVB7P1kbE8kLVa8uKxS6lCvTwNLyAI77iSchRtdVD0p7+JB5
         Kqs/LJnRIwOKazOixXwgtalRZrOXfxv2Rj8RaLw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/25] include/linux/mmdebug.h: make VM_WARN* non-rvals
Date:   Fri,  9 Jul 2021 15:18:32 +0200
Message-Id: <20210709131628.757242241@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@kernel.org>

[ Upstream commit 91241681c62a5a690c88eb2aca027f094125eaac ]

At present the construct

	if (VM_WARN(...))

will compile OK with CONFIG_DEBUG_VM=y and will fail with
CONFIG_DEBUG_VM=n.  The reason is that VM_{WARN,BUG}* have always been
special wrt.  {WARN/BUG}* and never generate any code when DEBUG_VM is
disabled.  So we cannot really use it in conditionals.

We considered changing things so that this construct works in both cases
but that might cause unwanted code generation with CONFIG_DEBUG_VM=n.
It is safer and simpler to make the build fail in both cases.

[akpm@linux-foundation.org: changelog]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmdebug.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 57b0030d3800..2ad72d2c8cc5 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -37,10 +37,10 @@ void dump_mm(const struct mm_struct *mm);
 			BUG();						\
 		}							\
 	} while (0)
-#define VM_WARN_ON(cond) WARN_ON(cond)
-#define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
-#define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
-#define VM_WARN(cond, format...) WARN(cond, format)
+#define VM_WARN_ON(cond) (void)WARN_ON(cond)
+#define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
+#define VM_WARN_ONCE(cond, format...) (void)WARN_ONCE(cond, format)
+#define VM_WARN(cond, format...) (void)WARN(cond, format)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
-- 
2.30.2



