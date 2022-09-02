Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109BF5AB3EE
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiIBOpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236652AbiIBOpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:45:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83698135B81;
        Fri,  2 Sep 2022 07:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A319B82AA7;
        Fri,  2 Sep 2022 12:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11770C433D7;
        Fri,  2 Sep 2022 12:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121857;
        bh=VMIYCM4Qj9jiuMktXiXRSCAmF412h4t7gocB1eu3T6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooqSHbCHde+ND49X1q1GnYxnth0JPi0JsgmW/SN2Fw26Smt3EafbI5fctKEmcba6w
         Fa3iny+uXwzvMrEglmfAN0zmIYfTKeR7zJj7OQVigyeMsPUhgDq0FWZgDAgDhuFW/D
         jY9enmGmqRdrhgSN6ytqbOxJ3FwS+AYC73kct9kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Lucas Wei <lucaswei@google.com>
Subject: [PATCH 5.15 10/73] arm64: errata: Add Cortex-A510 to the repeat tlbi list
Date:   Fri,  2 Sep 2022 14:18:34 +0200
Message-Id: <20220902121404.778460993@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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

From: James Morse <james.morse@arm.com>

commit 39fdb65f52e9a53d32a6ba719f96669fd300ae78 upstream.

Cortex-A510 is affected by an erratum where in rare circumstances the
CPUs may not handle a race between a break-before-make sequence on one
CPU, and another CPU accessing the same page. This could allow a store
to a page that has been unmapped.

Work around this by adding the affected CPUs to the list that needs
TLB sequences to be done twice.

Signed-off-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220704155732.21216-1-james.morse@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Lucas Wei <lucaswei@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                     |   17 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |    8 +++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -92,6 +92,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2441009        | ARM64_ERRATUM_2441009       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -666,6 +666,23 @@ config ARM64_ERRATUM_1508412
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2441009
+	bool "Cortex-A510: Completion of affected memory accesses might not be guaranteed by completion of a TLBI"
+	default y
+	select ARM64_WORKAROUND_REPEAT_TLBI
+	help
+	  This option adds a workaround for ARM Cortex-A510 erratum #2441009.
+
+	  Under very rare circumstances, affected Cortex-A510 CPUs
+	  may not handle a race between a break-before-make sequence on one
+	  CPU, and another CPU accessing the same page. This could allow a
+	  store to a page that has been unmapped.
+
+	  Work around this by adding the affected CPUs to the list that needs
+	  TLB sequences to be done twice.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -214,6 +214,12 @@ static const struct arm64_cpu_capabiliti
 		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2441009
+	{
+		/* Cortex-A510 r0p0 -> r1p1. Fixed in r1p2 */
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
+	},
+#endif
 	{},
 };
 #endif
@@ -429,7 +435,7 @@ const struct arm64_cpu_capabilities arm6
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
 	{
-		.desc = "Qualcomm erratum 1009, or ARM erratum 1286807",
+		.desc = "Qualcomm erratum 1009, or ARM erratum 1286807, 2441009",
 		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = cpucap_multi_entry_cap_matches,


