Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB2521A1E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbiEJNxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244958AbiEJNrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2752317D7;
        Tue, 10 May 2022 06:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A314E615C8;
        Tue, 10 May 2022 13:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2CFC385A6;
        Tue, 10 May 2022 13:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189580;
        bh=qotNt6/xEPZX16CKagFcCW/pd3anehroTyUMB8vdWR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0V7Up6+YARDe1ULmVCkJ5+K4EHqaZHHo1WtkaNmipkKcqGBCw4IHYhHefs8stBtb
         IBYniSuwAckqcuJrWtPkLwRhir/9XYkiznL2Hgn9gL0Cw++xmoXWC84sIo9j2wDtYv
         OLiridm3I7gT13iFEuBUdbWVw02+0+eQeVWqZ4Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/135] KVM: x86: Do not change ICR on write to APIC_SELF_IPI
Date:   Tue, 10 May 2022 15:07:59 +0200
Message-Id: <20220510130743.191446128@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit d22a81b304a27fca6124174a8e842e826c193466 ]

Emulating writes to SELF_IPI with a write to ICR has an unwanted side effect:
the value of ICR in vAPIC page gets changed.  The lists SELF_IPI as write-only,
with no associated MMIO offset, so any write should have no visible side
effect in the vAPIC page.

Reported-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4d92fb4fdf69..83d1743a1dd0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2125,10 +2125,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic)) {
-			kvm_lapic_reg_write(apic, APIC_ICR,
-					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
-		} else
+		if (apic_x2apic_mode(apic))
+			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
+		else
 			ret = 1;
 		break;
 	default:
-- 
2.35.1



