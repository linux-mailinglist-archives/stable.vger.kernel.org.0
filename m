Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E771865D92A
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbjADQWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239898AbjADQWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:22:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B19BA45E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:21:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D76C2CE1853
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D5CC433D2;
        Wed,  4 Jan 2023 16:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849316;
        bh=HwOqpvLc5b3Doh7QuF2TtxxJRsgqGifoEtWwo5D/G/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONrpzUa3tHNXphFNzKXfBCm/BEiBTD2Y94f6Y8b6+7Vg76IA5yeonbYJ4Fdk7o4Dj
         wjv/soXQdqjrpHCg9Z9Pjul3idzA4VOdjjnRviDL5wQmf16thiNj2rtpGxjbR8JwUX
         f15lGYvpvswRXLxxtnjm42vCyWDH9i/oIThfp28E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Gong <gongwei833x@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.0 102/177] PCI: Fix pci_device_is_present() for VFs by checking PF
Date:   Wed,  4 Jan 2023 17:06:33 +0100
Message-Id: <20230104160510.731668135@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -6462,6 +6462,8 @@ bool pci_device_is_present(struct pci_de
 {
 	u32 v;
 
+	/* Check PF if pdev is a VF, since VF Vendor/Device IDs are 0xffff */
+	pdev = pci_physfn(pdev);
 	if (pci_dev_is_disconnected(pdev))
 		return false;
 	return pci_bus_read_dev_vendor_id(pdev->bus, pdev->devfn, &v, 0);


