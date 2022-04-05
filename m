Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B584F28AC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbiDEIVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiDEIIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:08:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175E06C1ED;
        Tue,  5 Apr 2022 01:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8515617BB;
        Tue,  5 Apr 2022 08:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB14DC385A0;
        Tue,  5 Apr 2022 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145737;
        bh=7sDJ2RHrC/huW9RezcPNtggKrMYJEdFEyQl7gB+nlfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOUQGhclR34zJlvCwovv6xmLOvkXg4b18ZBGijcs9d890PW58tkLBgfpk5lpWCz6y
         C6lC6DHDD4t3N//9ywJxAwhfxOBRoMPDByMLT3gMjvA0IoBQ/P4L6OmyUcZAHwROGk
         ZddkAq0pEecsav44hLhi3B7TuIdNFHwG8FPRzqaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0473/1126] KVM: PPC: Fix vmx/vsx mixup in mmio emulation
Date:   Tue,  5 Apr 2022 09:20:20 +0200
Message-Id: <20220405070421.510701872@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Fabiano Rosas <farosas@linux.ibm.com>

[ Upstream commit b99234b918c6e36b9aa0a5b2981e86b6bd11f8e2 ]

The MMIO emulation code for vector instructions is duplicated between
VSX and VMX. When emulating VMX we should check the VMX copy size
instead of the VSX one.

Fixes: acc9eb9305fe ("KVM: PPC: Reimplement LOAD_VMX/STORE_VMX instruction ...")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220125215655.1026224-3-farosas@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/powerpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2ad0ccd202d5..f0c4545dc3ab 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1499,7 +1499,7 @@ int kvmppc_handle_vmx_load(struct kvm_vcpu *vcpu,
 {
 	enum emulation_result emulated = EMULATE_DONE;
 
-	if (vcpu->arch.mmio_vsx_copy_nums > 2)
+	if (vcpu->arch.mmio_vmx_copy_nums > 2)
 		return EMULATE_FAIL;
 
 	while (vcpu->arch.mmio_vmx_copy_nums) {
@@ -1596,7 +1596,7 @@ int kvmppc_handle_vmx_store(struct kvm_vcpu *vcpu,
 	unsigned int index = rs & KVM_MMIO_REG_MASK;
 	enum emulation_result emulated = EMULATE_DONE;
 
-	if (vcpu->arch.mmio_vsx_copy_nums > 2)
+	if (vcpu->arch.mmio_vmx_copy_nums > 2)
 		return EMULATE_FAIL;
 
 	vcpu->arch.io_gpr = rs;
-- 
2.34.1



