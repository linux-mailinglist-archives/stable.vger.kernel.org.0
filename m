Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15A3688BBF
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 01:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjBCA2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 19:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbjBCA2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 19:28:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6221ADF8;
        Thu,  2 Feb 2023 16:28:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F30F61D42;
        Fri,  3 Feb 2023 00:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D85C4339C;
        Fri,  3 Feb 2023 00:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675384086;
        bh=XvMp8OxqN686wYYBuokqdDG9zEqwVzaClZ28PNpdlgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+Tjn7mUedQaJpBgwabWbvI+0CE1KZpZrX2t/5K51Syaq4D73en4K35JjCTxR0ST2
         LWymy2wieDp3AJCu4zjBO0T4k3i6lU4P7Ob7cLBmsGPY1E3E/1ebOKRBSmtBIuFv37
         JJWuDvGqZCXx7TXWvsXcazxK57mcTsJk2HVPRpXPul5GMPX0vAnH3e/SGBUiYGtpkk
         frgiiZlPXAOPVyswRiwjIJS6wWk9XjNzKJiBeIewnT2Rj9wEyghZp+g1X/SXwNDPMv
         V6wl6HoMGPLWl1ekdGz6dqILAuquOP8uwR+G46UPH3lofEwQmisT0c4pYVwwojPnma
         ZRPimnfUO2J5w==
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
Subject: [PATCH 4.19 v2 07/15] ia64: make IA64_MCA_RECOVERY bool instead of tristate
Date:   Thu,  2 Feb 2023 16:27:09 -0800
Message-Id: <20230203002717.49198-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203002717.49198-1-ebiggers@kernel.org>
References: <20230203002717.49198-1-ebiggers@kernel.org>
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
index 8b4a0c1748c03..0d56b19b7511a 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -445,7 +445,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config PERFMON
 	bool "Performance monitor support"
-- 
2.39.1

