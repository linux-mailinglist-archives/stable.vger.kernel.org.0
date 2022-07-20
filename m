Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0B57AC54
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241068AbiGTBTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241333AbiGTBSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:18:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D965FD5F;
        Tue, 19 Jul 2022 18:15:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40E15CE1D21;
        Wed, 20 Jul 2022 01:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF884C341CE;
        Wed, 20 Jul 2022 01:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279702;
        bh=ulYS1S/06ZCCJmjbGO2R02Jvk/VEePW+sYw7h9ZGrDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fR4Z2hcMEQ0wma4E6iTfD2LVGlIoQlKm/wHwXt0ZAYhZRWEe1Y9mqgBu03lFv1p1l
         KTpCWAbi54kLJfynIt/UTTfCdYMuuOlOM7jFF8UR5ZvvQCLes67cDDxmluUJgi855z
         NThz6cixfBzXxf0fC1nrzcC2JDmJNjurDEb784SjX71ZGPl+f4PF2AHfPOMF5Kp1wh
         j1SryFFeQwTWCbFOqIgLkuKcYQLhqqB0ADGDc296ywXJ3FSL8S8w/DfH+ROaPBusvx
         xTnzr9LTcbR3NyEwlnCv2JukPESfIbzl5ssdd8tfIS9pnFgFW7Vo7UTrtpyXwbVy9x
         pbiQAcdtYHMRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, sblbir@amazon.com
Subject: [PATCH AUTOSEL 5.15 17/42] x86/bugs: Do IBPB fallback check only once
Date:   Tue, 19 Jul 2022 21:13:25 -0400
Message-Id: <20220720011350.1024134-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 0fe4aeea9c01baabecc8c3afc7889c809d939bc2 ]

When booting with retbleed=auto, if the kernel wasn't built with
CONFIG_CC_HAS_RETURN_THUNK, the mitigation falls back to IBPB.  Make
sure a warning is printed in that case.  The IBPB fallback check is done
twice, but it really only needs to be done once.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d4a18649ce9f..c59db48472dc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -871,8 +871,9 @@ static void __init retbleed_select_mitigation(void)
 			retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
 
 		/*
-		 * The Intel mitigation (IBRS) was already selected in
-		 * spectre_v2_select_mitigation().
+		 * The Intel mitigation (IBRS or eIBRS) was already selected in
+		 * spectre_v2_select_mitigation().  'retbleed_mitigation' will
+		 * be set accordingly below.
 		 */
 
 		break;
-- 
2.35.1

