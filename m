Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010AD201360
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392056AbgFSPOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392007AbgFSPN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:13:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70B6021582;
        Fri, 19 Jun 2020 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579639;
        bh=atWOVYEMnKN4w9Qj8wIZ1sIxzM5jrFGsmCak9jUALm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgtFK9/2MPV5j1KRJkXNdNR0qePn1msAcO1Hk+Hlxnd7h6KVP2zUZeTyNZ1aeN+M1
         jcuh+rw9pOAcDlxA9yfM8wm+bzm4veiaJW65UiFqZbjfdvk4/jYY+Vkw3FuEIVr//b
         Vol4btyxMLYkW3WzZRZB/41b6s78PTjOqdq/P0ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Monakov <amonakov@ispras.ru>,
        Borislav Petkov <bp@suse.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>
Subject: [PATCH 5.4 210/261] EDAC/amd64: Add AMD family 17h model 60h PCI IDs
Date:   Fri, 19 Jun 2020 16:33:41 +0200
Message-Id: <20200619141659.962491441@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Monakov <amonakov@ispras.ru>

commit b6bea24d41519e8c31e4798f1c1a3f67e540c5d0 upstream.

Add support for AMD Renoir (4000-series Ryzen CPUs).

Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://lkml.kernel.org/r/20200510204842.2603-4-amonakov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/amd64_edac.c |   13 +++++++++++++
 drivers/edac/amd64_edac.h |    3 +++
 2 files changed, 16 insertions(+)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2317,6 +2317,15 @@ static struct amd64_family_type family_t
 			.dbam_to_cs		= f17_addr_mask_to_cs_size,
 		}
 	},
+	[F17_M60H_CPUS] = {
+		.ctl_name = "F17h_M60h",
+		.f0_id = PCI_DEVICE_ID_AMD_17H_M60H_DF_F0,
+		.f6_id = PCI_DEVICE_ID_AMD_17H_M60H_DF_F6,
+		.ops = {
+			.early_channel_count	= f17_early_channel_count,
+			.dbam_to_cs		= f17_addr_mask_to_cs_size,
+		}
+	},
 	[F17_M70H_CPUS] = {
 		.ctl_name = "F17h_M70h",
 		.f0_id = PCI_DEVICE_ID_AMD_17H_M70H_DF_F0,
@@ -3366,6 +3375,10 @@ static struct amd64_family_type *per_fam
 			fam_type = &family_types[F17_M30H_CPUS];
 			pvt->ops = &family_types[F17_M30H_CPUS].ops;
 			break;
+		} else if (pvt->model >= 0x60 && pvt->model <= 0x6f) {
+			fam_type = &family_types[F17_M60H_CPUS];
+			pvt->ops = &family_types[F17_M60H_CPUS].ops;
+			break;
 		} else if (pvt->model >= 0x70 && pvt->model <= 0x7f) {
 			fam_type = &family_types[F17_M70H_CPUS];
 			pvt->ops = &family_types[F17_M70H_CPUS].ops;
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -120,6 +120,8 @@
 #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F6 0x15ee
 #define PCI_DEVICE_ID_AMD_17H_M30H_DF_F0 0x1490
 #define PCI_DEVICE_ID_AMD_17H_M30H_DF_F6 0x1496
+#define PCI_DEVICE_ID_AMD_17H_M60H_DF_F0 0x1448
+#define PCI_DEVICE_ID_AMD_17H_M60H_DF_F6 0x144e
 #define PCI_DEVICE_ID_AMD_17H_M70H_DF_F0 0x1440
 #define PCI_DEVICE_ID_AMD_17H_M70H_DF_F6 0x1446
 
@@ -291,6 +293,7 @@ enum amd_families {
 	F17_CPUS,
 	F17_M10H_CPUS,
 	F17_M30H_CPUS,
+	F17_M60H_CPUS,
 	F17_M70H_CPUS,
 	NUM_FAMILIES,
 };


