Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547F2635808
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiKWJt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbiKWJtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414855E3E9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01ED461A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108FEC433D7;
        Wed, 23 Nov 2022 09:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196771;
        bh=nUgVtyji8d859Dq3JmyqfBxK74MViQFLGRGxRF/n8sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKgdg+BeiMTd5e9vv4oSEwmOJZBI3cMqkVwGb2LeQS9Ciu3BMMZT6SigXskAGZOws
         SOPbrT9fMr7hFQz/vrv7gQbIOOhyfphsVS1yS5KwsY6GG4/6dZADs1qRwQ5gVy3X68
         z1uPvSiyCRM4yo7jYT1i55tAVal6xsdwofwFU2co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 120/314] arm64: Fix bit-shifting UB in the MIDR_CPU_MODEL() macro
Date:   Wed, 23 Nov 2022 09:49:25 +0100
Message-Id: <20221123084630.950623370@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D Scott Phillips <scott@os.amperecomputing.com>

[ Upstream commit 8ec8490a1950efeccb00967698cf7cb2fcd25ca7 ]

CONFIG_UBSAN_SHIFT with gcc-5 complains that the shifting of
ARM_CPU_IMP_AMPERE (0xC0) into bits [31:24] by MIDR_CPU_MODEL() is
undefined behavior. Well, sort of, it actually spells the error as:

 arch/arm64/kernel/proton-pack.c: In function 'spectre_bhb_loop_affected':
 arch/arm64/include/asm/cputype.h:44:2: error: initializer element is not constant
   (((imp)   << MIDR_IMPLEMENTOR_SHIFT) | \
   ^

This isn't an issue for other Implementor codes, as all the other codes
have zero in the top bit and so are representable as a signed int.

Cast the implementor code to unsigned in MIDR_CPU_MODEL to remove the
undefined behavior.

Fixes: 0e5d5ae837c8 ("arm64: Add AMPERE1 to the Spectre-BHB affected list")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20221102160106.1096948-1-scott@os.amperecomputing.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index abc418650fec..65e53ef5a396 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -41,7 +41,7 @@
 	(((midr) & MIDR_IMPLEMENTOR_MASK) >> MIDR_IMPLEMENTOR_SHIFT)
 
 #define MIDR_CPU_MODEL(imp, partnum) \
-	(((imp)			<< MIDR_IMPLEMENTOR_SHIFT) | \
+	((_AT(u32, imp)		<< MIDR_IMPLEMENTOR_SHIFT) | \
 	(0xf			<< MIDR_ARCHITECTURE_SHIFT) | \
 	((partnum)		<< MIDR_PARTNUM_SHIFT))
 
-- 
2.35.1



