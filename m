Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669BC15C490
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgBMPse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbgBMP0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:54 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0131E2468A;
        Thu, 13 Feb 2020 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607613;
        bh=9rYXRtb+hbIVNBVwOmVLUHZsQo1KBhoj/7Tz+EAHFLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09np/QoZnf0Jz2+VNBVIz6UfFSC/zxCLyMcpGyQZtHy2GhP+jFNvFuzqt11glx+iR
         xg/HcLvNzxAKLZwr7FR1u13Yos2MbNYlZppV0/jsnLoscBwbPKa/553963Ilh5ql55
         ccTCj4fzsCgDI0vdWq6rIIbSzRKnHoqhlz5qzJ6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH 4.19 39/52] KVM: arm64: pmu: Dont increment SW_INCR if PMCR.E is unset
Date:   Thu, 13 Feb 2020 07:21:20 -0800
Message-Id: <20200213151826.317830136@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit 3837407c1aa1101ed5e214c7d6041e7a23335c6e upstream.

The specification says PMSWINC increments PMEVCNTR<n>_EL1 by 1
if PMEVCNTR<n>_EL0 is enabled and configured to count SW_INCR.

For PMEVCNTR<n>_EL0 to be enabled, we need both PMCNTENSET to
be set for the corresponding event counter but we also need
the PMCR.E bit to be set.

Fixes: 7a0adc7064b8 ("arm64: KVM: Add access handler for PMSWINC register")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200124142535.29386-2-eric.auger@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/pmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -316,6 +316,9 @@ void kvm_pmu_software_increment(struct k
 	if (val == 0)
 		return;
 
+	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
+		return;
+
 	enable = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
 		if (!(val & BIT(i)))


