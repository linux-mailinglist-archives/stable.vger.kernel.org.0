Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2356E45D05F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343588AbhKXWwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244982AbhKXWwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:52:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9078E61074;
        Wed, 24 Nov 2021 22:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794184;
        bh=6N+QaYw1LYPyD6PZUhksPg1JMMXxvlmN2CCpPQwrvnA=;
        h=From:To:Cc:Subject:Date:From;
        b=T+A7G6cKmTVtJe6iOp2b8kKpZVHsvSw8LGcyYV+PYbyn5RTwqDGG+oKAA+6xECwfp
         F0hpfGBNYgyOMVDApxO8HlWyTFvXCqXqcX6oRq8KhZV6h7bPcTiPu5BVUQr/lIr1EV
         bYnGoMZfFgrOOxB+xM6MU0/PyYT5QvxnT2nCeo6VLYatILjm0FSbkO7n1zVpuVsoSq
         bGrUmFl8161XQ6TrGrXxCe7clH00WhjdcT9cqKLASa+NcOz8raK8JDo9xBI7fdM/kR
         bTVprjPk0rU8+C06O2hBbWB4aq/uhWfCKwzPduLAVs9mrC9TZLK52DTxDLdIZuifO7
         xyugHKn5v0M1A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 00/24] Armada 3720 PCIe fixes for 4.14
Date:   Wed, 24 Nov 2021 23:49:09 +0100
Message-Id: <20211124224933.24275-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg, Sasha,

this series for 4.14-stable backports all the fixes (and their
dependencies) for Armada 3720 PCIe driver.
These include:
- fixes (and their dependencies) for pci-aardvark controller
- fixes (and their dependencies) for pinctrl-armada-37xx driver
- device-tree fixes

Basically all fixes from upstream are taken, excluding those
that need fix the emulated bridge, since that was introduced
after 4.19. (Should we backport it? It concerns only mvebu and
aardvark controllers...)

Marek

Evan Wang (1):
  PCI: aardvark: Remove PCIe outbound window configuration

Frederick Lawler (1):
  PCI: Add PCI_EXP_LNKCTL2_TLS* macros

Gregory CLEMENT (1):
  pinctrl: armada-37xx: add missing pin: PCIe1 Wakeup

Marek Behún (4):
  PCI: aardvark: Improve link training
  pinctrl: armada-37xx: Correct mpp definitions
  pinctrl: armada-37xx: Correct PWM pins definitions
  arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function

Miquel Raynal (1):
  arm64: dts: marvell: armada-37xx: declare PCIe reset pin

Pali Rohár (12):
  PCI: aardvark: Train link immediately after enabling training
  PCI: aardvark: Issue PERST via GPIO
  PCI: aardvark: Replace custom macros by standard linux/pci_regs.h
    macros
  PCI: aardvark: Indicate error in 'val' when config read fails
  PCI: aardvark: Don't touch PCIe registers if no card connected
  PCI: aardvark: Fix compilation on s390
  PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()
  PCI: aardvark: Update comment about disabling link training
  PCI: aardvark: Configure PCIe resources from 'ranges' DT property
  PCI: aardvark: Fix PCIe Max Payload Size setting
  PCI: aardvark: Fix link training
  PCI: aardvark: Fix checking for link up via LTSSM state

Remi Pommarel (1):
  PCI: aardvark: Wait for endpoint to be ready before training link

Sergei Shtylyov (1):
  PCI: aardvark: Fix I/O space page leak

Thomas Petazzoni (1):
  PCI: aardvark: Introduce an advk_pcie_valid_device() helper

Wen Yang (1):
  PCI: aardvark: Fix a leaked reference by adding missing of_node_put()

 .../pinctrl/marvell,armada-37xx-pinctrl.txt   |  26 +-
 .../arm64/boot/dts/marvell/armada-3720-db.dts |   3 +
 .../dts/marvell/armada-3720-espressobin.dts   |   3 +
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi  |   9 +
 drivers/pci/host/pci-aardvark.c               | 463 ++++++++++++++----
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c   |  28 +-
 include/uapi/linux/pci_regs.h                 |   5 +
 7 files changed, 430 insertions(+), 107 deletions(-)

-- 
2.32.0

