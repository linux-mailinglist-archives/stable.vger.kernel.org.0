Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952825010B1
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343603AbiDNOI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347676AbiDNN70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7479948313;
        Thu, 14 Apr 2022 06:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A6EC61D93;
        Thu, 14 Apr 2022 13:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D62C385A1;
        Thu, 14 Apr 2022 13:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944265;
        bh=E9oBKnGrbOL8j3KL7Qiy9TC8aJztPpm2YTXjK64aTY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihZbG3l4LUTiyvqvPg6lA0A+lzWVnxB+7Md6tNeb9vtB4otHgLjBIx47nB1Vc6PzE
         MmUjP96vnSLOEDh6gPEim7X8XqwaDs+JFgOhdzIllNHvOpkFNuOffXmuRMtu4r9sBY
         Aqcd8FGVz1A2bg2J9uAJIFPIUsu2uNVWA8gfN3qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 453/475] arm64: patch_text: Fixup last cpu should be master
Date:   Thu, 14 Apr 2022 15:13:58 +0200
Message-Id: <20220414110907.735915849@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 31a099dbd91e69fcab55eef4be15ed7a8c984918 upstream.

These patch_text implementations are using stop_machine_cpuslocked
infrastructure with atomic cpu_count. The original idea: When the
master CPU patch_text, the others should wait for it. But current
implementation is using the first CPU as master, which couldn't
guarantee the remaining CPUs are waiting. This patch changes the
last CPU as the master to solve the potential risk.

Fixes: ae16480785de ("arm64: introduce interfaces to hotpatch kernel and module code")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220407073323.743224-2-guoren@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/insn.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -207,8 +207,8 @@ static int __kprobes aarch64_insn_patch_
 	int i, ret = 0;
 	struct aarch64_insn_patch *pp = arg;
 
-	/* The first CPU becomes master */
-	if (atomic_inc_return(&pp->cpu_count) == 1) {
+	/* The last CPU becomes master */
+	if (atomic_inc_return(&pp->cpu_count) == num_online_cpus()) {
 		for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
 			ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
 							     pp->new_insns[i]);


