Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FAF11BE2E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfLKUpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:45:54 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:56465 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLKUpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:45:53 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M5fQq-1idU9L0Vhq-007E8d; Wed, 11 Dec 2019 21:44:41 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org
Subject: [PATCH 04/24] compat_ioctl: block: handle BLKGETZONESZ/BLKGETNRZONES
Date:   Wed, 11 Dec 2019 21:42:38 +0100
Message-Id: <20191211204306.1207817-5-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191211204306.1207817-1-arnd@arndb.de>
References: <20191211204306.1207817-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7VRHp+IKRwV2Q9YentDGY5xMSAqEOhk7ZARK0JfIsCS+oOLEuza
 EzQyPOHsQNVHmCOd2y0s+ZGIglq00NyJws3hpQiZcA4cow9FHjmLk3v5elOH2eBhgann8xY
 928DwvCV5XQhcL0UtEPyXrPXlIQtcYB91MJk24tTX4hhZV/39SFX18bzQunL2y0vECCFc6h
 GKP2Io5tZThqRs1BYRBBg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iq5JBLlu3+U=:/ECo3/I2OfudG0vBX8xJhb
 fx5gydprst2zUW/oZ8T2Tvh9+s+ePA1wGKvIva9yvBaIxQzdNusGcKec3/xeFDMz3U/Q73heD
 XZB05O1vTbWINtAk41Y10queHAC4cW0WBtC+yMt3B6QJ6clE+8wray+pupDtPctdlCpwO07vy
 ghmjZ047czufM9C49L/Efgkhp4fSp4WG0aWRGZyhs+9IqR+K8CYHrBZDa2GqJRF3JNirB8i32
 xqdY+zN2J74AAkqVl6snre2sped1hur5lDTlANtgJGNUN2//kHYmitZy72JV5/H7K7ktWZTXw
 gVu0503X+yqC/c5epuBsq+xuvbK6vsP4r/CCe2qHZoKyG1mfWmmLkKp3Ca1QTxPGMb1SuMQXM
 LpDU8dBaAlP4RvR+j0Mc+IRuM6SL2bh3MX2jTXKKKwlpd5O7KqLi/rJbxriAGlW1+6F2fChEV
 TkfaRUaWMQKsRkmOOp35FkGxdAONa4B5BmxB1yOgR/CGROXGTdLfgSQdA/jL2PyF7O85f6ypz
 vy//qUe2fsTMWgskorZQSRH8Sh2JtE+ycRYubObY/eshvzUJK8QdjbWDDnxAMpHw+wZX9h+9G
 sKgKahjQuBISN8cgOMEac/xfsHZgiqQhs+HaaYwl3Eb21tXSm6LprSLbNFS6igtpu03UviyTM
 DP4ECPqC8Q6kU1rPtPbThrvlUbdMArO67y9TS8xZD5fRlbExyJlya3YFVp5XsIn1EfOmjTHVq
 b1hNbMHeCRLKr01MAHseLxaK2JUCvsjzehSCLRuxcKcx/Ll+z1C56n70JaRNN9xchQurT7eG6
 kmmTfmj8E/SNcO1INGrjkhukC2tF1dpKaUtP01A+M5bWP6e6entdDhPyiNA8QMhFyIjNzgg83
 E3+Rkn+cmASvGcXVQAzg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These were added to blkdev_ioctl() in v4.20 but not blkdev_compat_ioctl,
so add them now.

Cc: <stable@vger.kernel.org> # v4.20+
Fixes: 72cd87576d1d ("block: Introduce BLKGETZONESZ ioctl")
Fixes: 65e4e3eee83d ("block: Introduce BLKGETNRZONES ioctl")
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

