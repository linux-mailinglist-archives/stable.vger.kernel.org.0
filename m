Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62B273EA9
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389400AbfGXThI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389398AbfGXThI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20926214AF;
        Wed, 24 Jul 2019 19:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997027;
        bh=bVoWQeAj3bCosk4IPCszsS0GH2qnu2Ait/MZtiHsA+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ol47cOVyY6p7X9y8jPGsi/IOYJKXougdWw/2ZDZzKeh1oIY0jtB61eVkmIkKLfZ/E
         go5HvNs7PMmJNiCESRazF/NuzEAhjfmAG8f6nzyw8Z6V0UD5UqHg3VjRMcIwQk1LnX
         cJXG0DkCyGhXgFTeNhxQdxE9BQa8PTWuYeXz5KSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.2 257/413] scsi: sd_zbc: Fix compilation warning
Date:   Wed, 24 Jul 2019 21:19:08 +0200
Message-Id: <20190724191754.404270441@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 0cdc58580b37a160fac4b884266b8b7cb096f539 upstream.

kbuild test robot gets the following compilation warning using gcc 7.4
cross compilation for c6x (GCC_VERSION=7.4.0 make.cross ARCH=c6x).

   In file included from include/asm-generic/bug.h:18:0,
                    from arch/c6x/include/asm/bug.h:12,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:12,
                    from include/asm-generic/current.h:5,
                    from ./arch/c6x/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from include/linux/blkdev.h:5,
                    from drivers//scsi/sd_zbc.c:11:
   drivers//scsi/sd_zbc.c: In function 'sd_zbc_read_zones':
>> include/linux/kernel.h:62:48: warning: 'zone_blocks' may be used
   uninitialized in this function [-Wmaybe-uninitialized]
    #define __round_mask(x, y) ((__typeof__(x))((y)-1))
                                                   ^
   drivers//scsi/sd_zbc.c:464:6: note: 'zone_blocks' was declared here
     u32 zone_blocks;
         ^~~~~~~~~~~

This is a false-positive report. The variable zone_blocks is always
initialized in sd_zbc_check_zones() before use. It is not initialized
only and only if sd_zbc_check_zones() fails.

Avoid this warning by initializing the zone_blocks variable to 0.

Fixes: 5f832a395859 ("scsi: sd_zbc: Fix sd_zbc_check_zones() error checks")
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd_zbc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -417,7 +417,7 @@ int sd_zbc_read_zones(struct scsi_disk *
 {
 	struct gendisk *disk = sdkp->disk;
 	unsigned int nr_zones;
-	u32 zone_blocks;
+	u32 zone_blocks = 0;
 	int ret;
 
 	if (!sd_is_zoned(sdkp))


