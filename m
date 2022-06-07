Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4847E540BD5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245161AbiFGSb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351524AbiFGS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1673C179946;
        Tue,  7 Jun 2022 10:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F62FCE2426;
        Tue,  7 Jun 2022 17:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7578DC3411C;
        Tue,  7 Jun 2022 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624518;
        bh=KcOo1oA3ujYCM/X6/pxf5zQ0h3TH3jWllfC3FvL+cl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJZrLbjIhV57CeYCj3DSD1begJOOKNQ4QCfZOh+FPFjbzb4mnOeNHwJvLYxRdUDaW
         9BDY6HEHO0JUJ5eNZPjxlLIK/iZOTFXQZP0xfcwTKBCc8Ti+iBFcRMM4e5otXsa1yR
         /LYZWnlBQoDT1i6+lbqPIFJgbk45AeQHvSzVOzClNo9v1pJzEBvDVi/l8gxytrv2LJ
         CSjojsSenT3aZE0+1Di8XCOdKzRct71741unX+oDRkQ0/sN3QcZinK5ul1tHWHf9AR
         VuV/4nWVSUKrxGVbciBP7xxDE19ZwZav7urGN7M9BgH+zs5xR3F+7NEIjuzHnCjQMc
         /1QFQXf3Xw0BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, jpoimboe@kernel.org,
        jbaron@akamai.com
Subject: [PATCH AUTOSEL 5.17 48/60] jump_label,noinstr: Avoid instrumentation for JUMP_LABEL=n builds
Date:   Tue,  7 Jun 2022 13:52:45 -0400
Message-Id: <20220607175259.478835-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 656d054e0a15ec327bd82801ccd58201e59f6896 ]

When building x86_64 with JUMP_LABEL=n it's possible for
instrumentation to sneak into noinstr:

vmlinux.o: warning: objtool: exit_to_user_mode+0x14: call to static_key_count.constprop.0() leaves .noinstr.text section
vmlinux.o: warning: objtool: syscall_exit_to_user_mode+0x2d: call to static_key_count.constprop.0() leaves .noinstr.text section
vmlinux.o: warning: objtool: irqentry_exit_to_user_mode+0x1b: call to static_key_count.constprop.0() leaves .noinstr.text section

Switch to arch_ prefixed atomic to avoid the explicit instrumentation.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/jump_label.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 48b9b2a82767..019e55c13248 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -261,9 +261,9 @@ extern void static_key_disable_cpuslocked(struct static_key *key);
 #include <linux/atomic.h>
 #include <linux/bug.h>
 
-static inline int static_key_count(struct static_key *key)
+static __always_inline int static_key_count(struct static_key *key)
 {
-	return atomic_read(&key->enabled);
+	return arch_atomic_read(&key->enabled);
 }
 
 static __always_inline void jump_label_init(void)
-- 
2.35.1

