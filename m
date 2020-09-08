Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A936C261B4C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgIHTBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731288AbgIHQIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:08:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5655B23F27;
        Tue,  8 Sep 2020 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580074;
        bh=ZRfatkYT7SOEsW5WgdoVBOIPUTMx9SUZVfoN5i8zkWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+t32ihiHJlVIMhRbaks317AtkjEWzExkxfW1HkR2SF+jMxR4CQNgeBav9ulP1H3V
         TwST0dVCcoNCIpKjF5VCTL4OLNf8mcuQL6YshLGhDzKWTK9PTzwdsoul1d7DiWGadq
         OLnmN3xkjhEGdgX2il1aHs9XsCQlMChC7yMGZSns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/88] MIPS: BMIPS: Also call bmips_cpu_setup() for secondary cores
Date:   Tue,  8 Sep 2020 17:25:22 +0200
Message-Id: <20200908152222.135718416@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit e14f633b66902615cf7faa5d032b45ab8b6fb158 ]

The initialization done by bmips_cpu_setup() typically affects both
threads of a given core, on 7435 which supports 2 cores and 2 threads,
logical CPU number 2 and 3 would not run this initialization.

Fixes: 738a3f79027b ("MIPS: BMIPS: Add early CPU initialization code")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/smp-bmips.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index 5ec546b5eed1c..d16e6654a6555 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -240,6 +240,8 @@ static int bmips_boot_secondary(int cpu, struct task_struct *idle)
  */
 static void bmips_init_secondary(void)
 {
+	bmips_cpu_setup();
+
 	switch (current_cpu_type()) {
 	case CPU_BMIPS4350:
 	case CPU_BMIPS4380:
-- 
2.25.1



