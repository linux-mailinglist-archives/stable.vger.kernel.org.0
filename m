Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA40D303358
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbhAZEud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbhAYSqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5765520665;
        Mon, 25 Jan 2021 18:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600367;
        bh=Gfzgj83rpZzOZEReGsOO/vUQx7d6wgmScyxZBohDm1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqlub8fVVnR0pY4JSPa8KsqJjr58HO9k5O/9SPwkcbJhzkBlO1mVwXZRJ20RuOTZ1
         kkLp8INTCiNnNcZSUUn98rKOkB9jaub0FHrL66NjuQtdASC51Px/grO1nf3K6YFauo
         ubFOCcZ+X8dUt+wIpFXS5Jce0fvTmD/oAcSJvFTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Oester <kernel@linuxace.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/86] scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression
Date:   Mon, 25 Jan 2021 19:39:26 +0100
Message-Id: <20210125183202.928579634@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b112036535eda34460677ea883eaecc3a45a435d ]

Phil Oester reported that a fix for a possible buffer overrun that I sent
caused a regression that manifests in this output:

 Event Message: A PCI parity error was detected on a component at bus 0 device 5 function 0.
 Severity: Critical
 Message ID: PCI1308

The original code tried to handle the sense data pointer differently when
using 32-bit 64-bit DMA addressing, which would lead to a 32-bit dma_addr_t
value of 0x11223344 to get stored

32-bit kernel:       44 33 22 11 ?? ?? ?? ??
64-bit LE kernel:    44 33 22 11 00 00 00 00
64-bit BE kernel:    00 00 00 00 44 33 22 11

or a 64-bit dma_addr_t value of 0x1122334455667788 to get stored as

32-bit kernel:       88 77 66 55 ?? ?? ?? ??
64-bit kernel:       88 77 66 55 44 33 22 11

In my patch, I tried to ensure that the same value is used on both 32-bit
and 64-bit kernels, and picked what seemed to be the most sensible
combination, storing 32-bit addresses in the first four bytes (as 32-bit
kernels already did), and 64-bit addresses in eight consecutive bytes (as
64-bit kernels already did), but evidently this was incorrect.

Always storing the dma_addr_t pointer as 64-bit little-endian,
i.e. initializing the second four bytes to zero in case of 32-bit
addressing, apparently solved the problem for Phil, and is consistent with
what all 64-bit little-endian machines did before.

I also checked in the history that in previous versions of the code, the
pointer was always in the first four bytes without padding, and that
previous attempts to fix 64-bit user space, big-endian architectures and
64-bit DMA were clearly flawed and seem to have introduced made this worse.

Link: https://lore.kernel.org/r/20210104234137.438275-1-arnd@kernel.org
Fixes: 381d34e376e3 ("scsi: megaraid_sas: Check user-provided offsets")
Fixes: 107a60dd71b5 ("scsi: megaraid_sas: Add support for 64bit consistent DMA")
Fixes: 94cd65ddf4d7 ("[SCSI] megaraid_sas: addded support for big endian architecture")
Fixes: 7b2519afa1ab ("[SCSI] megaraid_sas: fix 64 bit sense pointer truncation")
Reported-by: Phil Oester <kernel@linuxace.com>
Tested-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4a23dd8b7f9aa..b9c1f722f1ded 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8174,11 +8174,9 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			goto out;
 		}
 
+		/* always store 64 bits regardless of addressing */
 		sense_ptr = (void *)cmd->frame + ioc->sense_off;
-		if (instance->consistent_mask_64bit)
-			put_unaligned_le64(sense_handle, sense_ptr);
-		else
-			put_unaligned_le32(sense_handle, sense_ptr);
+		put_unaligned_le64(sense_handle, sense_ptr);
 	}
 
 	/*
-- 
2.27.0



