Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACCE4DBE65
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 06:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiCQFex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 01:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCQFew (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 01:34:52 -0400
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4AA2335E0
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:02:32 -0700 (PDT)
Received: by mail-qv1-f45.google.com with SMTP id r1so3447940qvr.12
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VvVRu/eQ4rluWWC4xLbR2tgbkWAUCRDnVAYNhV1Z6xc=;
        b=M8svGS/iYe/6Axq12vi5bRDCEMlzc6Ij8qRz9Jv2zShz/ObYi/K8LvxnXddnqwdlZ5
         Hy8n9AmCKbusB4osSPTnHAVp8vUxmh7SSg9lwbwwufhybms+bvk63V8UIvo3q7mbeWUr
         ms0f7znXjC7cHbVmrOohql/i6f8ctFGbu8I9sNEgFyiZeOLtmREtacl8Yw4snmOA8pXM
         kQilYsz8Wh8v2crCMneeQf+7yJnPEZ2x4vdo/qdi/D/NOFRsSbZ+5MsxXFKvgaMYLpf+
         WUk8rZ4g3h3S5QvnL30UOp/JJuMmWm3L6uvPr4rQBgKs/g6hiojbCciTRUP/h0N9SzjX
         D/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VvVRu/eQ4rluWWC4xLbR2tgbkWAUCRDnVAYNhV1Z6xc=;
        b=gLPcROG0D2p9CBAzcSe9yoeibFSa0kY36oCMoBqSTaJb35QczAKUEacJN3Pwu4wGs2
         Cf+VyY/Ya9qcBrxFtPHqYEQ8Av0C9yh2zENVCSs5Y/JMc4sD0qeatyeS+yc23uekrRig
         BZNkcQAnh87F6BZ/XU/T5f0HioZY5xdnBECbS0/2iv2m7/qqC7h8vK27dLFXvqzbe1oc
         IxiPZeQ7l7F/wXdIBa7EIj5xBCprKcfHMHor2/hpDM+SbiZ/IlgVZIgx6jlHvxG6oRW9
         QstbIqKdBnNmhTW/k8SOL3uJP7IIlaXk+ISecyUisLGIeM91IPr1yij0UHbNmlah94xq
         pzdA==
X-Gm-Message-State: AOAM532R/odSNM2HqNtDGsHVghftzBPyyCEaVv/onJsOYwkwjMik3iP9
        cxCRkzh/mw6CZEgHyQnw+Wpi8nOm6leTjA==
X-Google-Smtp-Source: ABdhPJyi19/Qz8TowVm2OmKd/W9qF6RFe2vVau6sqR7JL6Hr7iGFozZcp/GI1PSjE0Jf1/f0WMuLow==
X-Received: by 2002:a17:903:234d:b0:153:b63f:8abf with SMTP id c13-20020a170903234d00b00153b63f8abfmr3060697plh.51.1647489342392;
        Wed, 16 Mar 2022 20:55:42 -0700 (PDT)
Received: from localhost.localdomain ([122.171.160.59])
        by smtp.gmail.com with ESMTPSA id 132-20020a62168a000000b004f40e8b3133sm5074436pfw.188.2022.03.16.20.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:55:41 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        stable@vger.kernel.org
Subject: [PATCH] RISC-V: KVM: Don't clear hgatp CSR in kvm_arch_vcpu_put()
Date:   Thu, 17 Mar 2022 09:25:21 +0530
Message-Id: <20220317035521.272486-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

