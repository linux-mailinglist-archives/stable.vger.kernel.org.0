Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7011A551A33
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244689AbiFTNFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244923AbiFTNEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3698186FE;
        Mon, 20 Jun 2022 05:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BC82B811B9;
        Mon, 20 Jun 2022 12:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2628C3411C;
        Mon, 20 Jun 2022 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729960;
        bh=V0hnx/OqzswVYqIqJ7kc+Fe522IaypFMS8wlfWSPkHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=roJIL/2SRH52DPl0lVBlGRAJAa7j+W9STncuOYTZnu8nu7vZ9DkJQYQi1X1W3VNRC
         PXrYxwYlpWh15XA6uY04OH2leH4PHVtsfVTG8ZVzaUX+eZ/zDAtU0OTo0Zt/DmUyT2
         I/GvDp1eIgbidgSkQUB9HdBW3buJnngoOQAk7mrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.18 131/141] KVM: arm64: Always start with clearing SVE flag on load
Date:   Mon, 20 Jun 2022 14:51:09 +0200
Message-Id: <20220620124733.428882608@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit d52d165d67c5aa26c8c89909003c94a66492d23d upstream.

On each vcpu load, we set the KVM_ARM64_HOST_SVE_ENABLED
flag if SVE is enabled for EL0 on the host. This is used to restore
the correct state on vpcu put.

However, it appears that nothing ever clears this flag. Once
set, it will stick until the vcpu is destroyed, which has the
potential to spuriously enable SVE for userspace.

We probably never saw the issue because no VMM uses SVE, but
that's still pretty bad. Unconditionally clearing the flag
on vcpu load addresses the issue.

Fixes: 8383741ab2e7 ("KVM: arm64: Get rid of host SVE tracking/saving")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220528113829.1043361-2-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/fpsimd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -80,6 +80,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vc
 	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
+	vcpu->arch.flags &= ~KVM_ARM64_HOST_SVE_ENABLED;
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
 }


