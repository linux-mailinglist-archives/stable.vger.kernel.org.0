Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627316087BE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiJVIFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiJVIEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A8E2D37FF;
        Sat, 22 Oct 2022 00:51:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C57DB82DF2;
        Sat, 22 Oct 2022 07:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AE2C433D6;
        Sat, 22 Oct 2022 07:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424239;
        bh=oMix186Lse2NQD3gTlZX1UK/UVPp5ODuSEv2O/Plpw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYmwdYN3QKBvBRYplGtv6+yDWN6xjIU9gvPqrpOFgimEpCut3j9dc7GPHGeflWG2i
         o/hpKNVZGLDPAH40tTG1mtxVISVQZV7P4g0fc9Pp2RTx7+vd3xCiWuuEBR8YAOeovU
         jCO4bF0ZzNr5xxZXAszonZWrmLGzDhVM1LpRQAcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.19 073/717] arm64: errata: Add Cortex-A55 to the repeat tlbi list
Date:   Sat, 22 Oct 2022 09:19:12 +0200
Message-Id: <20221022072428.164381986@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 171df58028bf4649460fb146a56a58dcb0c8f75a upstream.

Cortex-A55 is affected by an erratum where in rare circumstances the
CPUs may not handle a race between a break-before-make sequence on one
CPU, and another CPU accessing the same page. This could allow a store
to a page that has been unmapped.

Work around this by adding the affected CPUs to the list that needs
TLB sequences to be done twice.

Signed-off-by: James Morse <james.morse@arm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220930131959.3082594-1-james.morse@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                     |   17 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |    5 +++++
 3 files changed, 24 insertions(+)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -76,6 +76,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A55      | #1530923        | ARM64_ERRATUM_1530923       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A55      | #2441007        | ARM64_ERRATUM_2441007       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #852523         | N/A                         |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -629,6 +629,23 @@ config ARM64_ERRATUM_1530923
 config ARM64_WORKAROUND_REPEAT_TLBI
 	bool
 
+config ARM64_ERRATUM_2441007
+	bool "Cortex-A55: Completion of affected memory accesses might not be guaranteed by completion of a TLBI"
+	default y
+	select ARM64_WORKAROUND_REPEAT_TLBI
+	help
+	  This option adds a workaround for ARM Cortex-A55 erratum #2441007.
+
+	  Under very rare circumstances, affected Cortex-A55 CPUs
+	  may not handle a race between a break-before-make sequence on one
+	  CPU, and another CPU accessing the same page. This could allow a
+	  store to a page that has been unmapped.
+
+	  Work around this by adding the affected CPUs to the list that needs
+	  TLB sequences to be done twice.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_1286807
 	bool "Cortex-A76: Modification of the translation table for a virtual address might lead to read-after-read ordering violation"
 	default y
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -214,6 +214,11 @@ static const struct arm64_cpu_capabiliti
 		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2441007
+	{
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+	},
+#endif
 #ifdef CONFIG_ARM64_ERRATUM_2441009
 	{
 		/* Cortex-A510 r0p0 -> r1p1. Fixed in r1p2 */


