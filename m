Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1748B258C04
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 11:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIAJtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 05:49:51 -0400
Received: from foss.arm.com ([217.140.110.172]:39578 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgIAJtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 05:49:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B466C30E;
        Tue,  1 Sep 2020 02:49:50 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8DE83F71F;
        Tue,  1 Sep 2020 02:49:49 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH stable v5.4 0/3] KVM: arm64: Fix AT instruction handling
Date:   Tue,  1 Sep 2020 10:49:20 +0100
Message-Id: <20200901094923.52486-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some architectural corner cases, AT instructions can generate an
exception, which KVM is not really ready to handle properly.
Teach the code to handle this situation gracefully.

This is a backport of the respective upstream patches to v5.4(.61).
James prepared these already, but we were lacking the upstream commit ID.
I am sending this on his behalf, since he is off this week.

The last two of the patches were tagged Cc: stable already, but did
not apply cleanly, hence this specific backport.

Cheers,
Andre.

James Morse (3):
  KVM: arm64: Add kvm_extable for vaxoricism code
  KVM: arm64: Survive synchronous exceptions caused by AT instructions
  KVM: arm64: Set HCR_EL2.PTW to prevent AT taking synchronous exception

 arch/arm64/include/asm/kvm_arm.h |  3 +-
 arch/arm64/include/asm/kvm_asm.h | 43 +++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S  |  8 ++++
 arch/arm64/kvm/hyp/entry.S       | 15 +++++---
 arch/arm64/kvm/hyp/hyp-entry.S   | 65 ++++++++++++++++++++------------
 arch/arm64/kvm/hyp/switch.c      | 39 +++++++++++++++++--
 6 files changed, 138 insertions(+), 35 deletions(-)

-- 
2.17.1

