Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F7B6AA2B7
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjCCVtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjCCVtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:49:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F616703F;
        Fri,  3 Mar 2023 13:45:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECFD2B81A09;
        Fri,  3 Mar 2023 21:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B91C4339B;
        Fri,  3 Mar 2023 21:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879922;
        bh=08JKqLomuqR8Z+WnXh9Rr9/MR0OoAsnToT9vuZiLzkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mspy/E0ZzxK617jzB3y9Q9XOJS/zR5ao67YYwjTkdbAxxhh4+4pVtf+6QuedYcJ0S
         3rNbviRNCn6YDg1NkO2ynqzz21tpCeWa9Sqr6mpQWxta/AnfxMiTTsNWUHv82qHIFg
         Y6tP8bblA8XSQ8QHSgDE6XuzmMcOCDEhh7sPWymGovGzBjGuts2ZBkgUSxJmIYYhDA
         aJlDxFu3EeO9jSMI6BeEVoraPn8tYV6tHviz4kbvnw+sk/x8IrjtjRVC1hoyRXif5U
         Cg7Eom6KRU1F4Fv1XFlW9N+/1qF8l7BKJxFvWYPxOSXtLkwORXEok+iXGEP85TyAWB
         y3Q17anNDHhKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        markzhang@nvidia.com, Jason@zx2c4.com, phaddad@nvidia.com,
        haakon.bugge@oracle.com, linux-rdma@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 57/60] RDMA/cma: Distinguish between sockaddr_in and sockaddr_in6 by size
Date:   Fri,  3 Mar 2023 16:43:11 -0500
Message-Id: <20230303214315.1447666-57-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 876e480da2f74715fc70e37723e77ca16a631e35 ]

Clang can do some aggressive inlining, which provides it with greater
visibility into the sizes of various objects that are passed into
helpers. Specifically, compare_netdev_and_ip() can see through the type
given to the "sa" argument, which means it can generate code for "struct
sockaddr_in" that would have been passed to ipv6_addr_cmp() (that expects
to operate on the larger "struct sockaddr_in6"), which would result in a
compile-time buffer overflow condition detected by memcmp(). Logically,
this state isn't reachable due to the sa_family assignment two callers
above and the check in compare_netdev_and_ip(). Instead, provide a
compile-time check on sizes so the size-mismatched code will be elided
when inlining. Avoids the following warning from Clang:

../include/linux/fortify-string.h:652:4: error: call to '__read_overflow' declared with 'error' attribute: detected read beyond size of object (1st parameter)
                        __read_overflow();
                        ^
note: In function 'cma_netevent_callback'
note:   which inlined function 'node_from_ndev_ip'
1 error generated.

When the underlying object size is not known (e.g. with GCC and older
Clang), the result of __builtin_object_size() is SIZE_MAX, which will also
compile away, leaving the code as it was originally.

Link: https://lore.kernel.org/r/20230208232549.never.139-kees@kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1687
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 26d1772179b8f..8730674ceb2e1 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -479,13 +479,20 @@ static int compare_netdev_and_ip(int ifindex_a, struct sockaddr *sa,
 	if (sa->sa_family != sb->sa_family)
 		return sa->sa_family - sb->sa_family;
 
-	if (sa->sa_family == AF_INET)
-		return memcmp((char *)&((struct sockaddr_in *)sa)->sin_addr,
-			      (char *)&((struct sockaddr_in *)sb)->sin_addr,
+	if (sa->sa_family == AF_INET &&
+	    __builtin_object_size(sa, 0) >= sizeof(struct sockaddr_in)) {
+		return memcmp(&((struct sockaddr_in *)sa)->sin_addr,
+			      &((struct sockaddr_in *)sb)->sin_addr,
 			      sizeof(((struct sockaddr_in *)sa)->sin_addr));
+	}
+
+	if (sa->sa_family == AF_INET6 &&
+	    __builtin_object_size(sa, 0) >= sizeof(struct sockaddr_in6)) {
+		return ipv6_addr_cmp(&((struct sockaddr_in6 *)sa)->sin6_addr,
+				     &((struct sockaddr_in6 *)sb)->sin6_addr);
+	}
 
-	return ipv6_addr_cmp(&((struct sockaddr_in6 *)sa)->sin6_addr,
-			     &((struct sockaddr_in6 *)sb)->sin6_addr);
+	return -1;
 }
 
 static int cma_add_id_to_tree(struct rdma_id_private *node_id_priv)
-- 
2.39.2

