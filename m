Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF654F65C8
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiDFQnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238708AbiDFQnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:43:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F1760CA;
        Wed,  6 Apr 2022 07:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABC1F617AE;
        Wed,  6 Apr 2022 14:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E13C385A6;
        Wed,  6 Apr 2022 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649253772;
        bh=EWVfkY7LZ4Dzf52FkYxnRsdOJExYj9Q5zThM/LqPWUM=;
        h=From:To:Cc:Subject:Date:From;
        b=jVZS4kFB1zE34Twugtd7xwaS7QwBjEMO5gFzNi6IAg3AyYMCsLS2hld8xVrCmgWf6
         kzmAgDUWqIKOHhyY1FYC+SZsvbv/CrgNEe6o3eNwadCKZXtsYbFEQDIYYS8cCQjhep
         xepPxhsACdfpZ8a3CVO2xf5vk6a2RFW0OaB04hZQwXb3nYWmDsH6OcqZ5B6JnvdiRC
         GQopA77VDw11FwUuZKNSDlxNL3FmjJTJeGyYsppw38GP5ToILvGZez0jVMpE4UV4Ix
         Vix4u0Y3QVdt836tvPbUwCit4CipXnCTRiomViK6/s4eyrDCVKyE2J/hDAvdF4TTdY
         PQqDet16psZmQ==
From:   guoren@kernel.org
To:     guoren@kernel.org, arnd@arndb.de
Cc:     linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V3] arm64: patch_text: Fixup last cpu should be master
Date:   Wed,  6 Apr 2022 22:02:21 +0800
Message-Id: <20220406140221.727300-1-guoren@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

These patch_text implementations are using stop_machine_cpuslocked
infrastructure with atomic cpu_count. The original idea: When the
master CPU patch_text, the others should wait for it. But current
implementation is using the first CPU as master, which couldn't
guarantee the remaining CPUs are waiting. This patch changes the
last CPU as the master to solve the potential risk.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/arm64/kernel/patching.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/patching.c b/arch/arm64/kernel/patching.c
index 771f543464e0..33e0fabc0b79 100644
--- a/arch/arm64/kernel/patching.c
+++ b/arch/arm64/kernel/patching.c
@@ -117,8 +117,8 @@ static int __kprobes aarch64_insn_patch_text_cb(void *arg)
 	int i, ret = 0;
 	struct aarch64_insn_patch *pp = arg;
 
-	/* The first CPU becomes master */
-	if (atomic_inc_return(&pp->cpu_count) == 1) {
+	/* The last CPU becomes master */
+	if (atomic_inc_return(&pp->cpu_count) == num_online_cpus()) {
 		for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
 			ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
 							     pp->new_insns[i]);
-- 
2.25.1

