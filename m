Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDA512393E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 23:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLQWRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 17:17:39 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:45633 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfLQWRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 17:17:37 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MWiUg-1iAIaz11AG-00X7Da; Tue, 17 Dec 2019 23:17:25 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux-doc@vger.kernel.org, corbet@lwn.net, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org
Subject: [PATCH v2 05/27] compat_ioctl: block: handle Persistent Reservations
Date:   Tue, 17 Dec 2019 23:16:46 +0100
Message-Id: <20191217221708.3730997-6-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191217221708.3730997-1-arnd@arndb.de>
References: <20191217221708.3730997-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:tx22KhkD8iJEZwgYOFJOPlY7/tV41LHYXsZyhEEBtPVUvOD6tZ9
 4vPV9N8E62lgxAxzbfK8VDbGilQv+sX1qrJOYnivJO3Kx7yLG1YXPA9d3OSBQ2Up50TY2P5
 E+6JBT8vWfcZROysq2+gDwTDnZCBZvKYpKY5KsUZKiWLRhBcIt0dDmgK7tehattqwqXno49
 vXnJSOt2f4OGkue9fXHKg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7CYFyHsACKo=:iyqLTw2Ohx2BEyJYsY+41B
 hmwCpRKunMUl5x4CJcPTcGVIU5H44ivCnbINJS9mY+fwQyDURv9WqnbJ8BKVg9OfGh0zuhGuJ
 E410up0th9p7KZUbMj7TMBh2DwGyF4mvvWKAA5o6lXrfK9JoZrSfUsB5nPW7mNINFtgCVK6q+
 C5ho2O5/A5yBtAUmN64W+FrC+/fHoVI0GCjzmZ6hlEzFvDX5SbIAtIxjC99izWWjugaLMyX6N
 27qHiPIxK/4sFWFthVGVDijLh8GaQYnfJ/KuesQ+l4IAmo6vDORhk33l5yV66TpT/RIFdEAf0
 4x73Z8R6U0zssgg8ECCn3uS0Fp1eZtEiueO2/ZWjZah8FHdlpK6HJFTKGGrCacMXpnFZ+/X0P
 frWn1az7Dzraw9EtnxDoi208ZXqwffjTDOJX33eDDBpr5XMkE6MOJFeE9QC1vRdQ16xzDDQYy
 NVuLk3W10H+rnGj5kUVvcfLF5ltPJe/sSH2SKVMSYf+LFg4scM+8xOpJO/ItnkAlPLFKydGy4
 kd/OLhf8xRqcbJsgkt9/YxeY59pHHB3USKVHP23C9YP7Q1U+eDd55rOLPsnyfrZ8dfv6EfKuu
 snRrXg6PaLYh5gnyjsinoeAx2aHPbOYfK5WRUA2j6S2SFX4CJUyC9Ztk3ehYK/ifB9EmYjWhz
 6MbLS+22UGdPgqIbcwauE98Q+zazJtoPwRXc0cP9elqDfdSx2iN5iRhOuNIqEUwyIQLcaLens
 EgMCvwj72YNusvtNS/E1eqcJffNdTWGYofCMPbJZwajFRs3blHACkQPD0KHiboA0h9T3umrqT
 sEUgKmBzCLZSmf2JYy9Ni4gBWr1RoTw3UHhLFcRICibhg0pKZlgplQlOZ3nROO28SseqNcmVL
 O9es2vmgaCJxzqdKwRsw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These were added to blkdev_ioctl() in linux-5.5 but not
blkdev_compat_ioctl, so add them now.

Cc: <stable@vger.kernel.org> # v4.4+
Fixes: bbd3e064362e ("block: add an API for Persistent Reservations")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/compat_ioctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 5b13e344229c..f16ae92065d7 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -408,6 +408,14 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKTRACETEARDOWN: /* compatible */
 		ret = blk_trace_ioctl(bdev, cmd, compat_ptr(arg));
 		return ret;
+	case IOC_PR_REGISTER:
+	case IOC_PR_RESERVE:
+	case IOC_PR_RELEASE:
+	case IOC_PR_PREEMPT:
+	case IOC_PR_PREEMPT_ABORT:
+	case IOC_PR_CLEAR:
+		return blkdev_ioctl(bdev, mode, cmd,
+				(unsigned long)compat_ptr(arg));
 	default:
 		if (disk->fops->compat_ioctl)
 			ret = disk->fops->compat_ioctl(bdev, mode, cmd, arg);
-- 
2.20.0

