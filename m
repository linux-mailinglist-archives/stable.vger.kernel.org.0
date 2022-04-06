Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F414F6B21
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbiDFUUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbiDFUTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:19:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2E728D2A0;
        Wed,  6 Apr 2022 11:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01840B824E1;
        Wed,  6 Apr 2022 18:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B25FC385A3;
        Wed,  6 Apr 2022 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269706;
        bh=NgqVS5WrlftclBEuSycZ8OoPFaK+Gbw/CFEjdjdLH8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzSRhOgddLkSmjECL5R9J+p0qSz5XQWO4+szW0tDNy5yLkli3boBGbfl6OYRQ7rML
         yNY/nOs8IyBSuOrDXN2cNBKkXZOmFXAwAPPhf6rVXTFa+JQGm0P8hozXo3XeUlrsSx
         LKjp2QsvaFf1RCxWeyF/CdSzCFvRlnEPK7duwhck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 41/43] KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
Date:   Wed,  6 Apr 2022 20:26:50 +0200
Message-Id: <20220406182437.872916215@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
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

From: James Morse <james.morse@arm.com>

commit a5905d6af492ee6a4a2205f0d550b3f931b03d03 upstream.

KVM allows the guest to discover whether the ARCH_WORKAROUND SMCCC are
implemented, and to preserve that state during migration through its
firmware register interface.

Add the necessary boiler plate for SMCCC_ARCH_WORKAROUND_3.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ kvm code moved to arch/arm/kvm, removed fw regs ABI. Added 32bit stub ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/kvm_host.h   |    5 +++++
 arch/arm/kvm/psci.c               |    4 ++++
 arch/arm64/include/asm/kvm_host.h |    4 ++++
 3 files changed, 13 insertions(+)

--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -349,4 +349,9 @@ static inline int kvm_arm_have_ssbd(void
 	return KVM_SSBD_UNKNOWN;
 }
 
+static inline bool kvm_arm_spectre_bhb_mitigated(void)
+{
+	/* 32bit guests don't need firmware for this */
+	return false;
+}
 #endif /* __ARM_KVM_HOST_H__ */
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -431,6 +431,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			if (kvm_arm_spectre_bhb_mitigated())
+				val = SMCCC_RET_SUCCESS;
+			break;
 		}
 		break;
 	default:
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -452,4 +452,8 @@ static inline int kvm_arm_have_ssbd(void
 	}
 }
 
+static inline bool kvm_arm_spectre_bhb_mitigated(void)
+{
+	return arm64_get_spectre_bhb_state() == SPECTRE_MITIGATED;
+}
 #endif /* __ARM64_KVM_HOST_H__ */


