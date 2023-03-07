Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45936AED09
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCGSAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbjCGSAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:00:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222ED4E5C6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBAF4B819BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBF1C433EF;
        Tue,  7 Mar 2023 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211656;
        bh=vgjzvMwfqREa+lHmGwYtebriiOfY+KDav08tZLkqfp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIWDLDBoFJYmQ2XRsN5qfGlIkTcntJdbmNhA3FZqw7tNuOW4i/mILMxcBO6JyGdUy
         OjrftkZ0EbLis0prCTrLXNCI2/M9hIcb/mEvJfaY467Q3R9G/fRu4lVL46pTFaHcVs
         bA8itNE6cGMgLJ6BY5Vj9WoKM7r3NRo8GZv+/OaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Will Deacon <will@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.2 0926/1001] arm64: acpi: Fix possible memory leak of ffh_ctxt
Date:   Tue,  7 Mar 2023 18:01:38 +0100
Message-Id: <20230307170102.272177006@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

commit 1b561d3949f8478c5403c9752b5533211a757226 upstream.

Allocated 'ffh_ctxt' memory leak is possible if the SMCCC version
and conduit checks fail and -EOPNOTSUPP is returned without freeing the
allocated memory.

Fix the same by moving the allocation after the SMCCC version and
conduit checks.

Fixes: 1d280ce099db ("arm64: Add architecture specific ACPI FFH Opregion callbacks")
Cc: <stable@vger.kernel.org> # 6.2.x
Cc: Will Deacon <will@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Suggested-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/202302191417.dAl9NuE8-lkp@intel.com/
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20230223135742.2952091-1-sudeep.holla@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/acpi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 378453faa87e..dba8fcec7f33 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -435,10 +435,6 @@ int acpi_ffh_address_space_arch_setup(void *handler_ctxt, void **region_ctxt)
 	enum arm_smccc_conduit conduit;
 	struct acpi_ffh_data *ffh_ctxt;
 
-	ffh_ctxt = kzalloc(sizeof(*ffh_ctxt), GFP_KERNEL);
-	if (!ffh_ctxt)
-		return -ENOMEM;
-
 	if (arm_smccc_get_version() < ARM_SMCCC_VERSION_1_2)
 		return -EOPNOTSUPP;
 
@@ -448,6 +444,10 @@ int acpi_ffh_address_space_arch_setup(void *handler_ctxt, void **region_ctxt)
 		return -EOPNOTSUPP;
 	}
 
+	ffh_ctxt = kzalloc(sizeof(*ffh_ctxt), GFP_KERNEL);
+	if (!ffh_ctxt)
+		return -ENOMEM;
+
 	if (conduit == SMCCC_CONDUIT_SMC) {
 		ffh_ctxt->invoke_ffh_fn = __arm_smccc_smc;
 		ffh_ctxt->invoke_ffh64_fn = arm_smccc_1_2_smc;
-- 
2.39.2



