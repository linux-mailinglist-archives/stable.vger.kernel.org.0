Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A9A5FEF93
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiJNOCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 10:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiJNOCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:02:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ECF1D3C53;
        Fri, 14 Oct 2022 07:01:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 031F1B82361;
        Fri, 14 Oct 2022 13:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEECBC43470;
        Fri, 14 Oct 2022 13:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755697;
        bh=TE6BP9ewEM3scfg8y5+JaE11M16nyUyRAjWMQ7F+xzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asuWPS4nGIlGNyR63eh1z1khEkqPVs/r9UvirjIz9PjdX7KjeJNG5M0hSn/l/TMKm
         L4W6RM87aygVS5o9kW05473pbcBdW21e2Fk+uHechD8cnpllMhq1/Qy6rr1OnBgNDM
         /HxOUrmEr4zngvAJNb9PPhisfJpkUcVHvoB5mgqfgYgjChcMLbUIjHFcysPsc/WB6q
         9b0ZIIlRlgsFoSMibGUYj8gWRbmxTgqxeUn8e7fiMRi229th3wYLnVOM+AKMXP/xBv
         fdE0lVOn5UoGAbCmpnqsLVJ5uwm3N6KOxcqlVWhBr9qcqXgb9377TtkNFQEzNGhYvo
         poWU4NAgHZGYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rohan McLure <rmclure@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        maqianga@uniontech.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 3/4] powerpc: Remove direct call to personality syscall handler
Date:   Fri, 14 Oct 2022 09:54:46 -0400
Message-Id: <20221014135448.2110152-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135448.2110152-1-sashal@kernel.org>
References: <20221014135448.2110152-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohan McLure <rmclure@linux.ibm.com>

[ Upstream commit 4df0221f9ded8c39aecfb1a80cef346026671cb7 ]

Syscall handlers should not be invoked internally by their symbol names,
as these symbols defined by the architecture-defined SYSCALL_DEFINE
macro. Fortunately, in the case of ppc64_personality, its call to
sys_personality can be replaced with an invocation to the
equivalent ksys_personality inline helper in <linux/syscalls.h>.

Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220921065605.1051927-13-rmclure@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/syscalls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index a877bf8269fe..31cf6c0befe8 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -109,7 +109,7 @@ long ppc64_personality(unsigned long personality)
 	if (personality(current->personality) == PER_LINUX32
 	    && personality(personality) == PER_LINUX)
 		personality = (personality & ~PER_MASK) | PER_LINUX32;
-	ret = sys_personality(personality);
+	ret = ksys_personality(personality);
 	if (personality(ret) == PER_LINUX32)
 		ret = (ret & ~PER_MASK) | PER_LINUX;
 	return ret;
-- 
2.35.1

