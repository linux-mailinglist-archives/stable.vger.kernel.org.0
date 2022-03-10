Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316604D540C
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 22:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbiCJWAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiCJWAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:00:51 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A291BFFF9B;
        Thu, 10 Mar 2022 13:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646949589; x=1678485589;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=FEokJvQzJlhDxejbSYmWT7ArZenBUqb9cjdUyXyHjIo=;
  b=M6W905Kcl0/f+eAfnp+3AEuEFTySJPQ3Qnv2x5szYpy+kopFRbBsZLRP
   z11F9Nabj5+WVsspAFVfvF7qfdCQVR95rW/EHxogaVGeDCLZv91L0czPU
   OBO7ybyQrsgl1pgqQOTCXBKOWUVQ7UkrI0Mby5x7wslTkY2ma3TBjmp/A
   zDZ1sU8vGyUDf/kwwWckfVCKs1KiKir53tRAtV4Mh4VHqpxA+ODWQJjrS
   yp4SJezUL2ImQz8uyrqk+bJ5nArgozsOF4XU79krGi9AU7lAR7sd5csrt
   JwWZi4ZkVKudgIaKIbUFnmHHnT+benJo4GaYKE3MWX/8I1cEN9+NFUNS2
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="235994336"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="235994336"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 13:59:49 -0800
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="633153907"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.209.31.141])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 13:59:48 -0800
Date:   Thu, 10 Mar 2022 13:59:47 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 0/2] TSX update
Message-ID: <cover.1646943780.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v2:
- Added patch to disable TSX development mode (Andrew, Boris)
- Rebased to v5.17-rc7

v1: https://lore.kernel.org/lkml/5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com/

Hi,

After a recent microcode update some Intel processors will always abort
Transactional Synchronization Extensions (TSX) transactions [*]. On
these processors a new CPUID bit,
CPUID.07H.0H.EDX[11](RTM_ALWAYS_ABORT), will be enumerated to indicate
that the loaded microcode is forcing Restricted Transactional Memory
(RTM) abort. If the processor enumerated support for RTM previously, the
CPUID enumeration bits for TSX (CPUID.RTM and CPUID.HLE) continue to be
set by default after the microcode update.

First patch in this series clears CPUID.RTM and CPUID.HLE so that
userspace doesn't enumerate TSX feature. 

Microcode also added support to re-enable TSX for development purpose,
doing so is not recommended for production deployments, because MD_CLEAR
flows for the mitigation of TSX Asynchronous Abort (TAA) may not be
effective on these processors when TSX is enabled with updated
microcode.

Second patch unconditionally disables this TSX development mode, in case
it was enabled by the software running before kernel boot.

Thanks,
Pawan

[*] Intel Transactional Synchronization Extension (Intel TSX) Disable Update for Selected Processors
    https://cdrdv2.intel.com/v1/dl/getContent/643557

Pawan Gupta (2):
  x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
  x86/tsx: Disable TSX development mode at boot

 arch/x86/include/asm/msr-index.h       |  4 +-
 arch/x86/kernel/cpu/cpu.h              |  1 +
 arch/x86/kernel/cpu/intel.c            |  5 ++
 arch/x86/kernel/cpu/tsx.c              | 88 ++++++++++++++++++++++++--
 tools/arch/x86/include/asm/msr-index.h |  4 +-
 5 files changed, 91 insertions(+), 11 deletions(-)


base-commit: ffb217a13a2eaf6d5bd974fc83036a53ca69f1e2
-- 
2.25.1

