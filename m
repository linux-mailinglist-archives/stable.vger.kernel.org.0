Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDCC35AEAE
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhDJPMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 11:12:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhDJPMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 11:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618067553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aLP+qJ58JyOHR0t3LnIIqaqKNGbep4094fX8j1+aZ48=;
        b=C7EKgXA++aGHqq9E6E1W+446DEogLj8ifBah767KnyLokNNPwtOZnZoLnDuu7VDlclPR1u
        117jrULC1l5YhBhBieIiaikvwqruqEHu98f0LW7Dzu6SvecZPKI1TGu3ND4y4eQE58W5zJ
        yMxozEDdgCv8E0rayj3vE41Nuv8rz9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-EvZmBmH4PA-4nn-rj2UP8w-1; Sat, 10 Apr 2021 11:12:31 -0400
X-MC-Unique: EvZmBmH4PA-4nn-rj2UP8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E94F801814;
        Sat, 10 Apr 2021 15:12:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CA735D9D3;
        Sat, 10 Apr 2021 15:12:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, sasha@kernel.org
Subject: [PATCH 5.10/5.11 0/9] Fix missing TLB flushes in TDP MMU
Date:   Sat, 10 Apr 2021 11:12:20 -0400
Message-Id: <20210410151229.4062930-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The new MMU for two-dimensional paging had some missing TLB flushes
in 5.10 and 5.11.  This series backports some generic improvements
to simplify the backport in the last four patches.

Ben Gardon (5):
  KVM: x86/mmu: change TDP MMU yield function returns to match
    cond_resched
  KVM: x86/mmu: Merge flush and non-flush tdp_mmu_iter_cond_resched
  KVM: x86/mmu: Rename goal_gfn to next_last_level_gfn
  KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter
  KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed

Paolo Bonzini (1):
  KVM: x86/mmu: preserve pending TLB flush across calls to
    kvm_tdp_mmu_zap_sp

Sean Christopherson (3):
  KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range
    zap
  KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
  KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages

 arch/x86/kvm/mmu/mmu.c      | 13 ++---
 arch/x86/kvm/mmu/tdp_iter.c | 30 +++--------
 arch/x86/kvm/mmu/tdp_iter.h | 11 +++--
 arch/x86/kvm/mmu/tdp_mmu.c  | 99 ++++++++++++++++++++++++-------------
 arch/x86/kvm/mmu/tdp_mmu.h  | 18 ++++++-
 5 files changed, 103 insertions(+), 68 deletions(-)

-- 
2.26.2

