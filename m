Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF9A60A593
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiJXM1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiJXM0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9D158EB5;
        Mon, 24 Oct 2022 05:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA22361291;
        Mon, 24 Oct 2022 11:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E55C433D6;
        Mon, 24 Oct 2022 11:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612690;
        bh=aOvtxZzoxLZvYMnqDsCHT9AR35HDLsRHaZZOOkdNEaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwkxBBdVYz6Gen91Jqhbiu0pv7glKyU0m+xuZEUjvhCKq6EYK2+sjt4eb6UsDqsMH
         DB4wxsteOIXrM1LlsPWL4dhwsUZpXqHAnk8t6ZHvBm5Ym6p7bNE0KY+cULLMkJuG22
         KXXCLyd/AGKx/Tu5R71CceEBpS09IiPJPEW4VGGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 053/229] PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge
Date:   Mon, 24 Oct 2022 13:29:32 +0200
Message-Id: <20221024113000.792508891@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 0e32818397426a688f598f35d3bc762eca6d7592 upstream.

When pci_assign_resource() is unable to assign resources to a BAR, it uses
pci_revert_fw_address() to fall back to a firmware assignment (if any).
Previously pci_revert_fw_address() assumed all addresses could reach the
device, but this is not true if the device is below a bridge that only
forwards addresses within its windows.

This problem was observed on a Tyan Tomcat IV S1564D system where the BIOS
did not assign valid addresses to several bridges and USB devices:

  pci 0000:00:11.0: PCI-to-PCIe bridge to [bus 01-ff]
  pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
  pci 0000:01:00.0: PCIe Upstream Port to [bus 02-ff]
  pci 0000:01:00.0:   bridge window [io  0x0000-0x0fff]   # unreachable
  pci 0000:02:02.0: PCIe Downstream Port to [bus 05-ff]
  pci 0000:02:02.0:   bridge window [io  0x0000-0x0fff]   # unreachable
  pci 0000:05:00.0: PCIe-to-PCI bridge to [bus 06-ff]
  pci 0000:05:00.0:   bridge window [io  0x0000-0x0fff]   # unreachable
  pci 0000:06:08.0: USB UHCI 1.1
  pci 0000:06:08.0: BAR 4: [io  0xfce0-0xfcff]            # unreachable
  pci 0000:06:08.1: USB UHCI 1.1
  pci 0000:06:08.1: BAR 4: [io  0xfce0-0xfcff]            # unreachable
  pci 0000:06:08.0: can't claim BAR 4 [io  0xfce0-0xfcff]: no compatible bridge window
  pci 0000:06:08.1: can't claim BAR 4 [io  0xfce0-0xfcff]: no compatible bridge window

During the first pass of assigning unassigned resources, there was not
enough I/O space available, so we couldn't assign the 06:08.0 BAR and
reverted to the firmware assignment (still unreachable).  Reverting the
06:08.1 assignment failed because it conflicted with 06:08.0:

  pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
  pci 0000:01:00.0: no space for bridge window [io  size 0x2000]
  pci 0000:02:02.0: no space for bridge window [io  size 0x1000]
  pci 0000:05:00.0: no space for bridge window [io  size 0x1000]
  pci 0000:06:08.0: BAR 4: no space for [io  size 0x0020]
  pci 0000:06:08.0: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
  pci 0000:06:08.1: BAR 4: no space for [io  size 0x0020]
  pci 0000:06:08.1: BAR 4: trying firmware assignment [io  0xfce0-0xfcff]
  pci 0000:06:08.1: BAR 4: [io  0xfce0-0xfcff] conflicts with 0000:06:08.0 [io  0xfce0-0xfcff]

A subsequent pass assigned valid bridge windows and a valid 06:08.1 BAR,
but left the 06:08.0 BAR alone, so the UHCI device was still unusable:

  pci 0000:00:11.0:   bridge window [io  0xe000-0xefff] released
  pci 0000:00:11.0:   bridge window [io  0x1000-0x2fff]   # reassigned
  pci 0000:01:00.0:   bridge window [io  0x1000-0x2fff]   # reassigned
  pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]   # reassigned
  pci 0000:05:00.0:   bridge window [io  0x2000-0x2fff]   # reassigned
  pci 0000:06:08.0: BAR 4: assigned [io  0xfce0-0xfcff]   # left alone
  pci 0000:06:08.1: BAR 4: assigned [io  0x2000-0x201f]
  ...
  uhci_hcd 0000:06:08.0: host system error, PCI problems?
  uhci_hcd 0000:06:08.0: host controller process error, something bad happened!
  uhci_hcd 0000:06:08.0: host controller halted, very bad!
  uhci_hcd 0000:06:08.0: HCRESET not completed yet!
  uhci_hcd 0000:06:08.0: HC died; cleaning up

If the address assigned by firmware is not reachable because it's not
within upstream bridge windows, fail instead of assigning the unusable
address from firmware.

[bhelgaas: commit log, use pci_upstream_bridge()]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=16263
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2203012338460.46819@angie.orcam.me.uk
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2209211921250.29493@angie.orcam.me.uk
Fixes: 58c84eda0756 ("PCI: fall back to original BIOS BAR addresses")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v2.6.35+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-res.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -209,6 +209,17 @@ static int pci_revert_fw_address(struct
 
 	root = pci_find_parent_resource(dev, res);
 	if (!root) {
+		/*
+		 * If dev is behind a bridge, accesses will only reach it
+		 * if res is inside the relevant bridge window.
+		 */
+		if (pci_upstream_bridge(dev))
+			return -ENXIO;
+
+		/*
+		 * On the root bus, assume the host bridge will forward
+		 * everything.
+		 */
 		if (res->flags & IORESOURCE_IO)
 			root = &ioport_resource;
 		else


