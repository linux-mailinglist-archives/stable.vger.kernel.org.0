Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D4B55D79C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244240AbiF1CaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244734AbiF1C1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559B825EB8;
        Mon, 27 Jun 2022 19:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E631B61913;
        Tue, 28 Jun 2022 02:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498E8C341CA;
        Tue, 28 Jun 2022 02:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383144;
        bh=aryDqvuv3cG6khhXyW+8VRoUdPuZ96pqZ7EV4Ei5FfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bq6CRo50HHwzxyZMgCDPu5vZ7esP/8bN+2J/b9UYSEuDCJHk/S8msqsKAvUQkisgY
         5i5SfQzpPY7yhp3F0FewOMDtI4Fsy6NWD8MdPLPQp8yyyZjI+zHCvwpHOFd8pRLrHZ
         95dShCYadBo8+s8e24g91DUizgqoxnCKIftoOs2r/FbA5shrWaPVshErmmqrjD/Gmq
         s4DH05LmGDn/SejdbmjBZ84SoSxd0/TTHElzH5IWu1pykBeXGnQgQNfN1eT4XHB69D
         gfBFsfg49YXSOCNz9SxIwAk90eizrtPNg2GOQDh4QMEUn8F9BldbjAzOKJlQkBNZRU
         AD79wcXlEL1TQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Cvek <petrcvekcz@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, mbroemme@libmpq.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 10/22] video: fbdev: intelfb: Use aperture size from pci_resource_len
Date:   Mon, 27 Jun 2022 22:25:05 -0400
Message-Id: <20220628022518.596687-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022518.596687-1-sashal@kernel.org>
References: <20220628022518.596687-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Cvek <petrcvekcz@gmail.com>

[ Upstream commit 25c9a15fb7bbfafb94dd3b4e3165c18b8e1bd039 ]

Aperture size for i9x5 variants is determined from PCI base address.

	if (pci_resource_start(pdev, 2) & 0x08000000)
		*aperture_size = MB(128);
	...

This condition is incorrect as 128 MiB address can have the address
set as 0x?8000000 or 0x?0000000. Also the code can be simplified to just
use pci_resource_len().

The true settings of the aperture size is in the MSAC register, which
could be used instead. However the value is used only as an info message,
so it doesn't matter.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/intelfb/intelfbhw.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/intelfb/intelfbhw.c b/drivers/video/fbdev/intelfb/intelfbhw.c
index 57aff7450bce..2086e06532ee 100644
--- a/drivers/video/fbdev/intelfb/intelfbhw.c
+++ b/drivers/video/fbdev/intelfb/intelfbhw.c
@@ -201,13 +201,11 @@ int intelfbhw_get_memory(struct pci_dev *pdev, int *aperture_size,
 	case PCI_DEVICE_ID_INTEL_945GME:
 	case PCI_DEVICE_ID_INTEL_965G:
 	case PCI_DEVICE_ID_INTEL_965GM:
-		/* 915, 945 and 965 chipsets support a 256MB aperture.
-		   Aperture size is determined by inspected the
-		   base address of the aperture. */
-		if (pci_resource_start(pdev, 2) & 0x08000000)
-			*aperture_size = MB(128);
-		else
-			*aperture_size = MB(256);
+		/*
+		 * 915, 945 and 965 chipsets support 64MB, 128MB or 256MB
+		 * aperture. Determine size from PCI resource length.
+		 */
+		*aperture_size = pci_resource_len(pdev, 2);
 		break;
 	default:
 		if ((tmp & INTEL_GMCH_MEM_MASK) == INTEL_GMCH_MEM_64M)
-- 
2.35.1

