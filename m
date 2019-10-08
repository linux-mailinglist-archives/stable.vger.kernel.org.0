Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA80CFDCF
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfJHPkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34314 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJHPkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id y135so2650156wmc.1
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=diDivMgLXxuR/dp1WMntvozvsVcQ0F0QeA8wBSWu1Ss=;
        b=GVgHpm2UCTHFvL3+smHn0WlrR+C7nsz0x7DXsSgoTVQaBwWZh5Q2YpxtPpMYbDa2rG
         SB5icwZApCsf36zbj1fmz8qmm9JYeieWTgVv3R6tvKkDDVLiDiuUY+yAWbSpOi5hLEI9
         CYyJ/HCs+NSgG6nCL2Ibcia0gF6Oj5xhfKUW8LHZKlwXdfi0XD55sNm2DK9UTOpeEpl/
         DrEHsMKA2dleKinjrLQairFJXEGrIi81A3xIQhUoS7FaaLNge5V7aEcC5B2tM3Kr367M
         dbsSTZTxUMFtWo38Oq7E+5Yo0MzadfDmxa2yJbC7Ww5nYJ7MrNwEso6imysuYcguCs1o
         Te/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=diDivMgLXxuR/dp1WMntvozvsVcQ0F0QeA8wBSWu1Ss=;
        b=p/ThReD35FPk28K1KrQtTjS43bfjf+1efKYUnJV0pgw59Q7OmcSSOggf1aLn3jiFFK
         dBh2Pi4zzPM6EGNnVjbKT8mlMshJ6DpSKhmSbvoDLcp/UtuBIMdSGkmTLACZO8yQJWmZ
         CM5cnHY1N+aFl5ECmsMRrk0FDwNIU6EeMcwrS+mqrOeGSR519Jid97aAtrVDP1ezfbLT
         Ub1XgU9jtdTfLSuZsrHdup26CtMAnC00Bao1CUTWfGcv57QfgGSwPHeKm5+PI7fA0gCi
         Sr+cekLlLzWT7EK5hemmyewr3nM1wofQ9FOIGcCR/t83jZYdvD1B6IVlBz+zOdPVs0qB
         iP5w==
X-Gm-Message-State: APjAAAUvDIE4Bdvu3YQQSNRxFpj5Wf5M/xgJzBX5hV4+TySFDgh+RF4n
        dvIP/ME6YedGS/B/4OhbXdYsHA==
X-Google-Smtp-Source: APXvYqwdJRY6MzBrjAaUva5DmFNlSG5y1BY/jadH0gR+q2kQx8JHKuz+jXYI2UEnZJW7t5OhqiGKXw==
X-Received: by 2002:a7b:cf38:: with SMTP id m24mr3949082wmg.24.1570549208408;
        Tue, 08 Oct 2019 08:40:08 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH for-stable-v4.19 00/16] arm64 spec mitigation backports
Date:   Tue,  8 Oct 2019 17:39:14 +0200
Message-Id: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport to v4.19 of the arm64 patches that exists in mainline
to support CPUs that implement the SSBS capability, which gives the OS
and user space control over whether Speculative Store Bypass is
permitted in certain contexts. This gives a substantial performance
boost on hardware that implements it.

At the same time, this series backports arm64 support for reporting
of vulnerabilities via syfs. This is covered by the same series since
it produces a much cleaner backport, where none of the patches required
any changes beyond some manual mangling of the context to make them apply.

Build tested using a fair number of randconfig builds. Boot tested
under KVM and on ThunderX2.

Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>

Jeremy Linton (6):
  arm64: add sysfs vulnerability show for meltdown
  arm64: Always enable ssb vulnerability detection
  arm64: Provide a command line to disable spectre_v2 mitigation
  arm64: Always enable spectre-v2 vulnerability detection
  arm64: add sysfs vulnerability show for spectre-v2
  arm64: add sysfs vulnerability show for speculative store bypass

Marc Zyngier (2):
  arm64: Advertise mitigation of Spectre-v2, or lack thereof
  arm64: Force SSBS on context switch

Mark Rutland (1):
  arm64: fix SSBS sanitization

Mian Yousaf Kaukab (2):
  arm64: Add sysfs vulnerability show for spectre-v1
  arm64: enable generic CPU vulnerabilites support

Will Deacon (5):
  arm64: cpufeature: Detect SSBS and advertise to userspace
  arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3
  KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and
    !vhe
  arm64: docs: Document SSBS HWCAP
  arm64: ssbs: Don't treat CPUs with SSBS as unaffected by SSB

 Documentation/admin-guide/kernel-parameters.txt |   8 +-
 Documentation/arm64/elf_hwcaps.txt              |   4 +
 arch/arm64/Kconfig                              |   1 +
 arch/arm64/include/asm/cpucaps.h                |   3 +-
 arch/arm64/include/asm/cpufeature.h             |   4 -
 arch/arm64/include/asm/kvm_host.h               |  11 +
 arch/arm64/include/asm/processor.h              |  17 ++
 arch/arm64/include/asm/ptrace.h                 |   1 +
 arch/arm64/include/asm/sysreg.h                 |  19 +-
 arch/arm64/include/uapi/asm/hwcap.h             |   1 +
 arch/arm64/include/uapi/asm/ptrace.h            |   1 +
 arch/arm64/kernel/cpu_errata.c                  | 235 +++++++++++++++-----
 arch/arm64/kernel/cpufeature.c                  | 122 ++++++++--
 arch/arm64/kernel/cpuinfo.c                     |   1 +
 arch/arm64/kernel/process.c                     |  31 +++
 arch/arm64/kernel/ptrace.c                      |  15 +-
 arch/arm64/kernel/ssbd.c                        |  21 ++
 arch/arm64/kvm/hyp/sysreg-sr.c                  |  11 +
 18 files changed, 410 insertions(+), 96 deletions(-)

-- 
2.20.1

