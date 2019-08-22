Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C0899B3C
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391673AbfHVRW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391660AbfHVRWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:55 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC66B21743;
        Thu, 22 Aug 2019 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494573;
        bh=rKxAOf5Hdq8+ipxjfzKWw6YjIfD2PngFsw+PKWG2Lmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ79RHnRoATvxLTjaZl+8tUy54VP4ArJqG0hdncw3XeHJuqScuIHiCLgAzVkS/zhd
         CmOjSBwb6Hyx3sJh8MxGSc7O1b96G/dzXwp3JmL3f+41cSiKUd4uRridsoUQ+XB3mT
         +ELvXcAx3IEmKN1aNfPyvVIPt38XUDHCRbibrQPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Jessica Yu <jeyu@kernel.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 64/78] include/linux/module.h: copy __init/__exit attrs to init/cleanup_module
Date:   Thu, 22 Aug 2019 10:19:08 -0700
Message-Id: <20190822171833.885876865@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a6e60d84989fa0e91db7f236eda40453b0e44afa ]

The upcoming GCC 9 release extends the -Wmissing-attributes warnings
(enabled by -Wall) to C and aliases: it warns when particular function
attributes are missing in the aliases but not in their target.

In particular, it triggers for all the init/cleanup_module
aliases in the kernel (defined by the module_init/exit macros),
ending up being very noisy.

These aliases point to the __init/__exit functions of a module,
which are defined as __cold (among other attributes). However,
the aliases themselves do not have the __cold attribute.

Since the compiler behaves differently when compiling a __cold
function as well as when compiling paths leading to calls
to __cold functions, the warning is trying to point out
the possibly-forgotten attribute in the alias.

In order to keep the warning enabled, we decided to silence
this case. Ideally, we would mark the aliases directly
as __init/__exit. However, there are currently around 132 modules
in the kernel which are missing __init/__exit in their init/cleanup
functions (either because they are missing, or for other reasons,
e.g. the functions being called from somewhere else); and
a section mismatch is a hard error.

A conservative alternative was to mark the aliases as __cold only.
However, since we would like to eventually enforce __init/__exit
to be always marked,  we chose to use the new __copy function
attribute (introduced by GCC 9 as well to deal with this).
With it, we copy the attributes used by the target functions
into the aliases. This way, functions that were not marked
as __init/__exit won't have their aliases marked either,
and therefore there won't be a section mismatch.

Note that the warning would go away marking either the extern
declaration, the definition, or both. However, we only mark
the definition of the alias, since we do not want callers
(which only see the declaration) to be compiled as if the function
was __cold (and therefore the paths leading to those calls
would be assumed to be unlikely).

Link: https://lore.kernel.org/lkml/20190123173707.GA16603@gmail.com/
Link: https://lore.kernel.org/lkml/20190206175627.GA20399@gmail.com/
Suggested-by: Martin Sebor <msebor@gcc.gnu.org>
Acked-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/module.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index dfe5c2e25ba1e..d237d0574179e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -127,13 +127,13 @@ extern void cleanup_module(void);
 #define module_init(initfn)					\
 	static inline initcall_t __maybe_unused __inittest(void)		\
 	{ return initfn; }					\
-	int init_module(void) __attribute__((alias(#initfn)));
+	int init_module(void) __copy(initfn) __attribute__((alias(#initfn)));
 
 /* This is only required if you want to be unloadable. */
 #define module_exit(exitfn)					\
 	static inline exitcall_t __maybe_unused __exittest(void)		\
 	{ return exitfn; }					\
-	void cleanup_module(void) __attribute__((alias(#exitfn)));
+	void cleanup_module(void) __copy(exitfn) __attribute__((alias(#exitfn)));
 
 #endif
 
-- 
2.20.1



