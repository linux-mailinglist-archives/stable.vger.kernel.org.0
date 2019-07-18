Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86216C795
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390077AbfGRDFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390076AbfGRDFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:51 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E97A204EC;
        Thu, 18 Jul 2019 03:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419150;
        bh=ll71j7Z6eqb6ZtBhw+Rmj5cmjVRWfbFb2Cv8/1M6umE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHa9+uWhWCWI37ZVO+FYLDdp6uNGD9GC6iE9pQXPskQKiKRkyiSrwARmHsyEqtOd0
         VXjfXz76e6B8/kryTQzndRX3C3E53rNDsGREslc7FqsUFIYUjoh+K3Hd0K1kcf3Gew
         gQTLadjWfIE1VKk3jpFC2dZfdcubsFX39yF649Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, kernel-janitors@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 20/54] x86/apic: Fix integer overflow on 10 bit left shift of cpu_khz
Date:   Thu, 18 Jul 2019 12:01:15 +0900
Message-Id: <20190718030054.951661808@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
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
index b7bcdd781651..ec6225cb94f9 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1458,7 +1458,8 @@ static void apic_pending_intr_clear(void)
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



