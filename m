Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF7D5318A8
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbiEWRaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242407AbiEWR1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FE87CB5C;
        Mon, 23 May 2022 10:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF4CF60919;
        Mon, 23 May 2022 17:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10A7C385AA;
        Mon, 23 May 2022 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326587;
        bh=bmNDXt0dhhCHvZC50SZNQe0bZ4XDsvewzFJ1e8Dm0K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCpRHU0D2zoJKaB8Q4CY9MqZpiuB1/HSeqqAC9gxS0fnQiosYEdFzw6+ArFkAO7rT
         5EIywzvamlL7OyNMV2B8LZGfhPc8Pl3bzhzPiCsGdhIdHHqDh9sGONJ7+uoeqPX4ZX
         VNWoRVITQbkAvomWEQ7ecoFY/ZMTJbI8Czm8mNzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shreyas K K <quic_shrekk@quicinc.com>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/132] arm64: Enable repeat tlbi workaround on KRYO4XX gold CPUs
Date:   Mon, 23 May 2022 19:05:36 +0200
Message-Id: <20220523165844.724849103@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreyas K K <quic_shrekk@quicinc.com>

[ Upstream commit 51f559d66527e238f9a5f82027bff499784d4eac ]

Add KRYO4XX gold/big cores to the list of CPUs that need the
repeat TLBI workaround. Apply this to the affected
KRYO4XX cores (rcpe to rfpe).

The variant and revision bits are implementation defined and are
different from the their Cortex CPU counterparts on which they are
based on, i.e., (r0p0 to r3p0) is equivalent to (rcpe to rfpe).

Signed-off-by: Shreyas K K <quic_shrekk@quicinc.com>
Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Link: https://lore.kernel.org/r/20220512110134.12179-1-quic_shrekk@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst | 3 +++
 arch/arm64/kernel/cpu_errata.c         | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index d410a47ffa57..7c1750bcc5bd 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -163,6 +163,9 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo4xx Silver  | N/A             | ARM64_ERRATUM_1024718       |
 +----------------+-----------------+-----------------+-----------------------------+
+| Qualcomm Tech. | Kryo4xx Gold    | N/A             | ARM64_ERRATUM_1286807       |
++----------------+-----------------+-----------------+-----------------------------+
+
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | A64FX           | E#010001        | FUJITSU_ERRATUM_010001      |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a33d7b8f3b93..c67c19d70159 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -208,6 +208,8 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1286807
 	{
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 0),
+		/* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
+		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
 #endif
 	{},
-- 
2.35.1



