Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD8435AEF9
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 18:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhDJQCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 12:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234392AbhDJQCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 12:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7686F611C2;
        Sat, 10 Apr 2021 16:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618070517;
        bh=Y1k95pTSuUEBVcAjP2VWjsCkb9TRXfXUUTasTVjd7l8=;
        h=From:To:Cc:Subject:Date:From;
        b=WbfBwKYzc+t2RO9/N13YtjyygZkiapOxwTI377ciY/iHobzMLfn1b/3joh0kEIiPe
         AzojM4v3+FCor4wRzeRpnzJzEDunLr5e+zsvPEi0PRxjYYMKWAv2EPpM5nTU6Driq1
         OCsJTyJCG9FCFFNrTUoldXiRbcuKZJaQu63gJLdnumN8CCVenEPXY8HoDwFk4OlqqE
         P1X46S1+aO8WXA6u0PBWBND8FO8cJqTMHz+UAH4np7HHbHKoVA3URrNSq38oEQsc4T
         rC1qiQkBQkO08kNczQCO3jnPQYsrOhAGkoZyjJjhqdm1A7L86C7OiFgvGSz+yc6oCe
         0amtBtj0VAwXg==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Snitzer <snitzer@redhat.com>, kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>, stable@vger.kernel.org
Subject: [PATCH] dm verity: fix unaligned block size
Date:   Sat, 10 Apr 2021 09:01:51 -0700
Message-Id: <20210410160151.1224296-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

When f->roots is 2 and block size is 4096, it will gives unaligned block size
length in the scsi command like below. Let's allocate dm_bufio to set the block
size length to match IO chunk size.

E sd 0    : 0:0:0: [sda] tag#30 request not aligned to the logical block size
E blk_update_request: I/O error, dev sda, sector 10368424 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
E device-mapper: verity-fec: 254:8: FEC 9244672: parity read failed (block 18056): -5

Fixes: ce1cca17381f ("dm verity: fix FEC for RS roots unaligned to block size")
Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/md/dm-verity-fec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 66f4c6398f67..656238131dd7 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -743,7 +743,7 @@ int verity_fec_ctr(struct dm_verity *v)
 	}
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
-					  f->roots << SECTOR_SHIFT,
+					  1 << v->data_dev_block_bits,
 					  1, 0, NULL, NULL);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
-- 
2.31.1.295.g9ea45b61b8-goog

