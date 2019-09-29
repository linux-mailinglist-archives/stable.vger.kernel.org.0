Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36428C14CC
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfI2N55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F31522082F;
        Sun, 29 Sep 2019 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765475;
        bh=LnhARpY46kvyVwnEicUly2QxNVwPD1pp2CeSSMSnq1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i64DFzie9RwDN/HpY6yQgyA4YHOYbFBr6wMSo21e6cpanzn8sQe0DjAhJi9iz/KdY
         U1M7fS+V12DuYSPZnK6oKW0RYvJfMLwsKpEz87DTm+1NPCTeb+Lxl0EruUIZrgfUwf
         aDc/rLIwcMO4INyW/9fELoPx4lIK+00Y5zWfV9DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Dennis Padiernos <depadiernos@gmail.com>
Subject: [PATCH 4.19 31/63] ALSA: hda - Apply AMD controller workaround for Raven platform
Date:   Sun, 29 Sep 2019 15:54:04 +0200
Message-Id: <20190929135037.876563910@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d2c63b7dfd06788a466d5ec8a850491f084c5fc2 upstream.

It's reported that the garbled sound on HP Envy x360 13z-ag000 (Ryzen
Laptop) is fixed by the same workaround applied to other AMD chips.
Update the driver_data entry for Raven (1022:15e3) to use the newly
introduced preset, AZX_DCAPS_PRESET_AMD_SB.  Since it already contains
AZX_DCAPS_PM_RUNTIME, we can drop that bit, too.

Reported-and-tested-by: Dennis Padiernos <depadiernos@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190920073040.31764-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2662,8 +2662,7 @@ static const struct pci_device_id azx_id
 			 AZX_DCAPS_PM_RUNTIME },
 	/* AMD Raven */
 	{ PCI_DEVICE(0x1022, 0x15e3),
-	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_ATI_SB |
-			 AZX_DCAPS_PM_RUNTIME },
+	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_AMD_SB },
 	/* ATI HDMI */
 	{ PCI_DEVICE(0x1002, 0x0002),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS },


