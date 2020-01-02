Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CCA12F14E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgABWOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbgABWOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E321522B48;
        Thu,  2 Jan 2020 22:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003244;
        bh=ep9gLDaU4fQuW4s5VjCKlb/xQtq90DV88lZZIOURVh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKFJOUbK0bu4dGh5ykhBrtXKEYc5tvlddccLA62MS9hoOXH9vikpbeThPR1pQWklQ
         OHpXgMc2SoJl1Ckev71F+FRGt4uVZ9Y8FzUFzCvofiTcIN+7bKE6vgUZlDdO8rsyfl
         y3tFNSJr0mKC6TnIkJiwvFheqx/UclbB6BhYy8h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/191] ARM: 8937/1: spectre-v2: remove Brahma-B53 from hardening
Date:   Thu,  2 Jan 2020 23:06:01 +0100
Message-Id: <20200102215838.371653332@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 4ae5061a19b550dfe25397843427ed2ebab16b16 ]

When the default processor handling was added to the function
cpu_v7_spectre_init() it only excluded other ARM implemented processor
cores. The Broadcom Brahma B53 core is not implemented by ARM so it
ended up falling through into the set of processors that attempt to use
the ARM_SMCCC_ARCH_WORKAROUND_1 service to harden the branch predictor.

Since this workaround is not necessary for the Brahma-B53 this commit
explicitly checks for it and prevents it from applying a branch
predictor hardening workaround.

Fixes: 10115105cb3a ("ARM: spectre-v2: add firmware based hardening")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/proc-v7-bugs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 9a07916af8dd..a6554fdb56c5 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -65,6 +65,9 @@ static void cpu_v7_spectre_init(void)
 		break;
 
 #ifdef CONFIG_ARM_PSCI
+	case ARM_CPU_PART_BRAHMA_B53:
+		/* Requires no workaround */
+		break;
 	default:
 		/* Other ARM CPUs require no workaround */
 		if (read_cpuid_implementor() == ARM_CPU_IMP_ARM)
-- 
2.20.1



