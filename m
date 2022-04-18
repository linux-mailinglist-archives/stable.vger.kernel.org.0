Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEE65050A6
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbiDRM04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238738AbiDRM0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A348A12600;
        Mon, 18 Apr 2022 05:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 408C460F0A;
        Mon, 18 Apr 2022 12:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512A8C385A7;
        Mon, 18 Apr 2022 12:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284422;
        bh=mgiNPNrYV+G7zNOVM3b/+0HrK8qaTh+zhMEjYBOPAb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSusfsMbz9VbkmQOz6aR3ddQ7CMTWdlYR92TkpPgu7vsr6BuFMByT6fUZNYunp8TH
         kc/nVs0DHsjgpYiB5s2EoKOeOwI/0iwqgvVOEqMNEkTlltl9TizYCkehBcq6ppasHI
         2js0q1dX9om/CyeqVbERsrXoRReVpxpw0EMWLhBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 083/219] RISC-V: KVM: include missing hwcap.h into vcpu_fp
Date:   Mon, 18 Apr 2022 14:10:52 +0200
Message-Id: <20220418121208.652849112@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 4054eee9290248bf66c5eacb58879c9aaad37f71 ]

vcpu_fp uses the riscv_isa_extension mechanism which gets
defined in hwcap.h but doesn't include that head file.

While it seems to work in most cases, in certain conditions
this can lead to build failures like

../arch/riscv/kvm/vcpu_fp.c: In function ‘kvm_riscv_vcpu_fp_reset’:
../arch/riscv/kvm/vcpu_fp.c:22:13: error: implicit declaration of function ‘riscv_isa_extension_available’ [-Werror=implicit-function-declaration]
   22 |         if (riscv_isa_extension_available(&isa, f) ||
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../arch/riscv/kvm/vcpu_fp.c:22:49: error: ‘f’ undeclared (first use in this function)
   22 |         if (riscv_isa_extension_available(&isa, f) ||

Fix this by simply including the necessary header.

Fixes: 0a86512dc113 ("RISC-V: KVM: Factor-out FP virtualization into separate
sources")
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_fp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
index 4449a976e5a6..d4308c512007 100644
--- a/arch/riscv/kvm/vcpu_fp.c
+++ b/arch/riscv/kvm/vcpu_fp.c
@@ -11,6 +11,7 @@
 #include <linux/err.h>
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
+#include <asm/hwcap.h>
 
 #ifdef CONFIG_FPU
 void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
-- 
2.35.1



