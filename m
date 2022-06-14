Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A7454A46D
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351696AbiFNCHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351668AbiFNCGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:06:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD474344C1;
        Mon, 13 Jun 2022 19:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F3D3B816A2;
        Tue, 14 Jun 2022 02:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB7DC385A2;
        Tue, 14 Jun 2022 02:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172343;
        bh=Y0CrsHuCpT5FIY3MPvSOUDooFQA1XjbxrPWWfr7pVxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgX1FSo3b583ILFbr8xJcabnu7MNB/uULhCfcFqLQpKI2suh1+cddSKkKzaNGI9u0
         zcguBL81BL1wrw4Zg0xERG4pR709EG0bxvEvW5xt4Ik65MRYe4uWeFLnb8IUOBLp5j
         faWMZcr9vdsFsDKhsINJJb07n8mWiKfi+KuG8xFfuJvV5y7GNNTVLynikMdhzif5ht
         H8rhExvZeKNyRUWyakkiuCU8QCLE/wj3BeTBGoEBDSO4UYPOUyjaKRW0efcYx6HwL6
         ++Ovc+zbQLwRCG5aPdFOR2VV9zR8Z5qWlrmHTNtKFwF0EHrpsvbrDAWKIiPIpYLXMl
         IgaqvJ4H2nqYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, mmarek@suse.com,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 36/47] gcc-12: disable '-Wdangling-pointer' warning for now
Date:   Mon, 13 Jun 2022 22:04:29 -0400
Message-Id: <20220614020441.1098348-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 49beadbd47c270a00754c107a837b4f29df4c822 ]

While the concept of checking for dangling pointers to local variables
at function exit is really interesting, the gcc-12 implementation is not
compatible with reality, and results in false positives.

For example, gcc sees us putting things on a local list head allocated
on the stack, which involves exactly those kinds of pointers to the
local stack entry:

  In function ‘__list_add’,
      inlined from ‘list_add_tail’ at include/linux/list.h:102:2,
      inlined from ‘rebuild_snap_realms’ at fs/ceph/snap.c:434:2:
  include/linux/list.h:74:19: warning: storing the address of local variable ‘realm_queue’ in ‘*&realm_27(D)->rebuild_item.prev’ [-Wdangling-pointer=]
     74 |         new->prev = prev;
        |         ~~~~~~~~~~^~~~~~

But then gcc - understandably - doesn't really understand the big
picture how the doubly linked list works, so doesn't see how we then end
up emptying said list head in a loop and the pointer we added has been
removed.

Gcc also complains about us (intentionally) using this as a way to store
a kind of fake stack trace, eg

  drivers/acpi/acpica/utdebug.c:40:38: warning: storing the address of local variable ‘current_sp’ in ‘acpi_gbl_entry_stack_pointer’ [-Wdangling-pointer=]
     40 |         acpi_gbl_entry_stack_pointer = &current_sp;
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~

which is entirely reasonable from a compiler standpoint, and we may want
to change those kinds of patterns, but not not.

So this is one of those "it would be lovely if the compiler were to
complain about us leaving dangling pointers to the stack", but not this
way.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index eb3adfec0b22..a8de148aeb04 100644
--- a/Makefile
+++ b/Makefile
@@ -804,6 +804,9 @@ endif
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
 
+# These result in bogus false positives
+KBUILD_CFLAGS += $(call cc-disable-warning, dangling-pointer)
+
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
-- 
2.35.1

