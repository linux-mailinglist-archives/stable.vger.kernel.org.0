Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA4A220D77
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgGOM4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgGOM4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 08:56:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F033420657;
        Wed, 15 Jul 2020 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594817782;
        bh=AL0SGIl71lSGZkEwc2Wef9IV3iCoPeybLKFPjUI675c=;
        h=From:To:Cc:Subject:Date:From;
        b=f0pkn+jtKuJ3I4+c47glHA/NWWQAzvmOyjMSGN6kSCg1hlyLHJc5rQOKTi/+EWR69
         JJK1ReTlt8pvUuZPEAYD+aujPfSL6gjooQkZWSkco1D1Rg6CTxPYTJTguxohGQwMW7
         50kwSDXL7u4G2RoLsEyWRXJzVE2tbLxBKmQ0BDc4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jvgxQ-00Bzgo-Ay; Wed, 15 Jul 2020 13:56:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     arnd@arndb.de, sashal@kernel.org, naresh.kamboju@linaro.org,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: [Stable-5.4][PATCH 0/3] arm64: Allow the compat vdso to be disabled at runtime
Date:   Wed, 15 Jul 2020 13:56:11 +0100
Message-Id: <20200715125614.3240269-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, stable@vger.kernel.org, arnd@arndb.de, sashal@kernel.org, naresh.kamboju@linaro.org, mark.rutland@arm.com, will@kernel.org, catalin.marinas@arm.com, daniel.lezcano@linaro.org, vincenzo.frascino@arm.com, linux@arm.linux.org.uk, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of the series that recently went into 5.8. Note
that the first patch is more a complete rewriting than a backport, as
the vdso implementation in 5.4 doesn't have much in common with
mainline. This affects the 32bit arch code in a benign way.

It has seen very little testing, as I don't have the HW that triggers
this issue. I have run it in VMs by faking the CPU MIDR, and nothing
caught fire. Famous last words.

The original cover letter follows.

	M.

The relatively recent introduction of the compat vdso on arm64 has
overlooked its interactions with some of the interesting errata
workarounds, such as ARM64_ERRATUM_1418040 (and its older 1188873
incarnation).

This erratum requires the 64bit kernel to trap 32bit accesses to the
virtual counter and emulate it. When the workaround was introduced,
the compat vdso simply wasn't a thing. Now that the patches have
landed in mainline, we trap the CVTVCT accesses from the vdso.

This can end-up in a nasty loop in the vdso, where the sequence number
changes on each trap, never stabilising, and leaving userspace in a
bit of a funny state (which is why we disable the vdso in most similar
cases). This erratum mentionned above is a bit special in the sense
that in only requires to trap AArch32 accesses, and 64bit tasks can be
left alone. Consequently, the vdso is never disabled and AArch32 tasks
are affected.

Obviously, we really want to retain the 64bit vdso in this case. To
that effect, this series offers a way to disable the 32bit view of the
vdso without impacting its 64bit counterpart, by providing a
"no-compat" vdso clock_mode, and plugging this feature into the
1418040 detection code.


Marc Zyngier (3):
  arm64: Introduce a way to disable the 32bit vdso
  arm64: arch_timer: Allow an workaround descriptor to disable compat
    vdso
  arm64: arch_timer: Disable the compat vdso for cores affected by
    ARM64_WORKAROUND_1418040

 arch/arm/include/asm/clocksource.h            | 11 ++++++++++-
 arch/arm/kernel/vdso.c                        |  2 +-
 arch/arm64/include/asm/arch_timer.h           |  1 +
 arch/arm64/include/asm/clocksource.h          |  5 ++++-
 arch/arm64/include/asm/vdso/clocksource.h     | 14 ++++++++++++++
 .../include/asm/vdso/compat_gettimeofday.h    |  5 +++--
 arch/arm64/include/asm/vdso/gettimeofday.h    |  6 ++++--
 arch/arm64/include/asm/vdso/vsyscall.h        |  4 +---
 drivers/clocksource/arm_arch_timer.c          | 19 +++++++++++++++----
 9 files changed, 53 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm64/include/asm/vdso/clocksource.h

-- 
2.27.0

