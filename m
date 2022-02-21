Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D148E4BE68B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350270AbiBUJdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:33:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350392AbiBUJde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:33:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D8E289BD;
        Mon, 21 Feb 2022 01:13:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2C2BCCE0E95;
        Mon, 21 Feb 2022 09:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D2AC340E9;
        Mon, 21 Feb 2022 09:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434834;
        bh=UEOIZ/+yy0RbqQruQBSerpKd1T9gkdqmoXdsfIsc0Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RlDdIIbP8ngcYtPRCGEcAFb/jl8a4UQM4E/CX0uJY/1+tdbinT3aER0PR19U4EOz
         Jk+owQR6qtqggaG1NuOnizLPUTUg804+z8YwxdytoxxJuSTQMR5zp1RzhF85rhJpP5
         9ZQCBIEx2bwP/JxLCUDujf/Bl+zqgEAPzv52GM88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/196] KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW
Date:   Mon, 21 Feb 2022 09:49:38 +0100
Message-Id: <20220221084935.806593502@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 710c476514313c74045c41c0571bb5178fd16e3d ]

AMD's event select is 3 nybbles, with the high nybble in bits 35:32 of
a PerfEvtSeln MSR. Don't mask off the high nybble when configuring a
RAW perf event.

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220203014813.2130559-2-jmattson@google.com>
Reviewed-by: David Dunn <daviddunn@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bfef0c658730e..f256f01056bdb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -217,7 +217,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	}
 
 	if (type == PERF_TYPE_RAW)
-		config = eventsel & X86_RAW_EVENT_MASK;
+		config = eventsel & AMD64_RAW_EVENT_MASK;
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
-- 
2.34.1



