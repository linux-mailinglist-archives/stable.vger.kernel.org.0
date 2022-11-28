Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6FF63B501
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 23:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiK1WyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 17:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiK1WyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 17:54:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD292A426
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 14:54:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EBB7B80FE9
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 22:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8968BC433D6;
        Mon, 28 Nov 2022 22:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669676051;
        bh=XhlmGklPZqArTs4x9XA0KNH23q7DJe1TUOnTCjlG9Dc=;
        h=From:To:Cc:Subject:Date:From;
        b=VddVwsPye9fI+3oGQDiZIpYJb2/n+NNk8st3Ic9v4gvyrPEKYwzpLPby6R8gDVv2o
         laQGx5XyHcgryMY5b/MNWjb8qO+BJCNYkQzNycBoAfDnepiHwx+kP2Zgtomn3k3F0R
         QA6DYn0klAzjBHQGg6EL/nr/UtvbfQ1tSJu173wbBZNF6XtXmMHpEiJloszUc/O9DC
         RtyCy3hn3SYqX5FsoMezIxH5TOB6IcZJ3LY77yJPj+uY665YFsUpgyMG8eZW2sSlGj
         YJGKPrRAwAl7fpVNUXsEi9FRcaHpo25waLdfTgiLAL8B3V1rNyyTfdKTfW6+rIDHWN
         gUJf5BTYt60IQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Hugh Dickins <hughd@google.com>, llvm@lists.linux.dev,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 and earlier only] mm: Fix '.data.once' orphan section warning
Date:   Mon, 28 Nov 2022 15:53:46 -0700
Message-Id: <20221128225345.9383-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Portions of upstream commit a4055888629b ("mm/memcg: warning on !memcg
after readahead page charged") were backported as commit cfe575954ddd
("mm: add VM_WARN_ON_ONCE_PAGE() macro"). Unfortunately, the backport
did not account for the lack of commit 33def8498fdd ("treewide: Convert
macro and uses of __section(foo) to __section("foo")") in kernels prior
to 5.10, resulting in the following orphan section warnings on PowerPC
clang builds with CONFIG_DEBUG_VM=y:

  powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
  powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
  powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'

This is a difference between how clang and gcc handle macro
stringification, which was resolved for the kernel by not stringifying
the argument to the __section() macro. Since that change was deemed not
suitable for the stable kernels by commit 59f89518f510 ("once: fix
section mismatch on clang builds"), do that same thing as that change
and remove the quotes from the argument to __section().

Fixes: cfe575954ddd ("mm: add VM_WARN_ON_ONCE_PAGE() macro")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

As far as I can tell, this should be applied to 5.4 and earlier. It
should apply cleanly but let me know if not.

 include/linux/mmdebug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 5d0767cb424a..4ed52879ce55 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -38,7 +38,7 @@ void dump_mm(const struct mm_struct *mm);
 		}							\
 	} while (0)
 #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
-	static bool __section(".data.once") __warned;			\
+	static bool __section(.data.once) __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
 	if (unlikely(__ret_warn_once && !__warned)) {			\

base-commit: 4d2a309b5c28a2edc0900542d22fec3a5a22243b
-- 
2.38.1

