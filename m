Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6076B414D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjCJNvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjCJNva (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A204F10D75C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E515616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45371C433EF;
        Fri, 10 Mar 2023 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456288;
        bh=TtKbn2e9CFuUkS5JFXCWdRWYBluM9Pd8iPd2Lv1bLbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7aISb9kFndfcC0wNyD0/hXatr6hz4mduc8d+P7nS0tNYgbs/kw1P+hp21xGzYILm
         OEbqs9NhBPXHv+p60nJMAAqaZAMWx9byxIqITqcIDiXCPSIWjNJ8TtBmY9VBuZ+CUY
         rXfGot3cPyh4sWsniDeqQzmRSHk4FZhzsje0GpKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.14 146/193] PCI: Avoid FLR for AMD FCH AHCI adapters
Date:   Fri, 10 Mar 2023 14:38:48 +0100
Message-Id: <20230310133716.082326076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 63ba51db24ed1b8f8088a897290eb6c036c5435d upstream.

PCI passthrough to VMs does not work with AMD FCH AHCI adapters: the guest
OS fails to correctly probe devices attached to the controller due to FIS
communication failures:

  ata4: softreset failed (1st FIS failed)
  ...
  ata4.00: qc timeout after 5000 msecs (cmd 0xec)
  ata4.00: failed to IDENTIFY (I/O error, err_mask=0x4)

Forcing the "bus" reset method before unbinding & binding the adapter to
the vfio-pci driver solves this issue, e.g.:

  echo "bus" > /sys/bus/pci/devices/<ID>/reset_method

gives a working guest OS, indicating that the default FLR reset method
doesn't work correctly.

Apply quirk_no_flr() to AMD FCH AHCI devices to work around this issue.

Link: https://lore.kernel.org/r/20230128013951.523247-1-damien.lemoal@opensource.wdc.com
Reported-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5064,6 +5064,7 @@ static void quirk_no_flr(struct pci_dev
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 


