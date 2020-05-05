Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482831C4B78
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 03:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgEEBXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 21:23:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:22407 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgEEBXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 21:23:50 -0400
IronPort-SDR: 35XBgMbZdnob1TeKL78eUbvQNqq6dA3mZg8ppHC1N87086UkX2ztrnyc/dw3STS3IMPhCyOkWG
 U6Vj7MHsqHUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 18:23:50 -0700
IronPort-SDR: 1glRIAMBxjR87TBrN1TQRXqyzviknoC4M8eozyI6AfggyydRFJEd5rAbb7qMuS/IE4ot6j5OSf
 HolbMofOg+1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="406663372"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2020 18:23:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Tobias Urdin <tobias.urdin@binero.com>
Subject: [PATCH 4.19 STABLE 0/2] KVM: VMX: Fix null pointer dereference
Date:   Mon,  4 May 2020 18:23:46 -0700
Message-Id: <20200505012348.17099-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A simple fix for a null pointer dereference in vmx_vcpu_run() with an
ugly-but-safe prereq patch.

The fix also has a wart/hack where it marks RSP as clobbered using
ASM_CALL_CONSTRAINT to workaround an issue where the VM-Exit label isn't
found by _something_ during modpost.  I vaguely recall seeing the same
issue when I first worked on this code a few years back.  I think it was
objtool that was confused, but I can't remember the details for the life
of me.  I don't have more cycles to throw at deciphering the thing, and
marking RSP as clobbered is safe, so I went with the hack.

Alternatively, reverting the offending commit (added in v4.19.119) would
fix the immediate issue, but RDX and RSI technically need to be marked as
clobbered even though it's extremely unlikely the compiler will consume
their bad value.  All of the above ugliness seems preferable to leaving a
known bug in place.

Sean Christopherson (2):
  KVM: VMX: Explicitly reference RCX as the vmx_vcpu pointer in asm
    blobs
  KVM: VMX: Mark RCX, RDX and RSI as clobbered in vmx_vcpu_run()'s asm
    blob

 arch/x86/kvm/vmx.c | 89 +++++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 40 deletions(-)

-- 
2.26.0

