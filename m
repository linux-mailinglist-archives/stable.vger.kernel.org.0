Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408B8522000
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346183AbiEJPxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346999AbiEJPvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744D32311D5;
        Tue, 10 May 2022 08:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1159DB81D0D;
        Tue, 10 May 2022 15:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EE5C385CC;
        Tue, 10 May 2022 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197590;
        bh=xE9gKHyJRXSBGiBmo7TlloNcwGX7Ykc6NA1rvaKNwng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqE6IYmobqrSKMu6wldrRbcsed1tvb2X/5HcLpYtlou/aOIWvktpUljEkTvq6KgVf
         gQzPmBxrUK3SVue3M/4+7VPmcDW2PWg7X0OFUNjyEdvZeDt5UT0dnmK+lm+OmbBiRe
         gYb10Y9bx1DohZEFOf4T2uSrzLREXwE9xXICOvzzRlwHNjqvyqSTXMriiIK3c3r3rD
         vcFm8BdXfLVZEtk1gTetZ+/98DV094HvRlxRNQyO2ITSkjXA01bkgbgh2nEGrUhQzQ
         vZm4eucMWGrqDjeQM54NtDzIAncht9mZd7KT1bn0LIJYVY5Si4axt8zW5PE3SuQ+IN
         m25Lx+WUJ2pjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/6] s390: disable -Warray-bounds
Date:   Tue, 10 May 2022 11:46:13 -0400
Message-Id: <20220510154614.154187-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154614.154187-1-sashal@kernel.org>
References: <20220510154614.154187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 8b202ee218395319aec1ef44f72043e1fbaccdd6 ]

gcc-12 shows a lot of array bound warnings on s390. This is caused
by the S390_lowcore macro which uses a hardcoded address of 0.

Wrapping that with absolute_pointer() works, but gcc no longer knows
that a 12 bit displacement is sufficient to access lowcore. So it
emits instructions like 'lghi %r1,0; l %rx,xxx(%r1)' instead of a
single load/store instruction. As s390 stores variables often
read/written in lowcore, this is considered problematic. Therefore
disable -Warray-bounds on s390 for gcc-12 for the time being, until
there is a better solution.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Link: https://lore.kernel.org/r/yt9dzgkelelc.fsf@linux.ibm.com
Link: https://lore.kernel.org/r/20220422134308.1613610-1-svens@linux.ibm.com
Link: https://lore.kernel.org/r/20220425121742.3222133-1-svens@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 9a3a698c8fca..4d0082f3de47 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -27,6 +27,16 @@ KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),-g)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))
+
+ifdef CONFIG_CC_IS_GCC
+	ifeq ($(call cc-ifversion, -ge, 1200, y), y)
+		ifeq ($(call cc-ifversion, -lt, 1300, y), y)
+			KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
+			KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, array-bounds)
+		endif
+	endif
+endif
+
 UTS_MACHINE	:= s390x
 STACK_SIZE	:= 16384
 CHECKFLAGS	+= -D__s390__ -D__s390x__
-- 
2.35.1

