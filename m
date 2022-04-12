Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1324FD83A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344418AbiDLIJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356816AbiDLHjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0FB52E41;
        Tue, 12 Apr 2022 00:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD62061777;
        Tue, 12 Apr 2022 07:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEF4C385A5;
        Tue, 12 Apr 2022 07:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747413;
        bh=ayE9bQn03oHjrYkBNK20LwGv7y3GHRuAaspjxBcF8hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmT7hwsQdNypdIvkm1KxKSU5QNEiySS8mA2a4Sim+jINyn8MswF3YJvl8dkeSKeur
         Mj1TX9fz0IoEojcYSvtpElnTJ+otaGDXDz01GN1Dd6H0x4mWaYYvZID/DE3a5zD35V
         waRzHmkXCQLHJOn7svOXhznJwEPuNd1dpxQZAMLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 071/343] libbpf: Fix accessing the first syscall argument on s390
Date:   Tue, 12 Apr 2022 08:28:09 +0200
Message-Id: <20220412062953.151195049@linuxfoundation.org>
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

[ Upstream commit 1f22a6f9f9a0f50218a11a0554709fd34a821fa3 ]

On s390, the first syscall argument should be accessed via orig_gpr2
(see arch/s390/include/asm/syscall.h). Currently gpr[2] is used
instead, leading to bpf_syscall_macro test failure.

orig_gpr2 cannot be added to user_pt_regs, since its layout is a part
of the ABI. Therefore provide access to it only through
PT_REGS_PARM1_CORE_SYSCALL() by using a struct pt_regs flavor.

Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220209021745.2215452-11-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index bed07c35b8de..122d79c8f4b4 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -112,6 +112,10 @@
 
 #elif defined(bpf_target_s390)
 
+struct pt_regs___s390 {
+	unsigned long orig_gpr2;
+};
+
 /* s390 provides user_pt_regs instead of struct pt_regs to userspace */
 #define __PT_REGS_CAST(x) ((const user_pt_regs *)(x))
 #define __PT_PARM1_REG gprs[2]
@@ -124,6 +128,8 @@
 #define __PT_RC_REG gprs[2]
 #define __PT_SP_REG gprs[15]
 #define __PT_IP_REG psw.addr
+#define PT_REGS_PARM1_SYSCALL(x) ({ _Pragma("GCC error \"use PT_REGS_PARM1_CORE_SYSCALL() instead\""); 0l; })
+#define PT_REGS_PARM1_CORE_SYSCALL(x) BPF_CORE_READ((const struct pt_regs___s390 *)(x), orig_gpr2)
 
 #elif defined(bpf_target_arm)
 
-- 
2.35.1



