Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC71B47AF26
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhLTPKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbhLTPHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:07:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80ACC0A884F;
        Mon, 20 Dec 2021 06:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6940E611B8;
        Mon, 20 Dec 2021 14:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E78BC36AE8;
        Mon, 20 Dec 2021 14:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012030;
        bh=KvFjW27hkVZpksv4LPmUATovlSkIPBuaWpuY6hPgomk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZplHfdtPL3yj/EjnhEqEqE59q7N4btyn4jHyWvVcz1EBc2LeU/WAqXi2rQSbhVlu
         1rC0GnHc8do99/k/rfgsm9TUh3031++JNYSVBGjeOiZ+vwlvMPoMwZwcdoTTWjQs6p
         q67jnRn/ENZmTC3Dgsfnj0/ZKQojNNQ1okxbO2Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/177] virtio: always enter drivers/virtio/
Date:   Mon, 20 Dec 2021 15:33:25 +0100
Message-Id: <20211220143041.951994946@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 27d9839f17940e8edc475df616bbd9cf7ede8d05 ]

When neither VIRTIO_PCI_LIB nor VIRTIO are enabled, but the alibaba
vdpa driver is, the kernel runs into a link error because the legacy
virtio module never gets built:

x86_64-linux-ld: drivers/vdpa/alibaba/eni_vdpa.o: in function `eni_vdpa_set_features':
eni_vdpa.c:(.text+0x23f): undefined reference to `vp_legacy_set_features'
x86_64-linux-ld: drivers/vdpa/alibaba/eni_vdpa.o: in function `eni_vdpa_set_vq_state':
eni_vdpa.c:(.text+0x2fe): undefined reference to `vp_legacy_get_queue_enable'
x86_64-linux-ld: drivers/vdpa/alibaba/eni_vdpa.o: in function `eni_vdpa_set_vq_address':
eni_vdpa.c:(.text+0x376): undefined reference to `vp_legacy_set_queue_address'
x86_64-linux-ld: drivers/vdpa/alibaba/eni_vdpa.o: in function `eni_vdpa_set_vq_ready':
eni_vdpa.c:(.text+0x3b4): undefined reference to `vp_legacy_set_queue_address'
x86_64-linux-ld: drivers/vdpa/alibaba/eni_vdpa.o: in function `eni_vdpa_free_irq':
eni_vdpa.c:(.text+0x460): undefined reference to `vp_legacy_queue_vector'
x86_64-linux-ld: eni_vdpa.c:(.text+0x4b7): undefined reference to `vp_legacy_config_vector'
x86_64-linux-ld: drivers/vdpa/alibaba/eni_vdpa.o: in function `eni_vdpa_reset':

When VIRTIO_PCI_LIB was added, it was correctly added to drivers/Makefile
as well, but for the legacy module, this is missing.  Solve this by always
entering drivers/virtio during the build and letting its Makefile take
care of the individual options, rather than having a separate line for
each sub-option.

Fixes: 64b9f64f80a6 ("vdpa: introduce virtio pci driver")
Fixes: e85087beedca ("eni_vdpa: add vDPA driver for Alibaba ENI")
Fixes: d89c8169bd70 ("virtio-pci: introduce legacy device module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211206085034.2836099-1-arnd@kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index be5d40ae14882..a110338c860c7 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -41,8 +41,7 @@ obj-$(CONFIG_DMADEVICES)	+= dma/
 # SOC specific infrastructure drivers.
 obj-y				+= soc/
 
-obj-$(CONFIG_VIRTIO)		+= virtio/
-obj-$(CONFIG_VIRTIO_PCI_LIB)	+= virtio/
+obj-y				+= virtio/
 obj-$(CONFIG_VDPA)		+= vdpa/
 obj-$(CONFIG_XEN)		+= xen/
 
-- 
2.33.0



