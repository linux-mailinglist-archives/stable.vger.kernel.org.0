Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55017528E64
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345975AbiEPTnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346013AbiEPTmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5193F316;
        Mon, 16 May 2022 12:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A41DB81610;
        Mon, 16 May 2022 19:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97BEC385AA;
        Mon, 16 May 2022 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730061;
        bh=xE9gKHyJRXSBGiBmo7TlloNcwGX7Ykc6NA1rvaKNwng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0yWbKTT9NhvM8iqyqdmUfJOAiTjxPXinLOahCvo5MP1btDP9Cq383cJLXl88Y4wE
         OxPX8cmNkZjJ+4ccYWG9OC45qwkH3IegM9XfozrOg3Jnt5N5Tx3BSYK27muCgT8LyI
         NKBnIFiLwHUq+j6NmFKhUHza9+THJH2bka5tomq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/32] s390: disable -Warray-bounds
Date:   Mon, 16 May 2022 21:36:33 +0200
Message-Id: <20220516193615.344397004@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



