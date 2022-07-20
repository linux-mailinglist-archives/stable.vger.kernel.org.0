Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000D857AB8D
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240753AbiGTBNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240802AbiGTBMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:12:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66CE66AE3;
        Tue, 19 Jul 2022 18:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 479B56173B;
        Wed, 20 Jul 2022 01:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DF5C36AE2;
        Wed, 20 Jul 2022 01:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279528;
        bh=nrC+Mtpj7dYVMECVZKSkODObPWXRU53loa6gQPA+K34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iu3nl3ZOOJ8wPo72KEOZf5A6cHKE8kSc0YbpTb6KmtTWWpaEE2LXxLknPBsIUibbt
         5jI2YGRckyqc+dYxaL31ouPT8yptTxIvU3qKbJwAJlbnzjYPXEsSnzTJVNg/RW2E7l
         R5rmjVFnknKFSXTHRy27VZl0mU4C8nd0cG7iuZbsfQWqXE20J2i+K0oUE2MsvaXC2e
         y5u7M4F5A0ovv2MQfxZX+zsIvc9b9wC36NTkUEpDLQjE5TTvk2tmaopT620dC7JnCv
         YhjnFg3ag9N4roZrANaKNBnkWsq4MZYr6Z0L7LBusiZ3kHzrEtLjHusREVeBNhyo9w
         zh7LRmA+9Cu2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, alexandre.chartre@oracle.com,
        kim.phillips@amd.com, sblbir@amazon.com
Subject: [PATCH AUTOSEL 5.18 22/54] x86/bugs: Do IBPB fallback check only once
Date:   Tue, 19 Jul 2022 21:09:59 -0400
Message-Id: <20220720011031.1023305-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
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
index ca5f90375a7d..99c45cf27ae6 100644
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

