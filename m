Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244F551A9BE
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357079AbiEDRTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357760AbiEDRPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE6E55375
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3D52B8279C
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3128CC385A5;
        Wed,  4 May 2022 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683536;
        bh=corN2fyIXi2jUqWlibDtg8Z/DNEgfwEP72MTe2t6a1k=;
        h=From:To:Cc:Subject:Date:From;
        b=BuON60G8XxUKf7EptAl1dVxiS/1MTqbYBkLW3PeLxBc5cWqmRamMjZl918PBVUahx
         Iv57jULDsmiqgAB7OUs22OfyYsZh5cQE37fsf0Z1Eq+SbNr78HMZ28HHox2klJzucC
         8Ye4Ewq4urtwES7e8wFJDpHCiJNUx7COyNOf9yj8+PxdPGijU7KRd3SnxIJ1GYWK6M
         YphdX6pemIqGufnroEM4Eu/qboyuI70lIf2TlIWYRJWwFTazkQv7tWqPyUunMA5gdq
         GgorXMvzQeD4mBrGgxIYCKDsj0oYk3zn3AcM3+KdR/mxsL51B130dRyser3uPUANhI
         2G+ulm/sd8SxQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.17 00/19] PCIe Aardvark controller backports for 5.17
Date:   Wed,  4 May 2022 18:58:33 +0200
Message-Id: <20220504165852.30089-1-kabel@kernel.org>
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
for 5.17.
These include
- fixes for MSI support
- add MSI-X support, which fixes support for some cards
- add ERR interrupt support (which we really missed when debugging)

As in series for 5.15, I included some small cosmetic changes - this
will make it easier to backport next fixes for the driver (there is
another batch pending on linux-pci).

Marek

Marek Behún (5):
  PCI: aardvark: Make MSI irq_chip structures static driver structures
  PCI: aardvark: Make msi_domain_info structure a static driver
    structure
  PCI: aardvark: Use dev_fwnode() instead of
    of_node_to_fwnode(dev->of_node)
  PCI: aardvark: Drop __maybe_unused from advk_pcie_disable_phy()
  PCI: aardvark: Update comment about link going down after link-up

Pali Rohár (14):
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

 drivers/pci/controller/pci-aardvark.c | 367 +++++++++++++++++++-------
 1 file changed, 266 insertions(+), 101 deletions(-)

-- 
2.35.1

