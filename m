Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5587E688BF7
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 01:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbjBCAfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 19:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBCAfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 19:35:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CC167798;
        Thu,  2 Feb 2023 16:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C1361D50;
        Fri,  3 Feb 2023 00:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49538C433D2;
        Fri,  3 Feb 2023 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675384525;
        bh=OEFRgj2r07VcIiioIVTwsasK/y5NxA97g2mUL0L6xKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dlcf6yMpwHQC2n9ApWgNRk1noTHrCDJaI7gyo9cSWUGHvEcRP/TKqk4KFWqk77VTZ
         X8NL2bnf+wFZ6pGZG+fKhDN6r+9wqg4zbmPG1sxYWyGEN9YP/k2ushZ53FC6q+fu4a
         doH1SUDRO8c4hm5Bfqe9NngS8FFV6P794/vlw06gS/LKododEeDCL4Lb7tijUmHkSs
         MyLAxcSnBbPlhuhE/6wq+v7khIE9qwkexfff2UyWGbA5+sB6qxke8G44XpyzuD60U4
         89M+oYZa+NUXeqcAU2swBmb2cvhMa7NjZdJ886QHgkYOTyfWIyrTHMAyHyQp7hGyXo
         Q3EPmnedNtFwg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 v2 07/15] ia64: make IA64_MCA_RECOVERY bool instead of tristate
Date:   Thu,  2 Feb 2023 16:33:46 -0800
Message-Id: <20230203003354.85691-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203003354.85691-1-ebiggers@kernel.org>
References: <20230203003354.85691-1-ebiggers@kernel.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

commit dbecf9b8b8ce580f4e11afed9d61e8aa294cddd2 upstream.

In linux-next, IA64_MCA_RECOVERY uses the (new) function
make_task_dead(), which is not exported for use by modules.  Instead of
exporting it for one user, convert IA64_MCA_RECOVERY to be a bool
Kconfig symbol.

In a config file from "kernel test robot <lkp@intel.com>" for a
different problem, this linker error was exposed when
CONFIG_IA64_MCA_RECOVERY=m.

Fixes this build error:

  ERROR: modpost: "make_task_dead" [arch/ia64/kernel/mca_recovery.ko] undefined!

Link: https://lkml.kernel.org/r/20220124213129.29306-1-rdunlap@infradead.org
Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/ia64/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 1efc444f5fa1a..f8dac6bd17dd2 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -461,7 +461,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config PERFMON
 	bool "Performance monitor support"
-- 
2.39.1

