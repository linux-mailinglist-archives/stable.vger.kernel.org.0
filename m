Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74598261C0B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731604AbgIHTNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731203AbgIHQFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AAF623D3A;
        Tue,  8 Sep 2020 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579444;
        bh=TubsAvOUvnEc0JU5BVBrYgM4NGT00W78RmnPF6rvkRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUCNE8Clw/Q0IwoHsCcpr+L+i4kwBJ0yrVWOC7gZ7iLEvNR1nMGDg3bv1cy3XgREu
         a4cT2LXjq26GWWUVoMl5BCZmI5Yg2YG7nQ0HFnc3CemH8ngwODzwl/KMv1wq8uXYg8
         qNYIYLh53ss1lRgthXSPGNhKqUUb5AJIqGYSOP0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 050/186] MIPS: BMIPS: Also call bmips_cpu_setup() for secondary cores
Date:   Tue,  8 Sep 2020 17:23:12 +0200
Message-Id: <20200908152244.092627326@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
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
index 2f513506a3d52..1dbfb5aadffd6 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -239,6 +239,8 @@ static int bmips_boot_secondary(int cpu, struct task_struct *idle)
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



