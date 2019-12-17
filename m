Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96B1123942
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 23:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfLQWRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 17:17:43 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:47167 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfLQWRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 17:17:40 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N7Qt9-1hc4Aj0to5-017p51; Tue, 17 Dec 2019 23:17:24 +0100
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
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 03/27] compat_ioctl: block: handle BLKGETZONESZ/BLKGETNRZONES
Date:   Tue, 17 Dec 2019 23:16:44 +0100
Message-Id: <20191217221708.3730997-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191217221708.3730997-1-arnd@arndb.de>
References: <20191217221708.3730997-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:qZe5YHLKHLHpHJZclyVZA0fCxWsO2YWO0AhXGovOQ1fZAYHfawL
 PlgMmuwRjxPbewOZKAHylAsdjtO5Fe/LyB5CoqTBmrCuAd/xJZkTNN2Xe6IE5gl9V6JPzSt
 wvrf4HNaht3Bulo2IXSq2733GPK1CFCKtmRyV0YYyH/U4G/08T9e4oHS3EjXjMzJqv1R6qu
 YXpz3kgtPpBQ+l8/25RAg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Hk6RW/QL2Xc=:a9P9ugAbeQlBAd8QTVyh2z
 5InWQgdBINeinSpZATAEdhQ/i9YNLE4Cs+a4GFKgz8jKOPxplXc0dczKp/R69c5g8upJqXc65
 Inze+14ZfZRZaI0BopuCyPY5TUVy08obBhggcQi+WudXUEHWwBsXUFluiycvo4Qaurb+6rEtF
 wl/PyloS7vvgNbHp3oizoL/VE9M/fDRKOZnJVXS33E5tAxmuyEeS+c06bSgvorA2N0WUlGegL
 JR96X/5oeTYQNiS6LNCZOFNiaK7DxSoFNL2X//sV4r/tkqil9NVYbVqSA57bXb27MZdAlvzce
 teYoIFLXA6UzJ6tlnlyGnkX0lzqkCqNUxxn2Vz3OLxiBy708VuKvki7fpMwIoFK5zb8uismKl
 NVnMG3k+kqutWYugmpAYLlsd46sD0BA3aS7H/7sbtwCkJbLmSHzGzUzT3QwFLvufPwS7gjtVa
 LkVlGEraoHwX6J/Aq5FlQxnpaZCOZaoD2ipgjveEAiRud97oZd3v0U1P+jQVsZ31Vd+ZmWrGT
 99AZMqe5M7rDHP9ViRtLfEhibVOQhXjLSW+6xch6lCzJ219MgwF1MnPomwWr/0C9C2kvM0BuW
 j5FGSpZiAZjCLNLEkmuBo6gIivj9IxCbQPMRAzV5rRkt2cZS6sEc13znh6WL9OTKMbXBlAoEg
 92vBK+F5J4ulrPf/6JaQ+KO+dW1b0XoqtMB47HnrBzadfiYpZbvLrSGZ9glboP6AhZN/k8rL7
 bCxTfErhrRnqMpnIuouQQawVleSt5C4nvOHsvTHLrT7EfkeC0Orh2YFb1qjgwN0bBoM067VZr
 rD9N8ZXHsBYH9Hk++YNJRhYpCVImlVrPMX8irVmtJnFkRUa5wg509PSNNIxy3I6lxJmDXGb5E
 AEnRWMTVaEAGbAC7t4wA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These were added to blkdev_ioctl() in v4.20 but not blkdev_compat_ioctl,
so add them now.

Cc: <stable@vger.kernel.org> # v4.20+
Fixes: 72cd87576d1d ("block: Introduce BLKGETZONESZ ioctl")
Fixes: 65e4e3eee83d ("block: Introduce BLKGETNRZONES ioctl")
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/compat_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 830f91e05fe3..f5c1140b8624 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -356,6 +356,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKRRPART:
 	case BLKREPORTZONE:
 	case BLKRESETZONE:
+	case BLKGETZONESZ:
+	case BLKGETNRZONES:
 		return blkdev_ioctl(bdev, mode, cmd,
 				(unsigned long)compat_ptr(arg));
 	case BLKBSZSET_32:
-- 
2.20.0

