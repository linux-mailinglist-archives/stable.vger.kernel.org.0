Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1501C3A2C0
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 03:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfFIB0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 21:26:44 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:59936 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfFIB0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 21:26:44 -0400
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 771082787D; Sat,  8 Jun 2019 21:26:42 -0400 (EDT)
Message-Id: <cover.1560043151.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 0/7] NCR5380 drivers: fixes and other improvements
Date:   Sun, 09 Jun 2019 11:19:11 +1000
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Joshua Thompson" <funaho@jurai.org>,
        linux-m68k@lists.linux-m68k.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Among other improvements, this patch series fixes a data corruption bug
in the mac_scsi driver and a bug in the EH abort routine in the core
5380 driver.

For consistency I have ignored certain checkpatch.pl complaints about
the indentation in mac_scsi.c. The remaining complaints seem to be
false positives.

Some of these patches are not trivial to backport. Those patches have
been nominated for recent -stable branches only.

Changed since v1:
 - Added acked-by tag.
 - Dropped new mac_pdma.h file.


Finn Thain (7):
  Revert "scsi: ncr5380: Increase register polling limit"
  scsi: NCR5380: Always re-enable reselection interrupt
  scsi: NCR5380: Handle PDMA failure reliably
  scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
  scsi: mac_scsi: Fix pseudo DMA implementation, take 2
  scsi: mac_scsi: Enable PDMA on Mac IIfx
  scsi: mac_scsi: Treat Last Byte Sent time-out as failure

 arch/m68k/mac/config.c  |  10 +-
 drivers/scsi/NCR5380.c  |  18 +-
 drivers/scsi/NCR5380.h  |   2 +-
 drivers/scsi/mac_scsi.c | 421 +++++++++++++++++++++++++---------------
 4 files changed, 273 insertions(+), 178 deletions(-)

-- 
2.21.0

