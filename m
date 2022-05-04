Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6451AA3B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357026AbiEDRWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357119AbiEDROs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D054199
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BE7761931
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400F4C385A4;
        Wed,  4 May 2022 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683479;
        bh=wDDbGq1dZQEk6f1fMuHa1Ic3Mts7qRhaIEO5x7Sb0gA=;
        h=From:To:Cc:Subject:Date:From;
        b=WTUugi8p+0IUDBCi7Md9suJfVsCtfdnlEPkferpFo8oIndg6GZ+wPRockLx+TetWy
         piUW803FFjCCRPzGoZjSk2Sh3V9Jm3UO1+emzZff5r8mTlXP/00ovWoj8mtNkScdaX
         eCCk5Y46ryhi2UiT1dxDZTQzGgmiOVgF3mKmrDNhxV7PZoxKGSXKPXGJjA+/B2UaZh
         eFKxZhOeHDM5Zu2AP6VwVMB1Q8f50Jmrt39EzoCHysp263PacKhK3nhQ3Vu+7ZT5e1
         qSup3EEic5YIlTpQ/jgBu8CNJxMhPWXExC00wtoGiFPVphAMwuThlIVQFjOP+xFvKm
         trGKUzlR8ZRnQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 00/30] PCIe Aardvark controller backports for 5.15
Date:   Wed,  4 May 2022 18:57:25 +0200
Message-Id: <20220504165755.30002-1-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg, Sasha,

this is backport of all the recet changes for the Aardvark PCIe controller
for 5.15.
These include
- memory leak fix in driver unbind
- more complete driver unbind
- fixes for MSI support
- add MSI-X support, which fixes support for some cards
- add ERR interrupt support (which we really missed when debugging)

I also included some small cosmetic changes - this will make it easier
to backport next fixes for the driver (there is another batch pending
on linux-pci).

Marek

Marek Behún (5):
  PCI: aardvark: Make MSI irq_chip structures static driver structures
  PCI: aardvark: Make msi_domain_info structure a static driver
    structure
  PCI: aardvark: Use dev_fwnode() instead of
    of_node_to_fwnode(dev->of_node)
  PCI: aardvark: Drop __maybe_unused from advk_pcie_disable_phy()
  PCI: aardvark: Update comment about link going down after link-up

Pali Rohár (25):
  PCI: pci-bridge-emul: Add description for class_revision field
  PCI: pci-bridge-emul: Add definitions for missing capabilities
    registers
  PCI: aardvark: Add support for DEVCAP2, DEVCTL2, LNKCAP2 and LNKCTL2
    registers on emulated bridge
  PCI: aardvark: Clear all MSIs at setup
  PCI: aardvark: Comment actions in driver remove method
  PCI: aardvark: Disable bus mastering when unbinding driver
  PCI: aardvark: Mask all interrupts when unbinding driver
  PCI: aardvark: Fix memory leak in driver unbind
  PCI: aardvark: Assert PERST# when unbinding driver
  PCI: aardvark: Disable link training when unbinding driver
  PCI: aardvark: Disable common PHY when unbinding driver
  PCI: aardvark: Replace custom PCIE_CORE_INT_* macros with
    PCI_INTERRUPT_*
  PCI: aardvark: Rewrite IRQ code to chained IRQ handler
  PCI: aardvark: Check return value of generic_handle_domain_irq() when
    processing INTx IRQ
  PCI: aardvark: Refactor unmasking summary MSI interrupt
  PCI: aardvark: Add support for masking MSI interrupts
  PCI: aardvark: Fix setting MSI address
  PCI: aardvark: Enable MSI-X support
  PCI: aardvark: Add support for ERR interrupt on emulated bridge
  PCI: aardvark: Optimize writing PCI_EXP_RTCTL_PMEIE and
    PCI_EXP_RTSTA_PME on emulated bridge
  PCI: aardvark: Add support for PME interrupts
  PCI: aardvark: Fix support for PME requester on emulated bridge
  PCI: aardvark: Use separate INTA interrupt for emulated root bridge
  PCI: aardvark: Remove irq_mask_ack() callback for INTx interrupts
  PCI: aardvark: Don't mask irq when mapping

 drivers/pci/controller/pci-aardvark.c | 428 +++++++++++++++++++-------
 drivers/pci/pci-bridge-emul.c         |  49 ++-
 2 files changed, 371 insertions(+), 106 deletions(-)

-- 
2.35.1

