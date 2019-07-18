Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01B66C588
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390448AbfGRDH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390444AbfGRDH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:07:29 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 331CC205F4;
        Thu, 18 Jul 2019 03:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419248;
        bh=+aLMt1fy/uI6haRV10yA2RxZH9dLBlZq0WeY9Fm1h5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFajYKcpBXgImxldw7VLLOEs+tJOiNKnwec7XVR0LQA44w6qPF8p8dwtS1LiGJk46
         yym7W5dfQYGloo9h07fzFufF3RnpHTa2BNWHKbiq/b7IrjLsH2wknoh1qsFBgHl1ZU
         2Km3JFIRkcKcaxkXl+bls47DZx23dXfErIJ5GbOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, kernel-janitors@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/47] x86/apic: Fix integer overflow on 10 bit left shift of cpu_khz
Date:   Thu, 18 Jul 2019 12:01:28 +0900
Message-Id: <20190718030049.850839591@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ea136a112d89bade596314a1ae49f748902f4727 ]

The left shift of unsigned int cpu_khz will overflow for large values of
cpu_khz, so cast it to a long long before shifting it to avoid overvlow.
For example, this can happen when cpu_khz is 4194305, i.e. ~4.2 GHz.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: 8c3ba8d04924 ("x86, apic: ack all pending irqs when crashed/on kexec")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: kernel-janitors@vger.kernel.org
Link: https://lkml.kernel.org/r/20190619181446.13635-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 84132eddb5a8..2646234380cc 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1452,7 +1452,8 @@ static void apic_pending_intr_clear(void)
 		if (queued) {
 			if (boot_cpu_has(X86_FEATURE_TSC) && cpu_khz) {
 				ntsc = rdtsc();
-				max_loops = (cpu_khz << 10) - (ntsc - tsc);
+				max_loops = (long long)cpu_khz << 10;
+				max_loops -= ntsc - tsc;
 			} else {
 				max_loops--;
 			}
-- 
2.20.1



