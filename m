Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EFA6EAB69
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 15:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjDUNVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 09:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjDUNVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 09:21:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75133CC16;
        Fri, 21 Apr 2023 06:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 147E964FE3;
        Fri, 21 Apr 2023 13:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A393C4339B;
        Fri, 21 Apr 2023 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682083269;
        bh=Acp6hoi+JH4Tq+ReNU90Jlb9X+21PiBtI6Sq2/TYMFk=;
        h=From:To:Cc:Subject:Date:From;
        b=f7zZwuR6KutBIqqlPuTheatBGJajz+aN4IZ5683/3J/IYjkFNmLKJ3czrWcTaY2wM
         lOX1z2RH3CmhyKXS09+KQsw0DHsoKwhKFPHKWNm8TPQvlTa/h6nJzOCVwYe3d8iju3
         M23LANU6+HxEBwo0xXRIw7LqkJJbHMVa4Esqv8LbJpIfESyTDcD5eEh3h693z7q51U
         imUQESICeo9k6H+WXLpGAVRauaPiZmuRCaUNu1ijrP+8gwTEMOKQIlJFBlss3uEv81
         3+q+J2fdMB0U64G9XBXA1Q3Ae/GMyyt65ZyGuif/U5Ok8Ir3UJIGKgtbnELJJzZ2xK
         pgq9tdtHwZKIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ppqhH-00ABDY-3N;
        Fri, 21 Apr 2023 14:21:07 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Alain Volmat <avolmat@me.com>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Bin Meng <bmeng.cn@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guo Ren <guoren@kernel.org>,
        Jianmin Lv <lvjianmin@loongson.cn>,
        Kever Yang <kever.yang@rock-chips.com>,
        Ley Foon Tan <leyfoon.tan@starfivetech.com>,
        Lucas Tanure <lucas.tanure@collabora.com>,
        Mason Huo <mason.huo@starfivetech.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Rob Herring <robh@kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        Sia Jee Heng <jeeheng.sia@starfivetech.com>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        XiaoDong Huang <derrick.huang@rock-chips.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip updates for 6.4
Date:   Fri, 21 Apr 2023 14:21:04 +0100
Message-Id: <20230421132104.3021536-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tglx@linutronix.de, avolmat@me.com, noltari@gmail.com, angelogioacchino.delregno@collabora.com, apatel@ventanamicro.com, atishp@rivosinc.com, bmeng.cn@gmail.com, error27@gmail.com, f.fainelli@gmail.com, guoren@kernel.org, lvjianmin@loongson.cn, kever.yang@rock-chips.com, leyfoon.tan@starfivetech.com, lucas.tanure@collabora.com, mason.huo@starfivetech.com, palmer@rivosinc.com, patrice.chotard@foss.st.com, robh@kernel.org, sebastian.reichel@collabora.com, sdonthineni@nvidia.com, jeeheng.sia@starfivetech.com, stable@vger.kernel.org, sudeep.holla@arm.com, vsethi@nvidia.com, derrick.huang@rock-chips.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thomas,

Here's a small collection of irqchip patches for 6.4. The only
significant thing is the RISC-V IPI rework, which spans both the
irqchip subsystem and the arch code (and is Acked by Palmer).

The rest is a bunch of errata workarounds, fixes and cleanups.

Please pull,

	M.

The following changes since commit 197b6b60ae7bc51dd0814953c562833143b292aa:

  Linux 6.3-rc4 (2023-03-26 14:40:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git tags/irqchip-6.4

for you to fetch changes up to 2ff1b0839ddd514be4752c64c1c6facf91ff3a56:

  Merge branch irq/misc-6.4 into irq/irqchip-next (2023-04-21 14:05:31 +0100)

----------------------------------------------------------------
irqchip changes for 6.4

- Large RISC-V IPI rework to make way for a new interrupt
  architecture

- More Loongarch fixes from Lianmin Lv, fixing issues in the so
  called "dual-bridge" systems.

- Workaround for the nvidia T241 chip that gets confused in
  3 and 4 socket configurations, leading to the GIC
  malfunctionning in some contexts

- Drop support for non-firmware driven GIC configurarations
  now that the old ARM11MP Cavium board is gone

- Workaround for the Rockchip 3588 chip that doesn't
  correctly deal with the shareability attributes.

- Replace uses of of_find_property() with the more appropriate
  of_property_read_bool()

- Make bcm-6345-l1 request its MMIO region

- Add suspend support to the SiFive PLIC

- Drop support for stih415, stih416 and stid127 platforms

----------------------------------------------------------------
Alain Volmat (1):
      irqchip/st: Remove stih415/stih416 and stid127 platforms support

Anup Patel (7):
      RISC-V: Clear SIP bit only when using SBI IPI operations
      irqchip/riscv-intc: Allow drivers to directly discover INTC hwnode
      RISC-V: Treat IPIs as normal Linux IRQs
      RISC-V: Allow marking IPIs as suitable for remote FENCEs
      RISC-V: Use IPIs for remote TLB flush when possible
      RISC-V: Use IPIs for remote icache flush when possible
      irqchip/riscv-intc: Add empty irq_eoi() for chained irq handlers

Jianmin Lv (5):
      irqchip/loongson-eiointc: Fix returned value on parsing MADT
      irqchip/loongson-eiointc: Fix incorrect use of acpi_get_vec_parent
      irqchip/loongson-eiointc: Fix registration of syscore_ops
      irqchip/loongson-pch-pic: Fix registration of syscore_ops
      irqchip/loongson-pch-pic: Fix pch_pic_acpi_init calling

Marc Zyngier (5):
      irqchip/gic: Drop support for board files
      Merge branch irq/gic-6.4 into irq/irqchip-next
      Merge branch irq/riscv-ipi into irq/irqchip-next
      Merge branch irq/loongarch-fixes-6.4 into irq/irqchip-next
      Merge branch irq/misc-6.4 into irq/irqchip-next

Mason Huo (1):
      irqchip/irq-sifive-plic: Add syscore callbacks for hibernation

Rob Herring (1):
      irqchip: Use of_property_read_bool() for boolean properties

Sebastian Reichel (1):
      irqchip/gic-v3: Add Rockchip 3588001 erratum workaround

Shanker Donthineni (1):
      irqchip/gicv3: Workaround for NVIDIA erratum T241-FABRIC-4

Álvaro Fernández Rojas (1):
      irqchip/bcm-6345-l1: Request memory region

 Documentation/arm64/silicon-errata.rst |   5 +
 arch/arm64/Kconfig                     |  10 ++
 arch/riscv/Kconfig                     |   2 +
 arch/riscv/include/asm/irq.h           |   4 +
 arch/riscv/include/asm/sbi.h           |   9 +-
 arch/riscv/include/asm/smp.h           |  49 +++++++---
 arch/riscv/kernel/Makefile             |   1 +
 arch/riscv/kernel/cpu-hotplug.c        |   3 +-
 arch/riscv/kernel/irq.c                |  21 +++-
 arch/riscv/kernel/sbi-ipi.c            |  77 +++++++++++++++
 arch/riscv/kernel/sbi.c                | 100 +++----------------
 arch/riscv/kernel/smp.c                | 171 +++++++++++++++++----------------
 arch/riscv/kernel/smpboot.c            |   5 +-
 arch/riscv/mm/cacheflush.c             |   5 +-
 arch/riscv/mm/tlbflush.c               |  93 +++++++++++++++---
 drivers/clocksource/timer-clint.c      |  65 ++++++++++---
 drivers/firmware/smccc/smccc.c         |  26 +++++
 drivers/firmware/smccc/soc_id.c        |  28 +-----
 drivers/irqchip/Kconfig                |   3 +
 drivers/irqchip/irq-bcm6345-l1.c       |   6 +-
 drivers/irqchip/irq-csky-apb-intc.c    |   2 +-
 drivers/irqchip/irq-gic-v2m.c          |   2 +-
 drivers/irqchip/irq-gic-v3-its.c       |  35 +++++++
 drivers/irqchip/irq-gic-v3.c           | 115 +++++++++++++++++++---
 drivers/irqchip/irq-gic.c              |  60 +-----------
 drivers/irqchip/irq-loongson-eiointc.c |  32 ++++--
 drivers/irqchip/irq-loongson-pch-pic.c |   6 +-
 drivers/irqchip/irq-riscv-intc.c       |  71 ++++++++------
 drivers/irqchip/irq-sifive-plic.c      |  93 +++++++++++++++++-
 drivers/irqchip/irq-st.c               |  15 ---
 include/linux/arm-smccc.h              |  18 ++++
 include/linux/irqchip/arm-gic.h        |   6 --
 32 files changed, 761 insertions(+), 377 deletions(-)
 create mode 100644 arch/riscv/kernel/sbi-ipi.c
