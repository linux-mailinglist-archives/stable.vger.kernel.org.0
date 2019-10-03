Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E079CA9DC
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbfJCRAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730540AbfJCQpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:45:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A2120865;
        Thu,  3 Oct 2019 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121143;
        bh=CguQhBGjD/VMo7E6gLNngt9pIJo06htO8RE80jx/QE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3ZeyPJ/iE/kLs/vF2VROrP1aWOEa8bWyX2civ1SdGL9QiAyZIuZESKf/zYevkJY7
         vMvI9vee0Uubxgujy3uBkIpkxxkZW33tyEAYum/CHv/qPcBb4kM0iooXdAGN2seiFF
         kcYFTGqg0T+8le2MJYhnIPGvRpDtMTvWISJCRSAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, djuran@redhat.com,
        Neil Horman <nhorman@tuxdriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 170/344] x86/apic/vector: Warn when vector space exhaustion breaks affinity
Date:   Thu,  3 Oct 2019 17:52:15 +0200
Message-Id: <20191003154557.003290302@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 743dac494d61d991967ebcfab92e4f80dc7583b3 ]

On x86, CPUs are limited in the number of interrupts they can have affined
to them as they only support 256 interrupt vectors per CPU. 32 vectors are
reserved for the CPU and the kernel reserves another 22 for internal
purposes. That leaves 202 vectors for assignement to devices.

When an interrupt is set up or the affinity is changed by the kernel or the
administrator, the vector assignment code attempts to honor the requested
affinity mask. If the vector space on the CPUs in that affinity mask is
exhausted the code falls back to a wider set of CPUs and assigns a vector
on a CPU outside of the requested affinity mask silently.

While the effective affinity is reflected in the corresponding
/proc/irq/$N/effective_affinity* files the silent breakage of the requested
affinity can lead to unexpected behaviour for administrators.

Add a pr_warn() when this happens so that adminstrators get at least
informed about it in the syslog.

[ tglx: Massaged changelog and made the pr_warn() more informative ]

Reported-by: djuran@redhat.com
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: djuran@redhat.com
Link: https://lkml.kernel.org/r/20190822143421.9535-1-nhorman@tuxdriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/vector.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index fdacb864c3dd4..2c5676b0a6e7f 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -398,6 +398,17 @@ static int activate_reserved(struct irq_data *irqd)
 		if (!irqd_can_reserve(irqd))
 			apicd->can_reserve = false;
 	}
+
+	/*
+	 * Check to ensure that the effective affinity mask is a subset
+	 * the user supplied affinity mask, and warn the user if it is not
+	 */
+	if (!cpumask_subset(irq_data_get_effective_affinity_mask(irqd),
+			    irq_data_get_affinity_mask(irqd))) {
+		pr_warn("irq %u: Affinity broken due to vector space exhaustion.\n",
+			irqd->irq);
+	}
+
 	return ret;
 }
 
-- 
2.20.1



