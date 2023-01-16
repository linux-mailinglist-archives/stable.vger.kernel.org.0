Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F8366C0DC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjAPOFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjAPOEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:04:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F3B22783;
        Mon, 16 Jan 2023 06:03:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 161D160FD4;
        Mon, 16 Jan 2023 14:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36131C433F0;
        Mon, 16 Jan 2023 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877784;
        bh=5Cxd53xslv2jhhtxfE3tjYtYEG/w3zgEtb7F0rv8y/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=de2BgwoKZQnPgLgB7c/9H6Y8f1rRiV13YFWFWkr2SJcrnEwWwu3NOhAgvXWcmjHRj
         Ioi93SEaw19qgfike0JvQ3Z620SmhB7v1MjFgB64lw4pXxrbBxtY0P+lmeZErmVD62
         ltUbF+Nkf2Rn9JHRa7en/XC8UYZAFeZAigX+wQKMlF73nq+WRk+bo7bnrthwPFqsJ9
         NJKSUt5tuXGJgcOiaPWZFzaeZH697vUG7VjMHUx86k5Oth3ExzB3tex7bLnsBKnP8P
         tJGEpbkLCIrY3t5JLffWY9E+FfljTVfcFP4QwZ0Xp16tP9/hNquTy/bgOVkv9uGJkq
         iRolNbO6oJfjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 23/53] perf/x86/msr: Add Meteor Lake support
Date:   Mon, 16 Jan 2023 09:01:23 -0500
Message-Id: <20230116140154.114951-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 6887a4d3aede084bf08b70fbc9736c69fce05d7f ]

Meteor Lake is Intel's successor to Raptor lake. PPERF and SMI_COUNT MSRs
are also supported.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: https://lore.kernel.org/r/20230104201349.1451191-7-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/msr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index ecced3a52668..074150d28fa8 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -107,6 +107,8 @@ static bool test_intel(int idx, void *data)
 	case INTEL_FAM6_RAPTORLAKE:
 	case INTEL_FAM6_RAPTORLAKE_P:
 	case INTEL_FAM6_RAPTORLAKE_S:
+	case INTEL_FAM6_METEORLAKE:
+	case INTEL_FAM6_METEORLAKE_L:
 		if (idx == PERF_MSR_SMI || idx == PERF_MSR_PPERF)
 			return true;
 		break;
-- 
2.35.1

