Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122A0123977
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 23:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfLQWSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 17:18:48 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:47933 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfLQWRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 17:17:44 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MJV5K-1iNTtD2mu8-00JtoE; Tue, 17 Dec 2019 23:17:23 +0100
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
Subject: [PATCH v2 02/27] compat_ioctl: block: handle BLKREPORTZONE/BLKRESETZONE
Date:   Tue, 17 Dec 2019 23:16:43 +0100
Message-Id: <20191217221708.3730997-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191217221708.3730997-1-arnd@arndb.de>
References: <20191217221708.3730997-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:g9ac37aU2A7D6GQqud2omy5i2QGTVE1qppkCL5XwIDeUd8bobTc
 MveRQyw3+9pR5kUrwwKPYkI72gAZcTFNOFPrXHHjoLZDSE//MQTS40wwyPjouH26AbGYVAe
 jAM7wjF2oIGdwXn7+yQnLwHO5GyBuoGAp+pfHTjpdbXQt7rRjN5nKS181kK7PLyXD7q+Jnk
 7vH6FPtRoMkX/848Z91BA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zG7SE8/0MZM=:KEUrtjVSBoJBU02gLbM6J4
 2EagqdafkKPJhjR/Tm0F8ZE1uyWfOhPXtbj8Wi3q3Gozys9rJExO2wo4fo8ZxCs7OxZ1eEZ9J
 QepdDyiAeclC3QZ/nS2SRQc5KfTpwTH81BOMbRk1pkWO7VBTU+1d7i6HOwYh33TmvPTPsizvs
 MMVgM2K0tstvZ4ElOoVo5v3o6ev5YpWZCxE8GktYvG0zounkN5I5TObuXVKKerlR6AbILeRZx
 /SvdM3xC+vzZR3/4WQiVK0BrlEnAgJ7KBwyX6MdtdE4Vvmg6kHUwBOlViwl2zJ9VpG5T9tSMQ
 ptvWX8OIXgyH32USJldmEISgyLbpyc/eJEzcidHTWP+AeRnZSScA89uCQDZfTfMSjLQK8+D+C
 OKwhn/bEDCgSv9BBWyaqngtW8TdY26Ab7veXc4nSFkq/LFamorGan0OT77JgAGrbr8TCrZYhS
 tUPJGutM0iBHjyEkanop9hfxbHlXtYyhsW7onbWfmOTufD/d82/k+BcJLxijM9GtV7irNjQ6R
 S4AUe9RBV7iJypejiG7xbrn9Ga6alfisodAiti+85iaJubN0gAVQHFirx85oCSZF7amaWoB7G
 +mTlrAJIOEZZTJxvrpGatRoArgx5Vy27kBC02ny5s8R1qTsSnFQTQfWvl7PfefpvaeIA/i2a0
 D6wN5emM0HXJ04BR4P6Rb5hAuUZQbl+72JxXEEg/LLU1GzBkmKmYP3yBes+k1IjkANfSkmKPz
 SIUNKFKLEMW9a18wGjAEUepv0t21kQ/C1T3JHWUNJ7MndLZoLXEmGzXwk3ZSVBITBQpZm5KOn
 JLehDsF+wQUW2hMIYQHtMPit53Y2etN3OEtSGjEUcmNbtag1dXyqMvACIelUubtCVGwnnnsOa
 exU8Q+G3QGndB70dx2Xw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These were added to blkdev_ioctl() but not blkdev_compat_ioctl,
so add them now.

Cc: <stable@vger.kernel.org> # v4.10+
Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/compat_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 6ca015f92766..830f91e05fe3 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -354,6 +354,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	 * but we call blkdev_ioctl, which gets the lock for us
 	 */
 	case BLKRRPART:
+	case BLKREPORTZONE:
+	case BLKRESETZONE:
 		return blkdev_ioctl(bdev, mode, cmd,
 				(unsigned long)compat_ptr(arg));
 	case BLKBSZSET_32:
-- 
2.20.0

