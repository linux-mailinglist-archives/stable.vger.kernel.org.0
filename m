Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D7D4E2A2F
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbiCUOOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349315AbiCUOIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:08:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9016DBA33B;
        Mon, 21 Mar 2022 07:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EF3C613F8;
        Mon, 21 Mar 2022 14:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F339C340F8;
        Mon, 21 Mar 2022 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871358;
        bh=3912HSmqwhPBzrDap/K435w0ZNs81iLW6RVwmA+o/bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rb5ALAYbStDAOsOiHoNDpWg2UisPTxZDAC34OfVxJKw2/StARplIULkp36vvKdaCD
         xTE89sy5vm1CksfiJ97i9VNGvCP09YaHz0q9vS0vSQr/sBEe9Ztrd/YckjkR7nwNCV
         iCEOdnfR5udbYv4JMxksFqtDKSI/5kbRjLny3erM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.16 33/37] arm64: errata: avoid duplicate field initializer
Date:   Mon, 21 Mar 2022 14:53:15 +0100
Message-Id: <20220321133222.250460578@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 316e46f65a5497839857db08b6fbf60f568b165a upstream.

The '.type' field is initialized both in place and in the macro
as reported by this W=1 warning:

arch/arm64/include/asm/cpufeature.h:281:9: error: initialized field overwritten [-Werror=override-init]
  281 |         (ARM64_CPUCAP_SCOPE_LOCAL_CPU | ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU)
      |         ^
arch/arm64/kernel/cpu_errata.c:136:17: note: in expansion of macro 'ARM64_CPUCAP_LOCAL_CPU_ERRATUM'
  136 |         .type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,                         \
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/arm64/kernel/cpu_errata.c:145:9: note: in expansion of macro 'ERRATA_MIDR_RANGE'
  145 |         ERRATA_MIDR_RANGE(m, var, r_min, var, r_max)
      |         ^~~~~~~~~~~~~~~~~
arch/arm64/kernel/cpu_errata.c:613:17: note: in expansion of macro 'ERRATA_MIDR_REV_RANGE'
  613 |                 ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2),
      |                 ^~~~~~~~~~~~~~~~~~~~~
arch/arm64/include/asm/cpufeature.h:281:9: note: (near initialization for 'arm64_errata[18].type')
  281 |         (ARM64_CPUCAP_SCOPE_LOCAL_CPU | ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU)
      |         ^

Remove the extranous initializer.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 1dd498e5e26a ("KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata")
Link: https://lore.kernel.org/r/20220316183800.1546731-1-arnd@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -611,7 +611,6 @@ const struct arm64_cpu_capabilities arm6
 	{
 		.desc = "ARM erratum 2077057",
 		.capability = ARM64_WORKAROUND_2077057,
-		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2),
 	},
 #endif


