Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF401579E25
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242523AbiGSM6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242477AbiGSM5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:57:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A085C9FB;
        Tue, 19 Jul 2022 05:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A0C3B81B1A;
        Tue, 19 Jul 2022 12:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B988C341CA;
        Tue, 19 Jul 2022 12:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233391;
        bh=ZEvhBsiFb0MsBA5AbLVJ+Wg+sCQobeZjz46lu0goM20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OM6IzAe9YMNOQ8rekMkme+F6QeinKrR6und3ni8dTBDKWytaMQAnxVenlqWqkbL70
         9LVgsdTyxItzUiJn3+q481LINzYFDXKCowOM1Dx9agkxl/ujXT3c2/yi2UJcepamds
         /sqWT+7NdES3Uy55PQpZQQBOZzE79ALE9ujIDdj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Meng <bmeng.cn@gmail.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 089/231] RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()
Date:   Tue, 19 Jul 2022 13:52:54 +0200
Message-Id: <20220719114722.253629343@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit be82abe6a76ba8e76f25312566182b0f13c4fbf9 ]

The kvm_riscv_check_vcpu_requests() is called with SRCU read lock held
and for KVM_REQ_SLEEP request it will block the VCPU without releasing
SRCU read lock. This causes KVM ioctls (such as KVM_IOEVENTFD) from
other VCPUs of the same Guest/VM to hang/deadlock if there is any
synchronize_srcu() or synchronize_srcu_expedited() in the path.

To fix the above in kvm_riscv_check_vcpu_requests(), we should do SRCU
read unlock before blocking the VCPU and do SRCU read lock after VCPU
wakeup.

Fixes: cce69aff689e ("RISC-V: KVM: Implement VCPU interrupts and requests handling")
Reported-by: Bin Meng <bmeng.cn@gmail.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Tested-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Tested-by: Bin Meng <bmeng.cn@gmail.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7461f964d20a..3894777bfa87 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -673,9 +673,11 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
+			kvm_vcpu_srcu_read_unlock(vcpu);
 			rcuwait_wait_event(wait,
 				(!vcpu->arch.power_off) && (!vcpu->arch.pause),
 				TASK_INTERRUPTIBLE);
+			kvm_vcpu_srcu_read_lock(vcpu);
 
 			if (vcpu->arch.power_off || vcpu->arch.pause) {
 				/*
-- 
2.35.1



