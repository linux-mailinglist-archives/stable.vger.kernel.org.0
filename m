Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D485A4B3D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiH2MNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiH2MMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:12:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763A79E891;
        Mon, 29 Aug 2022 04:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E45466123C;
        Mon, 29 Aug 2022 11:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED292C433D6;
        Mon, 29 Aug 2022 11:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771909;
        bh=k099SGT6cbJNMFaxVYzbiadsUxeStwCwgm8jejTEimg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/BnkPiBaxwpntXM3nhaXGZKXy8sKGuwrt8NEHa4OSz5fp2lHQh32JDPPkrXU/z/j
         nhbLGccnlJgEl7y/UigruufWlw7cmyworKINUySM9R31N2d/3GyP2aCqJPJH5UOu5o
         6kvyFJ20TuhVPfLG72KKA2+h96+TE6VRY2fPf/l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shreyas K K <quic_shrekk@quicinc.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.19 137/158] arm64: Fix match_list for erratum 1286807 on Arm Cortex-A76
Date:   Mon, 29 Aug 2022 12:59:47 +0200
Message-Id: <20220829105814.824211263@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Zenghui Yu <yuzenghui@huawei.com>

commit 5e1e087457c94ad7fafbe1cf6f774c6999ee29d4 upstream.

Since commit 51f559d66527 ("arm64: Enable repeat tlbi workaround on KRYO4XX
gold CPUs"), we failed to detect erratum 1286807 on Cortex-A76 because its
entry in arm64_repeat_tlbi_list[] was accidently corrupted by this commit.

Fix this issue by creating a separate entry for Kryo4xx Gold.

Fixes: 51f559d66527 ("arm64: Enable repeat tlbi workaround on KRYO4XX gold CPUs")
Cc: Shreyas K K <quic_shrekk@quicinc.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220809043848.969-1-yuzenghui@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -208,6 +208,8 @@ static const struct arm64_cpu_capabiliti
 #ifdef CONFIG_ARM64_ERRATUM_1286807
 	{
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 0),
+	},
+	{
 		/* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
 		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},


