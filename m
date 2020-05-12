Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FCF1CE9A6
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 02:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgELA2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 20:28:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:32296 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgELA2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 20:28:17 -0400
IronPort-SDR: irVu/gOUPhQ0fdf1XTs+ypu9mGjD9RmvjqZLNci1vIW9IdIgaeNLTzf0434h5EFKp5ONEZgbPe
 Xt8aObr48W3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 17:28:16 -0700
IronPort-SDR: ujR2HQuv6H1TjkoPTQX8+gcdLjeHQatSDRxtq9np39AJoGcNUU4FdqvIX9gzHGxg11A1/NRdXL
 uIucyVxe74Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="265331881"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 11 May 2020 17:28:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Tobias Urdin <tobias.urdin@binero.com>
Subject: [PATCH 4.19 STABLE v2 0/2] KVM: VMX: Fix null pointer dereference
Date:   Mon, 11 May 2020 17:28:13 -0700
Message-Id: <20200512002815.2708-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A simple fix for a null pointer dereference in vmx_vcpu_run() with an
ugly-but-safe prereq patch.

The even uglier ASM_CALL_CONSTRAINT is gone in v2 as I finally figured
out why vmx_return was undefined: GCC dropped the entire asm blob because
all outputs were deemed unused.

v2:
  - Document why there is no exact upstream commit for the fix, with
    --verbose. [Greg]
  - Tag the asm blob as volatile and drop the ASM_CALL_CONSTRAINT hack.

Sean Christopherson (2):
  KVM: VMX: Explicitly reference RCX as the vmx_vcpu pointer in asm
    blobs
  KVM: VMX: Mark RCX, RDX and RSI as clobbered in vmx_vcpu_run()'s asm
    blob

 arch/x86/kvm/vmx.c | 91 +++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 41 deletions(-)

-- 
2.26.0

