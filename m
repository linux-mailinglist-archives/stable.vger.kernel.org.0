Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4F25A898
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 11:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIBJ3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 05:29:13 -0400
Received: from foss.arm.com ([217.140.110.172]:34208 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIBJ3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 05:29:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C25C31B;
        Wed,  2 Sep 2020 02:29:12 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABFAC3F68F;
        Wed,  2 Sep 2020 02:29:11 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH stable v5.8 v2 0/2] KVM: arm64: Fix AT instruction handling
Date:   Wed,  2 Sep 2020 10:29:02 +0100
Message-Id: <20200902092904.122477-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes from v1:
- (Re-)adding Marc's review tags from upstream. Differences to the
  original patches are trivial for 2/2, and straight-forward for 1/2.
- Fix spelling of vaxorcism
-------------

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
  KVM: arm64: Add kvm_extable for vaxorcism code
  KVM: arm64: Survive synchronous exceptions caused by AT instructions

 arch/arm64/include/asm/kvm_asm.h | 43 +++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S  |  8 ++++
 arch/arm64/kvm/hyp/entry.S       | 15 +++++---
 arch/arm64/kvm/hyp/hyp-entry.S   | 65 ++++++++++++++++++++------------
 arch/arm64/kvm/hyp/switch.c      | 39 +++++++++++++++++--
 5 files changed, 136 insertions(+), 34 deletions(-)

-- 
2.17.1

