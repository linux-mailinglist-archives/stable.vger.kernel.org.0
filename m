Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D016745D0BC
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352381AbhKXXIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352403AbhKXXIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF8136108B;
        Wed, 24 Nov 2021 23:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795104;
        bh=MJwDB1XRawIbDFMqqPVk7BXTtx+KK/yHMIhcl8k/thU=;
        h=From:To:Cc:Subject:Date:From;
        b=Knpg6B+D1hdlDgUvY63ndM6tXftYqOUn/HtFsPijrEnndj/DdRol8gYcEQsSJ49jX
         4MPxlJcMGALZ0fF4aD1bvVQ37Afnrt87V4qB19+mmOFUTTmCuROyXeMPtZGVUqV6rn
         sI3DOht+aANHhaNldOoe1FMmQq8C5gPj4pTnT1jURF2vhg1hDS0a7wHP1OOuXBYrJ5
         zWp5uc4O7nK8XqNCmQfkq5IARfy5ZXNdNBosl1nzlEMIyoGTG9z8fwxpHGRNvLNiZk
         fQm/Wdj4IxjPdh1WawaSci/eK5TpupnwyWu7Cmh6eIDshSSMaJ0b3iCIWjvAkU0fdP
         FG0aEczfAVxng==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 00/20] Armada 3720 PCIe fixes for 4.19
Date:   Thu, 25 Nov 2021 00:04:40 +0100
Message-Id: <20211124230500.27109-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg, Sasha,

this series for 4.19-stable backports all the fixes (and their
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

Wen Yang (1):
  PCI: aardvark: Fix a leaked reference by adding missing of_node_put()

 .../pinctrl/marvell,armada-37xx-pinctrl.txt   |  26 +-
 .../arm64/boot/dts/marvell/armada-3720-db.dts |   3 +
 .../dts/marvell/armada-3720-espressobin.dts   |   3 +
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi  |   9 +
 drivers/pci/controller/pci-aardvark.c         | 436 ++++++++++++++++--
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c   |  28 +-
 6 files changed, 434 insertions(+), 71 deletions(-)

-- 
2.32.0

