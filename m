Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0FA258CDF
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 12:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgIAKfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 06:35:54 -0400
Received: from foss.arm.com ([217.140.110.172]:40198 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgIAKfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 06:35:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34CA31045;
        Tue,  1 Sep 2020 03:35:53 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69C233F71F;
        Tue,  1 Sep 2020 03:35:52 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH stable v5.8 0/2] KVM: arm64: Fix AT instruction handling
Date:   Tue,  1 Sep 2020 11:35:44 +0100
Message-Id: <20200901103546.53302-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some architectural corner cases, AT instructions can generate an
exception, which KVM is not really ready to handle properly.
Teach the code to handle this situation gracefully.

This is a backport of the respective upstream patches to v5.8(.5).
James prepared and tested these already, but we were lacking the upstream
commit ID so far.
I am sending this on his behalf, since he is off this week.

The last two of the originally three patches were tagged Cc: stable
already, but 2/3 did not apply cleanly, hence this specific backport.
3/3 has already been added to stable-queue, so I am dropping it from
this post.

Cheers,
Andre.

James Morse (2):
  KVM: arm64: Add kvm_extable for vaxoricism code
  KVM: arm64: Survive synchronous exceptions caused by AT instructions

 arch/arm64/include/asm/kvm_asm.h | 43 +++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S  |  8 ++++
 arch/arm64/kvm/hyp/entry.S       | 15 +++++---
 arch/arm64/kvm/hyp/hyp-entry.S   | 65 ++++++++++++++++++++------------
 arch/arm64/kvm/hyp/switch.c      | 39 +++++++++++++++++--
 5 files changed, 136 insertions(+), 34 deletions(-)

-- 
2.17.1

