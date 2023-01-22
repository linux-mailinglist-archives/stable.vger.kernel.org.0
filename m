Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386D5676F6E
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjAVPVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjAVPVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:21:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A130227B7
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6287AB80B21
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1BDC4339B;
        Sun, 22 Jan 2023 15:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400878;
        bh=DlVnT5AFFCWORY4saKGny1KCEJBVQqJlhNxGpFb2nHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1arY5jN9RqxPh5B9Eg6L6T4jAI9oMDip4QwWsGdMS8P4e0TidQCazuC2KgE4nRZg/
         +Kjac4wuel0STD2mL/btaNv6/ttPabeUJU52HRXhp02zF9vFHnzk9F/YnkYX3lx5N2
         yTeTgNCsOaiRc30w/SEqF3lc977Odij9Oil65pMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aaron Thompson <dev@aaront.org>,
        "Mike Rapoport (IBM)" <rppt@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/193] memblock tests: Fix compilation error.
Date:   Sun, 22 Jan 2023 16:02:34 +0100
Message-Id: <20230122150247.520661407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Thompson <dev@aaront.org>

[ Upstream commit 340726747336716350eb5a928b860a29db955f05 ]

Commit cf4694be2b2cf ("tools: Add atomic_test_and_set_bit()") changed
tools/arch/x86/include/asm/atomic.h to include <asm/asm.h>, which causes
'make -C tools/testing/memblock' to fail with:

In file included from ../../include/asm/atomic.h:6,
                 from ../../include/linux/atomic.h:5,
                 from ./linux/mmzone.h:5,
                 from ../../include/linux/mm.h:5,
                 from ../../include/linux/pfn.h:5,
                 from ./linux/memory_hotplug.h:6,
                 from ./linux/init.h:7,
                 from ./linux/memblock.h:11,
                 from tests/common.h:8,
                 from tests/basic_api.h:5,
                 from main.c:2:
../../include/asm/../../arch/x86/include/asm/atomic.h:11:10: fatal error: asm/asm.h: No such file or directory
   11 | #include <asm/asm.h>
      |          ^~~~~~~~~~~

Create a symlink to asm/asm.h in the same manner as the existing one to
asm/cmpxchg.h.

Signed-off-by: Aaron Thompson <dev@aaront.org>
Link: https://lore.kernel.org/r/010101857c402765-96e2dbc6-b82b-47e2-a437-4834dbe0b96b-000000@us-west-2.amazonses.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/memblock/.gitignore | 1 +
 tools/testing/memblock/Makefile   | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/memblock/.gitignore b/tools/testing/memblock/.gitignore
index 654338e0be52..4cc7cd5aac2b 100644
--- a/tools/testing/memblock/.gitignore
+++ b/tools/testing/memblock/.gitignore
@@ -1,4 +1,5 @@
 main
 memblock.c
 linux/memblock.h
+asm/asm.h
 asm/cmpxchg.h
diff --git a/tools/testing/memblock/Makefile b/tools/testing/memblock/Makefile
index 246f7ac8489b..575e98fddc21 100644
--- a/tools/testing/memblock/Makefile
+++ b/tools/testing/memblock/Makefile
@@ -29,13 +29,14 @@ include: ../../../include/linux/memblock.h ../../include/linux/*.h \
 
 	@mkdir -p linux
 	test -L linux/memblock.h || ln -s ../../../../include/linux/memblock.h linux/memblock.h
+	test -L asm/asm.h || ln -s ../../../arch/x86/include/asm/asm.h asm/asm.h
 	test -L asm/cmpxchg.h || ln -s ../../../arch/x86/include/asm/cmpxchg.h asm/cmpxchg.h
 
 memblock.c: $(EXTR_SRC)
 	test -L memblock.c || ln -s $(EXTR_SRC) memblock.c
 
 clean:
-	$(RM) $(TARGETS) $(OFILES) linux/memblock.h memblock.c asm/cmpxchg.h
+	$(RM) $(TARGETS) $(OFILES) linux/memblock.h memblock.c asm/asm.h asm/cmpxchg.h
 
 help:
 	@echo  'Memblock simulator'
-- 
2.35.1



