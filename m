Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC25B49A4D0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354994AbiAYAEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835200AbiAXX2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4BBC06137D;
        Mon, 24 Jan 2022 13:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 149FFB8123A;
        Mon, 24 Jan 2022 21:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D7CC340E4;
        Mon, 24 Jan 2022 21:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060005;
        bh=6CwbdUP4ArC4/Ck5geh/sApqB5cTzwvQjDurpINfABc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hU3k0x9Zec7rdHcx652bIfCY0hHbKEq7oAPdJItOH51xaUl2f0RUxUS4gPZfsFJ6k
         MMfzMVLKTAHiJA6b+sh85RPItndC89tc0hyth2TH+hw0FEGPjLBqPwnY3e6unxjZBZ
         b7k5D93ptRxepU0y9Lhn9yUKyyjtYxlJaks0QRg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup.patel@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0808/1039] KVM: RISC-V: Avoid spurious virtual interrupts after clearing hideleg CSR
Date:   Mon, 24 Jan 2022 19:43:17 +0100
Message-Id: <20220124184152.471697105@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit 33e5b5746cc2336660c8710ba109d9a3923627b5 ]

When the last VM is terminated, the host kernel will invoke function
hardware_disable_nolock() on each CPU to disable the related virtualization
functions. Here, RISC-V currently only clears hideleg CSR and hedeleg CSR.
This behavior will cause the host kernel to receive spurious interrupts if
hvip CSR has pending interrupts and the corresponding enable bits in vsie
CSR are asserted. To avoid it, hvip CSR and vsie CSR must be cleared
before clearing hideleg CSR.

Fixes: 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 421ecf4e6360b..2e5ca43c8c49e 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -58,6 +58,14 @@ int kvm_arch_hardware_enable(void)
 
 void kvm_arch_hardware_disable(void)
 {
+	/*
+	 * After clearing the hideleg CSR, the host kernel will receive
+	 * spurious interrupts if hvip CSR has pending interrupts and the
+	 * corresponding enable bits in vsie CSR are asserted. To avoid it,
+	 * hvip CSR and vsie CSR must be cleared before clearing hideleg CSR.
+	 */
+	csr_write(CSR_VSIE, 0);
+	csr_write(CSR_HVIP, 0);
 	csr_write(CSR_HEDELEG, 0);
 	csr_write(CSR_HIDELEG, 0);
 }
-- 
2.34.1



