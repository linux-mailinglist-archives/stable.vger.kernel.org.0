Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F91729B391
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1776607AbgJ0Oxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772941AbgJ0Oui (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:50:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E8F8207DE;
        Tue, 27 Oct 2020 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810236;
        bh=WehOnmvMEltJu9ZF5Z1xoC8xUIS8r926y7Ds5a440hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLjfGubCDErUfw/ZE9vFoiTIrj+ytUPQbt46VbxIGXNJwWqvmTUiDoiorDHf47O9P
         kqOMNCeKinDuCzsWsmioHP/xgJBlRdtgzBV0afILYkFNxO/GS7xeIWlx8OaytZ9z+g
         vX8ymJwKmLkOL1eNdtuCk0Ye2BtEAoUecJrvjS1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.8 068/633] arm64: Make use of ARCH_WORKAROUND_1 even when KVM is not enabled
Date:   Tue, 27 Oct 2020 14:46:51 +0100
Message-Id: <20201027135525.888705944@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit b11483ef5a502663732c6ca1b58d14ff9eedd6f7 upstream.

We seem to be pretending that we don't have any firmware mitigation
when KVM is not compiled in, which is not quite expected.

Bring back the mitigation in this case.

Fixes: 4db61fef16a1 ("arm64: kvm: Modernize __smccc_workaround_1_smc_start annotations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpu_errata.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -234,14 +234,17 @@ static int detect_harden_bp_fw(void)
 		smccc_end = NULL;
 		break;
 
-#if IS_ENABLED(CONFIG_KVM)
 	case SMCCC_CONDUIT_SMC:
 		cb = call_smc_arch_workaround_1;
+#if IS_ENABLED(CONFIG_KVM)
 		smccc_start = __smccc_workaround_1_smc;
 		smccc_end = __smccc_workaround_1_smc +
 			__SMCCC_WORKAROUND_1_SMC_SZ;
-		break;
+#else
+		smccc_start = NULL;
+		smccc_end = NULL;
 #endif
+		break;
 
 	default:
 		return -1;


