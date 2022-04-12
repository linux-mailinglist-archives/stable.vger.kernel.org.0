Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9792E4FD57C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353723AbiDLHqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357102AbiDLHjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDEFBE16;
        Tue, 12 Apr 2022 00:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F3F0B81B55;
        Tue, 12 Apr 2022 07:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8900EC385A5;
        Tue, 12 Apr 2022 07:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747523;
        bh=AipMkh4r+PEC3Hg3oKtel1W8x7XdUXLF+5yYy1OyNVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwX/wXObYj8PNEpbpCFM0fMx32V4VTrA/fZ8lpiwkWgA4tX9bxPbdY7pg6ULExqK8
         5B3f1APor5mYe9f2h4iVfIIqjoTI0BIA9RF34UUkInHwsHq5+HAQH1mKv/PGFL0aTi
         5pFOrkTLXZn7H2zo4zlvFiZvS2Q4lf36Q1hfIKtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 069/343] libbpf: Fix accessing syscall arguments on powerpc
Date:   Tue, 12 Apr 2022 08:28:07 +0200
Message-Id: <20220412062953.094373741@linuxfoundation.org>
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

[ Upstream commit f07f1503469b11b739892d50c836992ffbe026ee ]

powerpc does not select ARCH_HAS_SYSCALL_WRAPPER, so its syscall
handlers take "unpacked" syscall arguments. Indicate this to libbpf
using PT_REGS_SYSCALL_REGS macro.

Reported-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Link: https://lore.kernel.org/bpf/20220209021745.2215452-5-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index e1b505606882..41f5f3149875 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -178,6 +178,8 @@
 #define __PT_RC_REG gpr[3]
 #define __PT_SP_REG sp
 #define __PT_IP_REG nip
+/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER. */
+#define PT_REGS_SYSCALL_REGS(ctx) ctx
 
 #elif defined(bpf_target_sparc)
 
-- 
2.35.1



