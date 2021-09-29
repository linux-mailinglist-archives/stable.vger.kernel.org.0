Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051F441BD86
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 05:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbhI2Dic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 23:38:32 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:23186 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240067AbhI2Dib (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 23:38:31 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HK2825ppyz1DHQ6;
        Wed, 29 Sep 2021 11:35:30 +0800 (CST)
Received: from dggema774-chm.china.huawei.com (10.1.198.216) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 11:36:49 +0800
Received: from use12-sp2.huawei.com (10.67.189.174) by
 dggema774-chm.china.huawei.com (10.1.198.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 29 Sep 2021 11:36:48 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <oss@buserror.net>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        <paul.gortmaker@windriver.com>, <chenhui.zhao@freescale.com>,
        <Yuantian.Tang@feescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <wangle6@huawei.com>, <liuwenliang@huawei.com>,
        <chenjianguo3@huawei.com>, <nixiaoming@huawei.com>
Subject: [PATCH v2 0/2] powerpc:85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n
Date:   Wed, 29 Sep 2021 11:36:44 +0800
Message-ID: <20210929033646.39630-1-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <021a5ee3-25ef-1de4-0111-d4c3281e0f45@huawei.com>
References: <021a5ee3-25ef-1de4-0111-d4c3281e0f45@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.189.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema774-chm.china.huawei.com (10.1.198.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When CONFIG_SMP=y, timebase synchronization is required for mpc8572 when
 the second kernel is started
	arch/powerpc/kernel/smp.c:
	int __cpu_up(unsigned int cpu, struct task_struct *tidle)
	{
		...
		if (smp_ops->give_timebase)
			smp_ops->give_timebase();
		...
	}

	void start_secondary(void *unused)
	{
		...
		if (smp_ops->take_timebase)
			smp_ops->take_timebase();
		...
	}

When CONFIG_HOTPLUG_CPU=n and CONFIG_KEXEC_CORE=n,
 smp_85xx_ops.give_timebase is NULL,
 smp_85xx_ops.take_timebase is NULL,
As a result, the timebase is not synchronized.

test code:
	for i in $(seq 1 3); do taskset 1 date; taskset 2 date; sleep 1; echo;done
log:
	Sat Sep 25 18:50:00 CST 2021
	Sat Sep 25 19:07:47 CST 2021

	Sat Sep 25 18:50:01 CST 2021
	Sat Sep 25 19:07:48 CST 2021

	Sat Sep 25 18:50:02 CST 2021
	Sat Sep 25 19:07:49 CST 2021

Code snippet about give_timebase and take_timebase assignments:
	arch/powerpc/platforms/85xx/smp.c:
	#ifdef CONFIG_HOTPLUG_CPU
	#ifdef CONFIG_FSL_CORENET_RCPM
		fsl_rcpm_init();
	#endif
	#ifdef CONFIG_FSL_PMC
		mpc85xx_setup_pmc();
	#endif
		if (qoriq_pm_ops) {
			smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
			smp_85xx_ops.take_timebase = mpc85xx_take_timebase;

config dependency:
	FSL_CORENET_RCPM depends on the PPC_E500MC.
	FSL_PMC depends on SUSPEND.
	SUSPEND depends on ARCH_SUSPEND_POSSIBLE.
	ARCH_SUSPEND_POSSIBLE depends on !PPC_E500MC.

CONFIG_HOTPLUG_CPU and CONFIG_FSL_PMC require the timebase function, but
the timebase should not depend on CONFIG_HOTPLUG_CPU and CONFIG_FSL_PMC.
Therefore, adjust the macro control range. Ensure that the corresponding
 timebase hook function is not empty when the dtsi node is configured.

-----
changes in v2:
 1. add new patch: "powerpc:85xx:Fix oops when mpc85xx_smp_guts_ids node
  cannot be found"
 2. Using !CONFIG_FSL_CORENET_RCPM to manage the timebase code of !PPC_E500MC

v1:
 https://lore.kernel.org/lkml/20210926025144.55674-1-nixiaoming@huawei.com
------

Xiaoming Ni (2):
  powerpc:85xx:Fix oops when mpc85xx_smp_guts_ids node cannot be found
  powerpc:85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n

 arch/powerpc/platforms/85xx/Makefile         |  4 +++-
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c |  7 +++++--
 arch/powerpc/platforms/85xx/smp.c            | 12 ++++++------
 3 files changed, 14 insertions(+), 9 deletions(-)

-- 
2.27.0

