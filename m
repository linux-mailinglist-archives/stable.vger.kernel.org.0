Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4A460AFFC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJXP7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiJXP7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67048D13F;
        Mon, 24 Oct 2022 07:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64861B819F3;
        Mon, 24 Oct 2022 12:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AA5C433D6;
        Mon, 24 Oct 2022 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615756;
        bh=kCjMqZywxWcHUie29K606YnrML/s35LkSViE6qE82q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3Dt7+bmvtoZPK09hmS7Hy1/boyUzom3CcGQLQp2euioXe4VuAw/VJPElRnUnLaHp
         tl9NxTD+eUeV8LMeoqLw+oKz96oitQJiEvWrwPfD6JvGFpn3xNx1pZFAekI/PmgbG/
         LviqBPLtSy67UsWhMSXeiunAPGRloYrRlVP4kVZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Haren Myneni <haren@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 372/530] powerpc/pseries/vas: Pass hw_cpu_id to node associativity HCALL
Date:   Mon, 24 Oct 2022 13:31:56 +0200
Message-Id: <20221024113101.873817528@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b043e3936d21..15046d80f042 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -324,7 +324,7 @@ static struct vas_window *vas_allocate_window(int vas_id, u64 flags,
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



