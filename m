Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AAE2E984F
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhADPVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbhADPVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:21:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81D77207BC;
        Mon,  4 Jan 2021 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609773665;
        bh=OEqL0DS9evxcnmHPYt2YEDY1jQaDKpzSo3PJ4f2d5vw=;
        h=From:To:Cc:Subject:Date:From;
        b=reIzWMa9qzBVfDC4mGfsBvr1MH/82px3lVg+iPTxQM/76UI7lcU+XePzmrNkSm/zg
         vOBHCBPU0O87aaH/3qPW3mJPzsmhEPbQBoMZGxXA5P+UQZLOKso/N5Q7esXaTj8tv4
         WRabapy0plFtG8ieMxAPPeNFujZTItPJHw5IeeBLtx+pWYxuYw6F6WpyjcTpIp60Ar
         /jp6PRu/iFCOhni8Vbze5m2gRSDud2unvl+2WYJGLkjCeMKuUUmUOvhNA1RVSCOc/Q
         8IZIEUoNVBgO8fPTVDwk0x3x5fwqm9gKeXPCR4H/MfFZ5IjnxZyVvorQROYXcWFKVx
         BBYXigNyiti4Q==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 0/4] sched/idle: Fix missing need_resched() checks after rcu_idle_enter() v2
Date:   Mon,  4 Jan 2021 16:20:54 +0100
Message-Id: <20210104152058.36642-1-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The only code change in this v2 is the use of tif_need_resched() instead
of need_resched() on 3/4 (build issue reported on linux-next).

The rest is added Tested-by and Reviewed-by tags.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	sched/idle-v2

HEAD: c246718af0112c8624ec9c46a85bf0ef1562e050

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      sched/idle: Fix missing need_resched() check after rcu_idle_enter()
      cpuidle: Fix missing need_resched() check after rcu_idle_enter()
      ARM: imx6q: Fix missing need_resched() check after rcu_idle_enter()
      ACPI: processor: Fix missing need_resched() check after rcu_idle_enter()


 arch/arm/mach-imx/cpuidle-imx6q.c |  8 +++++++-
 drivers/acpi/processor_idle.c     | 10 ++++++++--
 drivers/cpuidle/cpuidle.c         | 33 +++++++++++++++++++++++++--------
 kernel/sched/idle.c               | 18 ++++++++++++------
 4 files changed, 52 insertions(+), 17 deletions(-)
