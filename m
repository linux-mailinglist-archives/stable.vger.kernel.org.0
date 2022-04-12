Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4454FDA47
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353826AbiDLHqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357104AbiDLHjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989DEDEA4;
        Tue, 12 Apr 2022 00:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34EA56153F;
        Tue, 12 Apr 2022 07:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415B6C385A6;
        Tue, 12 Apr 2022 07:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747526;
        bh=LiN4xAlbtOMQmCAMYa+oEGTr4Vv1YS5mZ2fgoK15uO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FD04ZgobCRENG1h0YSZ8DxEEIh42Ch/PugylS6e0nx0q5OQoq1SHDWgVZCGI+sZIO
         4gvf4GbcoZz8T2bi1qS/GbHY150u5zURoSZKYY2ktW9LK8f4+eMiHZN+h2qT1PIjdx
         l8+dQT2oss2r8eTkZk1Y/5+D0kjIDHL/j8FIpGQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 070/343] libbpf: Fix accessing the first syscall argument on arm64
Date:   Tue, 12 Apr 2022 08:28:08 +0200
Message-Id: <20220412062953.123150338@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit fbca4a2f649730b67488a8b36140ce4d2cf13c63 ]

On arm64, the first syscall argument should be accessed via orig_x0
(see arch/arm64/include/asm/syscall.h). Currently regs[0] is used
instead, leading to bpf_syscall_macro test failure.

orig_x0 cannot be added to struct user_pt_regs, since its layout is a
part of the ABI. Therefore provide access to it only through
PT_REGS_PARM1_CORE_SYSCALL() by using a struct pt_regs flavor.

Reported-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220209021745.2215452-10-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 41f5f3149875..bed07c35b8de 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -140,6 +140,10 @@
 
 #elif defined(bpf_target_arm64)
 
+struct pt_regs___arm64 {
+	unsigned long orig_x0;
+};
+
 /* arm64 provides struct user_pt_regs instead of struct pt_regs to userspace */
 #define __PT_REGS_CAST(x) ((const struct user_pt_regs *)(x))
 #define __PT_PARM1_REG regs[0]
@@ -152,6 +156,8 @@
 #define __PT_RC_REG regs[0]
 #define __PT_SP_REG sp
 #define __PT_IP_REG pc
+#define PT_REGS_PARM1_SYSCALL(x) ({ _Pragma("GCC error \"use PT_REGS_PARM1_CORE_SYSCALL() instead\""); 0l; })
+#define PT_REGS_PARM1_CORE_SYSCALL(x) BPF_CORE_READ((const struct pt_regs___arm64 *)(x), orig_x0)
 
 #elif defined(bpf_target_mips)
 
-- 
2.35.1



