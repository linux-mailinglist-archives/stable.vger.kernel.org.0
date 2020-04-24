Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D771B7BC4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgDXQiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:38:55 -0400
Received: from foss.arm.com ([217.140.110.172]:39500 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXQiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 12:38:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75B7331B;
        Fri, 24 Apr 2020 09:38:54 -0700 (PDT)
Received: from melchizedek.cambridge.arm.com (melchizedek.cambridge.arm.com [10.1.196.50])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07C933F68F;
        Fri, 24 Apr 2020 09:38:53 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org
Subject: [stable:PATCH 0/5 v4.19] arm64: Workaround Neoverse-N1 #1542419
Date:   Fri, 24 Apr 2020 17:38:40 +0100
Message-Id: <20200424163845.4141-1-james.morse@arm.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports the Neoverse-N1 #1542419 erratum workaround
to v4.19.116. The series was originally merged in v5.5.

These patches handle user-space. The kernel change was:
commit dd8a1f134884 ("arm64: ftrace: Ensure synchronisation in PLT setup
for Neoverse-N1 #1542419"), which has already been picked up by stable.
(magic!)

Backporting this stuff past v4.19 isn't straight-forward as the kernel
change depends on the work done in:
https://lore.kernel.org/linux-arm-kernel/1529656278-878-1-git-send-email-will.deacon@arm.com/
which was merged for v4.19.

Thanks,

James


Catalin Marinas (1):
  arm64: Silence clang warning on mismatched value/register sizes

James Morse (3):
  arm64: errata: Hide CTR_EL0.DIC on systems affected by Neoverse-N1
    #1542419
  arm64: Fake the IminLine size on systems affected by Neoverse-N1
    #1542419
  arm64: compat: Workaround Neoverse-N1 #1542419 for compat user-space

Marc Zyngier (1):
  arm64: Add part number for Neoverse N1

 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 16 ++++++++++++++++
 arch/arm64/include/asm/cache.h         |  3 ++-
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/cputype.h       |  2 ++
 arch/arm64/kernel/cpu_errata.c         | 22 ++++++++++++++++++++++
 arch/arm64/kernel/sys_compat.c         | 11 +++++++++++
 arch/arm64/kernel/traps.c              |  9 +++++++++
 8 files changed, 65 insertions(+), 2 deletions(-)

-- 
2.26.1

