Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A987A66CBA9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbjAPRP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbjAPRPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:15:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6483279BB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:56:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61B4661086
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711DCC43392;
        Mon, 16 Jan 2023 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888173;
        bh=HFHwWIti4Fdr/KA5lIRDDons+ZSQs/+XfrokyewDYeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jmzgj6tCXj8t7H3Isa/0gpfoIwo5bDAm8XoD657KB/MelxB3YgnxHIyqUbX8QjqvR
         r0GX3aP9UHrBUsRX1NAbT4AmyfIpHfg2hWYsLYKhSVaUtSAIxfm4Q6bDr9Tu6uFXXY
         xKehIti52KcfXT075H4ZHl4LsBNuNfcmw0/NMNrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Gong <gongwei833x@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 398/521] PCI: Fix pci_device_is_present() for VFs by checking PF
Date:   Mon, 16 Jan 2023 16:51:00 +0100
Message-Id: <20230116154904.872214289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

commit 98b04dd0b4577894520493d96bc4623387767445 upstream.

pci_device_is_present() previously didn't work for VFs because it reads the
Vendor and Device ID, which are 0xffff for VFs, which looks like they
aren't present.  Check the PF instead.

Wei Gong reported that if virtio I/O is in progress when the driver is
unbound or "0" is written to /sys/.../sriov_numvfs, the virtio I/O
operation hangs, which may result in output like this:

  task:bash state:D stack:    0 pid: 1773 ppid:  1241 flags:0x00004002
  Call Trace:
   schedule+0x4f/0xc0
   blk_mq_freeze_queue_wait+0x69/0xa0
   blk_mq_freeze_queue+0x1b/0x20
   blk_cleanup_queue+0x3d/0xd0
   virtblk_remove+0x3c/0xb0 [virtio_blk]
   virtio_dev_remove+0x4b/0x80
   ...
   device_unregister+0x1b/0x60
   unregister_virtio_device+0x18/0x30
   virtio_pci_remove+0x41/0x80
   pci_device_remove+0x3e/0xb0

This happened because pci_device_is_present(VF) returned "false" in
virtio_pci_remove(), so it called virtio_break_device().  The broken vq
meant that vring_interrupt() skipped the vq.callback() that would have
completed the virtio I/O operation via virtblk_done().

[bhelgaas: commit log, simplify to always use pci_physfn(), add stable tag]
Link: https://lore.kernel.org/r/20221026060912.173250-1-mst@redhat.com
Reported-by: Wei Gong <gongwei833x@gmail.com>
Tested-by: Wei Gong <gongwei833x@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5815,6 +5815,8 @@ bool pci_device_is_present(struct pci_de
 {
 	u32 v;
 
+	/* Check PF if pdev is a VF, since VF Vendor/Device IDs are 0xffff */
+	pdev = pci_physfn(pdev);
 	if (pci_dev_is_disconnected(pdev))
 		return false;
 	return pci_bus_read_dev_vendor_id(pdev->bus, pdev->devfn, &v, 0);


