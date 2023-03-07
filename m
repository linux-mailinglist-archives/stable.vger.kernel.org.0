Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F1E6AED68
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCGSEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjCGSDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:03:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345C8ACBBB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 993A2B819BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC6EC433D2;
        Tue,  7 Mar 2023 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211801;
        bh=SSnPTObeUNQGCJlJNgm4+SGXbivR3dGwCCQzoKJPELM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCV5h6OcagEyNHGROUiS9lTLymgIF/dD/4Z11HLAPsIcU72Skp6MYmhOTljlJaXLO
         Cq+UuWXfYL+WjL2xG6wqITGTAllc21DRWhTBfi9BzNVbk+NceHLJAFOR6UqYPJ+/4L
         jehmPz2sqHPIP7a5T0YGV0W9LbS6OKY+A6nrZYYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.2 0981/1001] PCI: Avoid FLR for AMD FCH AHCI adapters
Date:   Tue,  7 Mar 2023 18:02:33 +0100
Message-Id: <20230307170104.799164354@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -5340,6 +5340,7 @@ static void quirk_no_flr(struct pci_dev
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 


