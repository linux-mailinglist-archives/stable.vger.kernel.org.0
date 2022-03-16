Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7668E4DB57C
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345970AbiCPP7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237385AbiCPP7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:59:18 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31598DFA5
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:58:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id e13so2164016plh.3
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VvVRu/eQ4rluWWC4xLbR2tgbkWAUCRDnVAYNhV1Z6xc=;
        b=ZjqrN20HwzuM1oMSNhUoegYigq4IxRPEY5tckaE5GmOexfRmjYzyJU3Is5EfSohLjc
         5IfQCNtr4um3ykn8Ny6ya702AAzAxvvwKCs/Mfmb/v3xrntiGm5rKzYiN2f146nj6ZQB
         Xgx4lFiD/vVkTvz/EqJ/ROMmCG/+ShxR2b4V4uDOmMTiuc71ZeecVj53Y8nqtHwSg88v
         mSyrHztWnmC/l7ueJRCZXn+/9NhgiROSWptqvqzNFd94iXPfq4//pIDWVX5lA7XRCsnP
         N8IDGhdthdg7+Ul5CSjnrhukTktFAmAWM7qalS3tXtIcL/nt+cDlLj4N/cEUSozvs+Lt
         AEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VvVRu/eQ4rluWWC4xLbR2tgbkWAUCRDnVAYNhV1Z6xc=;
        b=TXN7wUwfdYAii8WXO64hum3ftw/U6XDS1oSikIBSjxC6g7luQwxROYEJVcyfsveBGl
         YWA8bBPg1wD/IinlbfgaU0GiYH0PiPMtIgkL79uQ7VSWrsPrTTQXlnNBuEv1o/Af4vuL
         1VoDkIqqj9I5e1BfeEZra4/Yi3ZDFwGa6tfwqNm9fUN4DE6hIE4NbYaEcFo7JRqcbonD
         sLQD0zrPhMKYZO2nAHiN+yhCvOulRXrGISQbe3aatyrtmPSrKT4pfoG+czDx7nEMeiUO
         X99vfI8H8NXwjZMGkaEmHPOZt+xqqmKxtNFOiyT5NapqXBd8F1/EGTY7LoT7wBD8XRMb
         JalQ==
X-Gm-Message-State: AOAM531myeHfZFBGQSEnYbMg10mE+gC6pcwbb1I6sYzabkaBUg5WNlA4
        VDGyyBqkD3YPMMM4JFcLo8k7ej5DV5Hi4g==
X-Google-Smtp-Source: ABdhPJzYpDq1JqT2uByKORbx/cHkk8jKoOfzi9fHo6CImOeqTUq4xYBSfNt8AOz818R/FPQcKgtj8w==
X-Received: by 2002:a17:902:ea0d:b0:151:df90:779f with SMTP id s13-20020a170902ea0d00b00151df90779fmr649711plg.1.1647446282681;
        Wed, 16 Mar 2022 08:58:02 -0700 (PDT)
Received: from localhost.localdomain ([122.162.112.252])
        by smtp.gmail.com with ESMTPSA id h10-20020a62830a000000b004f73c34f2e8sm3385369pfe.165.2022.03.16.08.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:58:02 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     ventana-sw-patches@ventanamicro.com
Cc:     Anup Patel <apatel@ventanamicro.com>, stable@vger.kernel.org
Subject: [PATCH] RISC-V: KVM: Don't clear hgatp CSR in kvm_arch_vcpu_put()
Date:   Wed, 16 Mar 2022 21:27:41 +0530
Message-Id: <20220316155741.271494-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We might have RISC-V systems (such as QEMU) where VMID is not part
of the TLB entry tag so these systems will have to flush all TLB
enteries upon any change in hgatp.VMID.

Currently, we zero-out hgatp CSR in kvm_arch_vcpu_put() and we
re-program hgatp CSR in kvm_arch_vcpu_load(). For above described
systems, this will flush all TLB enteries whenever VCPU exits to
user-space hence reducing performance.

This patch fixes above described performance issue by not clearing
hgatp CSR in kvm_arch_vcpu_put().

Fixes: 34bde9d8b9e6 ("RISC-V: KVM: Implement VCPU world-switch")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 624166004e36..6785aef4cbd4 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -653,8 +653,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 				     vcpu->arch.isa);
 	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
 
-	csr_write(CSR_HGATP, 0);
-
 	csr->vsstatus = csr_read(CSR_VSSTATUS);
 	csr->vsie = csr_read(CSR_VSIE);
 	csr->vstvec = csr_read(CSR_VSTVEC);
-- 
2.25.1

