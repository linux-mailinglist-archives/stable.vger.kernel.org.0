Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470C94FD160
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351374AbiDLG60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351763AbiDLGyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF6D3914B;
        Mon, 11 Apr 2022 23:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D54E460DD3;
        Tue, 12 Apr 2022 06:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EC8C385A1;
        Tue, 12 Apr 2022 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745835;
        bh=nCTmKaY5tqg5mpxtTmdTE1Ti9amTVIWQFxjrQKhEUwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ok8q4FdqoYyDwIbqYWfmC07JhgHaskhxeRfkO3uXOVTxjOD8U4thjkkpjcLYoObL4
         O/L60mNc/oshUUUVO+hUVgfNQ98+5EtQczmXitlgaSz9DsVLa9ZXWnbXz9FJj2ys0w
         HRwxqyDqqDkLmhvbBGDRq/ov+Sb8By+mVvoz30S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/277] vfio/pci: Stub vfio_pci_vga_rw when !CONFIG_VFIO_PCI_VGA
Date:   Tue, 12 Apr 2022 08:27:49 +0200
Message-Id: <20220412062943.958938891@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 6e031ec0e5a2dda53e12e0d2a7e9b15b47a3c502 ]

Resolve build errors reported against UML build for undefined
ioport_map() and ioport_unmap() functions.  Without this config
option a device cannot have vfio_pci_core_device.has_vga set,
so the existing function would always return -EINVAL anyway.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20220123125737.2658758-1-geert@linux-m68k.org
Link: https://lore.kernel.org/r/164306582968.3758255.15192949639574660648.stgit@omen
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 2 ++
 include/linux/vfio_pci_core.h    | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 57d3b2cbbd8e..82ac1569deb0 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -288,6 +288,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return done;
 }
 
+#ifdef CONFIG_VFIO_PCI_VGA
 ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite)
 {
@@ -355,6 +356,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	return done;
 }
+#endif
 
 static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 					bool test_mem)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..ae6f4838ab75 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -159,8 +159,17 @@ extern ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
 extern ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
+#ifdef CONFIG_VFIO_PCI_VGA
 extern ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
+#else
+static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos, bool iswrite)
+{
+	return -EINVAL;
+}
+#endif
 
 extern long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 			       uint64_t data, int count, int fd);
-- 
2.35.1



