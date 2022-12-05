Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D580F64348D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiLETrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbiLETrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:47:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564622A43C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1474B811CF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0B4C433C1;
        Mon,  5 Dec 2022 19:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269441;
        bh=W6zTtECllZh/sYXkgkxHGkDu710QDASBhdWH1js7TC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frGaFtTsaHG2xqgU9UdTSvC4u7YYoblHxJYZ+xOXEh5d4BT3++Z8okMP9Gj5e9qSO
         YDA2a3ZN/hBJoZLZgn3eTb/k0iZ3houuowg4ZqBDhwjbXwqJVo+xyl8VdojRcuV1em
         sRv460TOfSEZorA0Ko5X8daJxKTm2GlxFKH9MXhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH 5.4 129/153] mm: Fix .data.once orphan section warning
Date:   Mon,  5 Dec 2022 20:10:53 +0100
Message-Id: <20221205190812.388964827@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

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
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmdebug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -38,7 +38,7 @@ void dump_mm(const struct mm_struct *mm)
 		}							\
 	} while (0)
 #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
-	static bool __section(".data.once") __warned;			\
+	static bool __section(.data.once) __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
 	if (unlikely(__ret_warn_once && !__warned)) {			\


