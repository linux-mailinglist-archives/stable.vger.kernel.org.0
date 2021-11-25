Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443C245D207
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244880AbhKYAbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245018AbhKYA3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:29:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89F560F50;
        Thu, 25 Nov 2021 00:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637799980;
        bh=Wkd2Sj5qOJ+JGHUG0eRP7oM9+abXCkTXd9aIQPpR11c=;
        h=From:To:Cc:Subject:Date:From;
        b=oXdbiWvtFVP8iqftrM8IdXieflbsurrlbJdILVMuLFlFIZXaiVTufjrPwul9sbveQ
         XVRi/H135qhY/eZ+sVl+Y3HtMGREGFVNDqBwnKo8ApBetET/MXUZmzEDfaRcZJ6b9g
         gegKFCMGuMq3Fi0K3Dz5ibYiXqG7VXf3x3EHVjJqjdqMwmxfB9lJ3NOPcvw1ifjxr5
         YC1WZXqnWRzgCdwgYVmzP9FPaochStyo5DoxrOvQXDW+GpQq6kRtHMNsOSZR4XCxIo
         pDAAzcpCJtC30iswesf1PIBkxfkl2OdlXQYseYxccxvdWbbE0xE4iWrSVEa3SVD06n
         MY0Q1NeCFpX3A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 00/22] Armada 3720 PCIe fixes for 5.4
Date:   Thu, 25 Nov 2021 01:25:54 +0100
Message-Id: <20211125002616.31363-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg, Sasha,

this series for 5.4-stable backports all the fixes (and their
dependencies) for Armada 3720 PCIe driver.
These include:
- fixes (and their dependencies) for pci-aardvark controller
- fixes for pci-bridge-emul
- fixes (and their dependencies) for pinctrl-armada-37xx driver
- device-tree fixes

Marek

Grzegorz Jaszczyk (1):
  PCI: aardvark: Fix big endian support

Marek Behún (4):
  PCI: aardvark: Improve link training
  PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
  pinctrl: armada-37xx: Correct PWM pins definitions
  arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function

Pali Rohár (15):
  PCI: aardvark: Train link immediately after enabling training
  PCI: aardvark: Issue PERST via GPIO
  PCI: aardvark: Replace custom macros by standard linux/pci_regs.h
    macros
  PCI: aardvark: Don't touch PCIe registers if no card connected
  PCI: aardvark: Fix compilation on s390
  PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()
  PCI: aardvark: Update comment about disabling link training
  PCI: aardvark: Configure PCIe resources from 'ranges' DT property
  PCI: aardvark: Fix PCIe Max Payload Size setting
  PCI: aardvark: Implement re-issuing config requests on CRS response
  PCI: aardvark: Simplify initialization of rootcap on virtual bridge
  PCI: aardvark: Fix link training
  PCI: aardvark: Fix support for bus mastering and PCI_COMMAND on
    emulated bridge
  PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge
  PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated
    bridge

Remi Pommarel (1):
  PCI: aardvark: Wait for endpoint to be ready before training link

Russell King (1):
  PCI: pci-bridge-emul: Fix array overruns, improve safety

 .../pinctrl/marvell,armada-37xx-pinctrl.txt   |   8 +-
 .../arm64/boot/dts/marvell/armada-3720-db.dts |   3 +
 .../dts/marvell/armada-3720-espressobin.dts   |   1 +
 .../dts/marvell/armada-3720-turris-mox.dts    |   4 -
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi  |   2 +-
 drivers/pci/controller/pci-aardvark.c         | 576 ++++++++++++++----
 drivers/pci/pci-bridge-emul.c                 |  11 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c   |  17 +-
 8 files changed, 489 insertions(+), 133 deletions(-)

-- 
2.32.0

