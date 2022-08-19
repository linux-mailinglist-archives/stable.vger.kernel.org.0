Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565CD59A45E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353727AbiHSQq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353751AbiHSQpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B72510EEF0;
        Fri, 19 Aug 2022 09:11:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 726BCB82804;
        Fri, 19 Aug 2022 16:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01F4C433D6;
        Fri, 19 Aug 2022 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925396;
        bh=MaGMXRIlJ9pG07km76Li0uZMw63W0tee65bOyaB3NMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPcIYpfxD16IkDAmQH79SJ1gvX4/tBkf7M5uaMm/gWBGc5Nm86tSkX05lWUewrqj5
         ivKrC5+Eumn+lQqg3F/qH3FIBSLrbZpWXWYd29HfSus97XIZTXtFrDMuPMQ+mHVZPI
         W/y3Du7BABMmvs4NJWPLAEe0S7Zipta/FpE6x+0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 471/545] KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)
Date:   Fri, 19 Aug 2022 17:44:01 +0200
Message-Id: <20220819153850.484320566@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2368048bf5c2ec4b604ac3431564071e89a0bc71 ]

Return '1', not '-1', when handling an illegal WRMSR to a MCi_CTL or
MCi_STATUS MSR.  The behavior of "all zeros' or "all ones" for CTL MSRs
is architectural, as is the "only zeros" behavior for STATUS MSRs.  I.e.
the intent is to inject a #GP, not exit to userspace due to an unhandled
emulation case.  Returning '-1' gets interpreted as -EPERM up the stack
and effecitvely kills the guest.

Fixes: 890ca9aefa78 ("KVM: Add MCE support")
Fixes: 9ffd986c6e4e ("KVM: X86: #GP when guest attempts to write MCi_STATUS register w/o 0")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20220512222716.4112548-2-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23a5e5880615..98422a53bb1e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2869,13 +2869,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			 */
 			if ((offset & 0x3) == 0 &&
 			    data != 0 && (data | (1 << 10) | 1) != ~(u64)0)
-				return -1;
+				return 1;
 
 			/* MCi_STATUS */
 			if (!msr_info->host_initiated &&
 			    (offset & 0x3) == 1 && data != 0) {
 				if (!can_set_mci_status(vcpu))
-					return -1;
+					return 1;
 			}
 
 			vcpu->arch.mce_banks[offset] = data;
-- 
2.35.1



