Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10305505831
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244176AbiDRN7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244623AbiDRN5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:57:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513582AC5E;
        Mon, 18 Apr 2022 06:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03B3DB80EC3;
        Mon, 18 Apr 2022 13:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8AEC385A1;
        Mon, 18 Apr 2022 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287175;
        bh=sBAlfitv7a3m15anPihIPdD3jKEWTRAgL6gHf+iR2EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+waFrOllJ0UgZAyG0jYNwlbRk6SLDK1ii/85/xQQCR/8tNwwmvKtL1YM4jPj7bnn
         Eg3/SmlV0nlA74NzRjRO5YCIrKuvKsQHrVTdp+fxZ6gWtKiIQ5H0jX+pPoNUEgxkka
         3FOR24kRV/s571bZWl3NQj6XqL5G4sOIa9Xh4LHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 4.9 039/218] PCI: pciehp: Clear cmd_busy bit in polling mode
Date:   Mon, 18 Apr 2022 14:11:45 +0200
Message-Id: <20220418121200.638190092@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Liguang Zhang <zhangliguang@linux.alibaba.com>

commit 92912b175178c7e895f5e5e9f1e30ac30319162b upstream.

Writes to a Downstream Port's Slot Control register are PCIe hotplug
"commands."  If the Port supports Command Completed events, software must
wait for a command to complete before writing to Slot Control again.

pcie_do_write_cmd() sets ctrl->cmd_busy when it writes to Slot Control.  If
software notification is enabled, i.e., PCI_EXP_SLTCTL_HPIE and
PCI_EXP_SLTCTL_CCIE are set, ctrl->cmd_busy is cleared by pciehp_isr().

But when software notification is disabled, as it is when pcie_init()
powers off an empty slot, pcie_wait_cmd() uses pcie_poll_cmd() to poll for
command completion, and it neglects to clear ctrl->cmd_busy, which leads to
spurious timeouts:

  pcieport 0000:00:03.0: pciehp: Timeout on hotplug command 0x01c0 (issued 2264 msec ago)
  pcieport 0000:00:03.0: pciehp: Timeout on hotplug command 0x05c0 (issued 2288 msec ago)

Clear ctrl->cmd_busy in pcie_poll_cmd() when it detects a Command Completed
event (PCI_EXP_SLTSTA_CC).

[bhelgaas: commit log]
Fixes: a5dd4b4b0570 ("PCI: pciehp: Wait for hotplug command completion where necessary")
Link: https://lore.kernel.org/r/20211111054258.7309-1-zhangliguang@linux.alibaba.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215143
Link: https://lore.kernel.org/r/20211126173309.GA12255@wunner.de
Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org	# v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/pciehp_hpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -120,6 +120,8 @@ static int pcie_poll_cmd(struct controll
 		if (slot_status & PCI_EXP_SLTSTA_CC) {
 			pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
 						   PCI_EXP_SLTSTA_CC);
+			ctrl->cmd_busy = 0;
+			smp_mb();
 			return 1;
 		}
 		if (timeout < 0)


