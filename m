Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E863BE846
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGGMvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhGGMvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03F8B61CBB;
        Wed,  7 Jul 2021 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625662111;
        bh=4Kmbl1dRIujhdHBNzYtzlaxq5FxRltkeR/6mA5mgnn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECDMWf9ibOwJ6ZbSCODiMz1JhIfIdu7TH27hY18QsWg3IVFNBkXhJ81F53bpabgXi
         MpyboTXmNmaLfgv8rG1l6YkJSMxbwsXn5WZ7sLiFP+qYfcgwyjqnb7XfgCjrAVdoXd
         1ZkFeXWI6GIxJaGvsoTzE3gF/w2VGqCCZiouAc6LMCspCpeAzHGSZzLEhhr88TvWSs
         b2KcUPEjElTtN9N1n0kAKMIXpH7qfAxoXL9+bXkdApjZgvlwe8jO/QKpqvKNrTni1R
         Ubmfg7sZQ4ILzHRhlJztQ9bcKSc0FtM7BB9sY3H0ZKX2msAyZBpQepTE5w4PFSw14H
         wyP2BAqawVxmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Re: Linux 5.4.130
Date:   Wed,  7 Jul 2021 08:48:28 -0400
Message-Id: <20210707124828.2443579-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707124828.2443579-1-sashal@kernel.org>
References: <20210707124828.2443579-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 802520ad08cc..4256dd594d18 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 129
+SUBLEVEL = 130
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index f9263426af03..ae414045a750 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1232,6 +1232,7 @@ config GPIO_TPS68470
 config GPIO_TQMX86
 	tristate "TQ-Systems QTMX86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
 	help
 	  This driver supports GPIO on the TQMX86 IO controller.
@@ -1299,6 +1300,7 @@ menu "PCI GPIO expanders"
 config GPIO_AMD8111
 	tristate "AMD 8111 GPIO driver"
 	depends on X86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	help
 	  The AMD 8111 south bridge contains 32 GPIO pins which can be used.
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index f8015e0318d7..f7603be569fc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -542,7 +542,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
@@ -562,7 +562,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index b198ff10cde9..fddefb29efd7 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -13,6 +13,7 @@
 #include <rdma/ib_umem.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/eswitch.h>
 #include "mlx5_ib.h"
 
 #define UVERBS_MODULE_NAME mlx5_ib
@@ -316,6 +317,13 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	if (err)
 		goto end;
 
+	if (obj->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	    mlx5_eswitch_mode(dev->mdev->priv.eswitch) !=
+			      MLX5_ESWITCH_OFFLOADS) {
+		err = -EINVAL;
+		goto end;
+	}
+
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	atomic_set(&obj->usecnt, 0);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 70a28f6fb1d0..2332b245b182 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -218,6 +218,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 
diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
index aa874d84e413..f0c908241966 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -11,11 +11,6 @@
 #include "../integrity.h"
 #include "keyring_handler.h"
 
-static efi_guid_t efi_cert_x509_guid __initdata = EFI_CERT_X509_GUID;
-static efi_guid_t efi_cert_x509_sha256_guid __initdata =
-	EFI_CERT_X509_SHA256_GUID;
-static efi_guid_t efi_cert_sha256_guid __initdata = EFI_CERT_SHA256_GUID;
-
 /*
  * Look to see if a UEFI variable called MokIgnoreDB exists and return true if
  * it does.
