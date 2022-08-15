Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F195B5950CD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiHPEqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbiHPEpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:45:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982063F1E5;
        Mon, 15 Aug 2022 13:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2FC461234;
        Mon, 15 Aug 2022 20:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1748C433C1;
        Mon, 15 Aug 2022 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596249;
        bh=HkyYOrUZNw75qiukQT9RI/l054amCsbfshAfs8CsLRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awRMFC+G0mkAVdH197A0IFfyeJ7x7CvYK5PI6AAZL4WHnVuD5ewL/iI8Rr9ANa4xF
         03R2m5+Iw5/GOgRTGMzR+Uytq9ekZqHwr/sFUr8HyW46PWCgZ/8y69Wo4R4fi3xUa8
         kK1P8sJWHDxckpZUFnwAeCCyUeE8ScgS3jERJM04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1020/1157] powerpc/64e: Fix kexec build error
Date:   Mon, 15 Aug 2022 20:06:16 +0200
Message-Id: <20220815180520.712692552@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 4cfa6ff24a9744ba484521c38bea613134fbfcb3 ]

When building ppc64_book3e_allmodconfig the build fails with:

  arch/powerpc/kexec/file_load_64.c:1063:14: error: implicit declaration of function ‘firmware_has_feature’
   1063 |         if (!firmware_has_feature(FW_FEATURE_LPAR))
        |              ^~~~~~~~~~~~~~~~~~~~

Add a direct include of asm/firmware.h to fix the error.

Fixes: b1fc44eaa9ba ("pseries/iommu/ddw: Fix kdump to work in absence of ibm,dma-window")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220803063152.1249270-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 5d2c22aa34fb..683462e4556b 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -23,6 +23,7 @@
 #include <linux/vmalloc.h>
 #include <asm/setup.h>
 #include <asm/drmem.h>
+#include <asm/firmware.h>
 #include <asm/kexec_ranges.h>
 #include <asm/crashdump-ppc64.h>
 
-- 
2.35.1



