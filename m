Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A636089F8
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiJVIps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbiJVIoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:44:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82D2EBB96;
        Sat, 22 Oct 2022 01:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D59560AC3;
        Sat, 22 Oct 2022 07:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A41C433C1;
        Sat, 22 Oct 2022 07:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425450;
        bh=faVI2ltSz4dRWRF51eXeVoUuUZAOTS8lGFgE0aj/DJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMfk36zTdCJQzbKXAEx+gh5GoNnmtqAcmcPdEV45zUCbVjUuOFlTM/ISQSBlEpINh
         LXmDtmzJ1d3AD5NhXZQP/QcAa4tz9BG5DMWtXxkaB6SnuFwh6NPTTfbajuN7KxWWbJ
         T0Uu2Aw3EwlGOaPWCjVayF1AHE8qd3BhS0Mzx+ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Haren Myneni <haren@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 506/717] powerpc/pseries/vas: Pass hw_cpu_id to node associativity HCALL
Date:   Sat, 22 Oct 2022 09:26:25 +0200
Message-Id: <20221022072520.647548263@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haren Myneni <haren@linux.ibm.com>

[ Upstream commit f3e5d9e53e74d77e711a2c90a91a8b0836a9e0b3 ]

Generally the hypervisor decides to allocate a window on different
VAS instances. But if user space wishes to allocate on the current VAS
instance where the process is executing, the kernel has to pass
associativity domain IDs to allocate VAS window HCALL.

To determine the associativity domain IDs for the current CPU,
smp_processor_id() is passed to node associativity HCALL which may
return H_P2 (-55) error during DLPAR CPU event. This is because Linux
CPU numbers (smp_processor_id()) are not the same as the hypervisor's
view of CPU numbers.

Fix the issue by passing hard_smp_processor_id() with
VPHN_FLAG_VCPU flag (PAPR 14.11.6.1 H_HOME_NODE_ASSOCIATIVITY).

Fixes: b22f2d88e435 ("powerpc/pseries/vas: Integrate API with open/close windows")
Reviewed-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
[mpe: Update change log to mention Linux vs HV CPU numbers]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/55380253ea0c11341824cd4c0fc6bbcfc5752689.camel@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/vas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index 500a1fc4a1d7..b2a32f8a837a 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -332,7 +332,7 @@ static struct vas_window *vas_allocate_window(int vas_id, u64 flags,
 		 * So no unpacking needs to be done.
 		 */
 		rc = plpar_hcall9(H_HOME_NODE_ASSOCIATIVITY, domain,
-				  VPHN_FLAG_VCPU, smp_processor_id());
+				  VPHN_FLAG_VCPU, hard_smp_processor_id());
 		if (rc != H_SUCCESS) {
 			pr_err("H_HOME_NODE_ASSOCIATIVITY error: %d\n", rc);
 			goto out;
-- 
2.35.1



