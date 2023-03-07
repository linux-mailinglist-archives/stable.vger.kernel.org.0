Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A9B6AF2EF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbjCGS5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjCGS5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:57:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50390B5ABA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 317076150E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2784BC433D2;
        Tue,  7 Mar 2023 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214693;
        bh=qeLeNIXxJNYpEDWqTqqrZTf0gnfv31fFidcds7kY8fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BALeeXZUM8yZX4182zFGDbPTOgPbLcyJLK3tHIX1nlkjoIjeosx9iIgyGeCmV2b20
         q0C/u2aj9L3+5k68paVsezvw9FpGr3hvE6Wk/MBgIdAwq8RURxT0xmSAA/LVmzwLGs
         MiVhpWG/6Frukq/2mYJ5tu5j5s/9KTOaMp55m+ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Anders Roxell <anders.roxell@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: [PATCH 5.15 003/567] powerpc/mm: Rearrange if-else block to avoid clang warning
Date:   Tue,  7 Mar 2023 17:55:39 +0100
Message-Id: <20230307165905.969362083@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

commit d78c8e32890ef7eca79ffd67c96022c7f9d8cce4 upstream.

Clang warns:

  arch/powerpc/mm/book3s64/radix_tlb.c:1191:23: error: variable 'hstart' is uninitialized when used here
    __tlbiel_va_range(hstart, hend, pid,
                      ^~~~~~
  arch/powerpc/mm/book3s64/radix_tlb.c:1191:31: error: variable 'hend' is uninitialized when used here
    __tlbiel_va_range(hstart, hend, pid,
                              ^~~~

Rework the 'if (IS_ENABLE(CONFIG_TRANSPARENT_HUGEPAGE))' so hstart/hend
is always initialized to silence the warnings. That will also simplify
the 'else' path. Clang is getting confused with these warnings, but the
warnings is a false-positive.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220810114318.3220630-1-anders.roxell@linaro.org
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/book3s64/radix_tlb.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -1171,15 +1171,12 @@ static inline void __radix__flush_tlb_ra
 			}
 		}
 	} else {
-		bool hflush = false;
+		bool hflush;
 		unsigned long hstart, hend;
 
-		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-			hstart = (start + PMD_SIZE - 1) & PMD_MASK;
-			hend = end & PMD_MASK;
-			if (hstart < hend)
-				hflush = true;
-		}
+		hstart = (start + PMD_SIZE - 1) & PMD_MASK;
+		hend = end & PMD_MASK;
+		hflush = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hstart < hend;
 
 		if (type == FLUSH_TYPE_LOCAL) {
 			asm volatile("ptesync": : :"memory");


