Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D8760B048
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiJXQDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiJXQCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:02:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B31C5A53;
        Mon, 24 Oct 2022 07:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A89FB81258;
        Mon, 24 Oct 2022 12:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961F0C433D6;
        Mon, 24 Oct 2022 12:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614457;
        bh=TdBw/XZ//KUbb7nc+UiUb1brIjebV2fUdY6YEQ2tcpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mG+oOy4qz7cU5LXDmYAd1aPhTXKsqgvKZExFNtfesgzgP+yepUZenG/Wmmx2hidZj
         pdcn6Pr3AqtqkyaKcPuVi3FsWRCwnWeLcbDpyUMvIeMeS4ZuSCiXUhiaToQgbWTduf
         itNVLSExkPqrZch9NcZrek7zHT6HF/dVTJuFTbFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/390] powerpc/64s: Fix GENERIC_CPU build flags for PPC970 / G5
Date:   Mon, 24 Oct 2022 13:31:06 +0200
Message-Id: <20221024113034.379631829@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 58ec7f06b74e0d6e76c4110afce367c8b5f0837d ]

Big-endian GENERIC_CPU supports 970, but builds with -mcpu=power5.
POWER5 is ISA v2.02 whereas 970 is v2.01 plus Altivec. 2.02 added
the popcntb instruction which a compiler might use.

Use -mcpu=power4.

Fixes: 471d7ff8b51b ("powerpc/64s: Remove POWER4 support")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220921014103.587954-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 59175651f0b9..612254141296 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -153,7 +153,7 @@ CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=power8
 CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=power9,-mtune=power8)
 else
 CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=power7,$(call cc-option,-mtune=power5))
-CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mcpu=power5,-mcpu=power4)
+CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=power4
 endif
 else ifdef CONFIG_PPC_BOOK3E_64
 CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=powerpc64
-- 
2.35.1



