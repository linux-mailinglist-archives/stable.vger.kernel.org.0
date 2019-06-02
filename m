Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7624632187
	for <lists+stable@lfdr.de>; Sun,  2 Jun 2019 03:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfFBB3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 21:29:36 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34600 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfFBB3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 21:29:10 -0400
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id B2BBD27E40; Sat,  1 Jun 2019 21:29:06 -0400 (EDT)
Message-Id: <cover.1559438652.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/7] NCR5380 drivers: fixes and improvements
Date:   Sun, 02 Jun 2019 11:24:12 +1000
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org,
        "Joshua Thompson" <funaho@jurai.org>
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


Finn Thain (7):
  Revert "scsi: ncr5380: Increase register polling limit"
  scsi: NCR5380: Always re-enable reselection interrupt
  scsi: NCR5380: Handle PDMA failure reliably
  scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
  scsi: mac_scsi: Fix pseudo DMA implementation, take 2
  scsi: mac_scsi: Enable PDMA on Mac IIfx
  scsi: mac_scsi: Treat Last Byte Sent time-out as failure

 arch/m68k/include/asm/mac_pdma.h | 179 ++++++++++++++++++++++
 arch/m68k/mac/config.c           |  10 +-
 drivers/scsi/NCR5380.c           |  18 +--
 drivers/scsi/NCR5380.h           |   2 +-
 drivers/scsi/mac_scsi.c          | 249 +++++++++++--------------------
 5 files changed, 280 insertions(+), 178 deletions(-)
 create mode 100644 arch/m68k/include/asm/mac_pdma.h

-- 
2.21.0

