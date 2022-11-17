Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA7562D656
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbiKQJUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239814AbiKQJT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:19:59 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA091AF0B1
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:19:57 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3697bd55974so13554347b3.15
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ACYDPcuAUxUGlMNofZDyVmunW6qXPunSo4acvIqCYtg=;
        b=iW3mvCX5nq7+oa3xMp0QpEHPi4xWRWMH+u4pu7cFAcdgonhPnHDBiGQ8deYhRy8bza
         wZfhLna3K1ZOyk0JCiy16dfyjKd3fZVBAo9q7LdYHLmW+Lz1wCZ9wHvf4dwXDDj0Ig8D
         KT9gLcPxvcc7coyTMlj2pjhuLEctbrMU/O3KqypK4htpNoE4r6QaP7WD9kfRFx9qzz11
         h2dZdcymbVsfaAnq1xw9OmaiHYaVCw+QTnjF3C7BVLgdY47A30KvTveYaFqBitlpyrVj
         RYR7KBwGFOJBH9kBjBquzWdpQSPCQ0jNHWq192AesOoknXss4MVMcnlFBLZ6W7e3QbPH
         OfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ACYDPcuAUxUGlMNofZDyVmunW6qXPunSo4acvIqCYtg=;
        b=hcr1tq6ZyWxdYdicyLqtQO1ZEPRrJ7OtPn9JiU9k17BC9x9zDRYl0jcFEXcsxgp6gB
         4invoAL2TbB2Yt5djJJn5Y+I4ixJutfqyTn4/Y1+DBmuZPjcSX6cY11mfaf6DZyGgMpc
         8vyOPiY28QaGDd1LwyqA200m02fSHeRvwZY4tTfDfcSuLtVI8ew/WPYtvmPVSgcezt2k
         +dJOM9UwUv/Xr6zIcFDS7fsd4AT+Yh5Ka/4Gv18PzrSDek6AEBsrxgKmOTEWnv7c+lOM
         Y2MCnR4PYefOIT1+bvA/S1mWoC8edjYzKEStqPES5tbv2ELDZp4lsUUlxOqC7LH2O+hB
         /pLw==
X-Gm-Message-State: ANoB5pkodSQbHYiUyZaTj+bTmsI7/8kJrOW+IW7+KTYZhBCZwzpw79YE
        lLQ94YC+jLbN++Zb1A+JFlrPBhnNaAQYbsTTYmw/eyIwu/EkiAn9qSlKV7TBCKHRHQ/Fvo0rIVr
        VlFH6cLN1F/tqyiSqiWsiHWMxJmMdJmN71oVj0bleJetQzAs/1i/wyXJOJZMr56v9epM=
X-Google-Smtp-Source: AA0mqf6wTCJbKpovoDP1hLRmgpkF4nOH/oNEcSfcLZ462mhRJedDGEQSPaLDVxjGeg0bUuldcegXWZbmkcNA5A==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a5b:2c6:0:b0:6be:99e7:c5f0 with SMTP id
 h6-20020a5b02c6000000b006be99e7c5f0mr1310537ybp.248.1668676797009; Thu, 17
 Nov 2022 01:19:57 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:18 +0900
Message-Id: <20221117091952.1940850-1-suleiman@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 00/34] Intel RETBleed mitigations for 4.19.
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports the mitigations for RETBleed for Intel CPUs to
the 4.19 kernel.

It's based on the 5.4 [1] and 4.14 [2] backports.

Tested on Skylake Chromebook.

[1] https://lore.kernel.org/stable/20221003131038.12645-1-cascardo@canonical.com/
[2] https://lore.kernel.org/kvm/20221027204801.13146-1-surajjs@amazon.com/

Alexandre Chartre (2):
  x86/bugs: Report AMD retbleed vulnerability
  x86/bugs: Add AMD retbleed= boot parameter

Andrew Cooper (1):
  x86/cpu/amd: Enumerate BTC_NO

Daniel Sneddon (1):
  x86/speculation: Add RSB VM Exit protections

Ingo Molnar (1):
  x86/cpufeature: Fix various quality problems in the
    <asm/cpu_device_hd.h> header

Josh Poimboeuf (8):
  x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
  x86/speculation: Fix firmware entry SPEC_CTRL handling
  x86/speculation: Fix SPEC_CTRL write on SMT state change
  x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
  x86/speculation: Remove x86_spec_ctrl_mask
  KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
  KVM: VMX: Fix IBRS handling after vmexit
  x86/speculation: Fill RSB on vmexit for IBRS

Kan Liang (1):
  x86/cpufeature: Add facility to check for min microcode revisions

Mark Gross (1):
  x86/cpu: Add a steppings field to struct x86_cpu_id

Nathan Chancellor (1):
  x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current

Pawan Gupta (4):
  x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
  x86/bugs: Add Cannon lake to RETBleed affected CPU list
  x86/speculation: Disable RRSBA behavior
  x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS
    parts

Peter Zijlstra (10):
  x86/cpufeatures: Move RETPOLINE flags to word 11
  x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
  x86/entry: Remove skip_r11rcx
  x86/entry: Add kernel IBRS implementation
  x86/bugs: Optimize SPEC_CTRL MSR writes
  x86/bugs: Split spectre_v2_select_mitigation() and
    spectre_v2_user_select_mitigation()
  x86/bugs: Report Intel retbleed vulnerability
  intel_idle: Disable IBRS during long idle
  x86/speculation: Change FILL_RETURN_BUFFER to work with objtool
  x86/common: Stamp out the stepping madness

Suleiman Souhlal (2):
  Revert "x86/speculation: Add RSB VM Exit protections"
  Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"

Thomas Gleixner (2):
  x86/devicetable: Move x86 specific macro out of generic code
  x86/cpu: Add consistent CPU match macros

 .../admin-guide/kernel-parameters.txt         |  13 +
 arch/x86/entry/calling.h                      |  68 +++-
 arch/x86/entry/entry_32.S                     |   2 -
 arch/x86/entry/entry_64.S                     |  34 +-
 arch/x86/entry/entry_64_compat.S              |  11 +-
 arch/x86/include/asm/cpu_device_id.h          | 168 +++++++-
 arch/x86/include/asm/cpufeatures.h            |  18 +-
 arch/x86/include/asm/intel-family.h           |   6 +
 arch/x86/include/asm/msr-index.h              |  10 +
 arch/x86/include/asm/nospec-branch.h          |  53 ++-
 arch/x86/kernel/cpu/amd.c                     |  21 +-
 arch/x86/kernel/cpu/bugs.c                    | 368 ++++++++++++++----
 arch/x86/kernel/cpu/common.c                  |  60 +--
 arch/x86/kernel/cpu/match.c                   |  44 ++-
 arch/x86/kernel/cpu/scattered.c               |   1 +
 arch/x86/kernel/process.c                     |   2 +-
 arch/x86/kvm/svm.c                            |   1 +
 arch/x86/kvm/vmx.c                            |  53 ++-
 arch/x86/kvm/x86.c                            |   4 +-
 drivers/base/cpu.c                            |   8 +
 drivers/cpufreq/acpi-cpufreq.c                |   1 +
 drivers/cpufreq/amd_freq_sensitivity.c        |   1 +
 drivers/idle/intel_idle.c                     |  43 +-
 include/linux/cpu.h                           |   2 +
 include/linux/kvm_host.h                      |   2 +-
 include/linux/mod_devicetable.h               |   4 +-
 tools/arch/x86/include/asm/cpufeatures.h      |   1 +
 27 files changed, 813 insertions(+), 186 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

