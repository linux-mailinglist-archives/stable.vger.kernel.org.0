Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5884D4A50
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbiCJOeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244952AbiCJO3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:29:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9826156963;
        Thu, 10 Mar 2022 06:25:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B64BB8267B;
        Thu, 10 Mar 2022 14:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1461C340E8;
        Thu, 10 Mar 2022 14:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922296;
        bh=BjhNuDswWhutw0Va1gA9M+7Vl6Iaj6ZmKGq889IWLoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ma3yPSCd2gHee7LBAY3vHmWZ38u4+yYbQsbD8Xz5En6PlAfpGWCRIVa44xzyAWuGY
         e6uIurMcZlzYh66dGILTw/Rs0mbYJD8oTiYwttKlZ1oo/H/Q7F1Y4Xnv8E5lORkRZn
         WGrdZRvdZQzz2Kvo0rm8J87K1Y9xCKr0IUkFDiNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Hector Martin <marcan@marcan.st>
Subject: [PATCH 5.10 15/58] arm64: cputype: Add CPU implementor & types for the Apple M1 cores
Date:   Thu, 10 Mar 2022 15:18:35 +0100
Message-Id: <20220310140813.310046847@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

commit 11ecdad722daafcac09c4859dddf31b3d46449bc upstream.

The implementor will be used to condition the FIQ support quirk.

The specific CPU types are not used at the moment, but let's add them
for documentation purposes.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -59,6 +59,7 @@
 #define ARM_CPU_IMP_NVIDIA		0x4E
 #define ARM_CPU_IMP_FUJITSU		0x46
 #define ARM_CPU_IMP_HISI		0x48
+#define ARM_CPU_IMP_APPLE		0x61
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -99,6 +100,9 @@
 
 #define HISI_CPU_PART_TSV110		0xD01
 
+#define APPLE_CPU_PART_M1_ICESTORM	0x022
+#define APPLE_CPU_PART_M1_FIRESTORM	0x023
+
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 #define MIDR_CORTEX_A72 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
@@ -127,6 +131,8 @@
 #define MIDR_NVIDIA_CARMEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_CARMEL)
 #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
+#define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
+#define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX


