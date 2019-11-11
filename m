Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555F1F83A2
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 00:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKKXhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 18:37:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:41352 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfKKXhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 18:37:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 15:37:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,294,1569308400"; 
   d="scan'208";a="197848767"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 11 Nov 2019 15:37:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 STABLE 0/2] KVM: x86: PAE related bug fixes
Date:   Mon, 11 Nov 2019 15:37:16 -0800
Message-Id: <20191111233718.28438-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The primary goal is to land patch 2/2 (from Paolo), which fixes a reported
crash when running 64-bit KVM guests on systems without unrestricted guest
support.

Attempting to cherry-pick Paolo's patch revealed that a similar PAE bug
fix from Junaid was also missing.  Grab Junaid's patch as a prerequisite,
even though it will effectively be overwritten, so that Paolo's upstream
fix can be applied without modification (sans the vmx.c split in 5.x).

Junaid Shahid (1):
  kvm: mmu: Don't read PDPTEs when paging is not enabled

Paolo Bonzini (1):
  KVM: x86: introduce is_pae_paging

 arch/x86/kvm/vmx.c | 7 +++----
 arch/x86/kvm/x86.c | 8 ++++----
 arch/x86/kvm/x86.h | 5 +++++
 3 files changed, 12 insertions(+), 8 deletions(-)

-- 
2.24.0

