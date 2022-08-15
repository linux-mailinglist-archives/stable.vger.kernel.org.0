Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC38594343
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346911AbiHOWE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344113AbiHOWCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:02:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1F082D24;
        Mon, 15 Aug 2022 12:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84CCBB80EAD;
        Mon, 15 Aug 2022 19:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B603BC433D6;
        Mon, 15 Aug 2022 19:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592228;
        bh=QJS/R1P+cg/xZTzIpbbkM8/b12fmW1LwuZjmzleKuTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LszV3+6pbsKXUvlaee9+jBG3X39jBaMvEdCFAufllCtkD5T2q2eS8ejIHFv8OOcVd
         BY4/kZvzBRsDsVjXqdRvUAI6IsUHCPcPJ80WMIDo+BfnIZdLm3IUGvN5FcszovwX/1
         UmlXgF+fCQp5y4pSS4UnMI6eNtTFErZgBiHJsGl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 0077/1157] RISC-V: Fix counter restart during overflow for RV32
Date:   Mon, 15 Aug 2022 19:50:33 +0200
Message-Id: <20220815180442.608060612@linuxfoundation.org>
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

From: Atish Patra <atishp@rivosinc.com>

commit acc1b919f47926b089be21b8aaa29ec91fef0aa2 upstream.

Pass the upper half of the initial value of the counter correctly
for RV32.

Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220711174632.4186047-2-atishp@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu_sbi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -525,8 +525,13 @@ static inline void pmu_sbi_start_overflo
 			hwc = &event->hw;
 			max_period = riscv_pmu_ctr_get_width_mask(event);
 			init_val = local64_read(&hwc->prev_count) & max_period;
+#if defined(CONFIG_32BIT)
+			sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, idx, 1,
+				  flag, init_val, init_val >> 32, 0);
+#else
 			sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, idx, 1,
 				  flag, init_val, 0, 0);
+#endif
 		}
 		ctr_ovf_mask = ctr_ovf_mask >> 1;
 		idx++;


