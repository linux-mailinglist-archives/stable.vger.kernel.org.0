Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C6C3686A8
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 20:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbhDVSiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 14:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbhDVSiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 14:38:16 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F63C06174A
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 11:37:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v13so10386870ple.9
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 11:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+VkpKEMQIKMlIFqN5Fuo0d5Pv7utNqjtoV0bku11qdo=;
        b=gyisl8AeirR/8j1R6SG8sN/UtXfurhNOvTvDIey7e5/EQa9c32cozWORr+zI8DJyPT
         nbe8LE4inSS88tcOPkHPNUqhllwaHFIji+vYOJ/4QEV6ABUZ9xlKlaQXn9WSJoSUGRsW
         gIv1ASrvlxPnd45KravgFoV7JuWrvYL438IONGjW/0XsBzXKw70qadAjbpmGwJyzlAFy
         8+OD+DujezeXGa/f4r7fCvg7ozgP2ygtKU+VYMtvi3+c45QshU0iJkWKYUoTlrEx9IZg
         xmZXQYqTSF7/bs1j2rcVDJ86mpzwItdxJalKgqZLOfsoMmQPamR7KhEWy3DFhHkgjZll
         DpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+VkpKEMQIKMlIFqN5Fuo0d5Pv7utNqjtoV0bku11qdo=;
        b=MMDLnEusNTN+aXAyUmgQ+NYOFXVCag9svt8UWWwxOrar/APzea6EVT81lxgc9XaUm1
         cL2A6wPaq0OtEZOE/is2xDdEVsXHgPwFbUAEqODBDOHP6IVt0sjA0/Aqk7D6e5vOcGOY
         yxpbAJCynRDV/Q0n9LSgrRG2s/zUdFS6lF2jzu9IHKCiI+KbkZ9G48nVWmccvsOm0ra4
         dFST5LzHou9EbOkm8loD62Xa7wHESgT/JCSJnz9jEzC+52WnhegMITFYzPDVDfAroyUp
         z0DkwMoI+qprdGLO9PCBE9tH2mA+aiyZWP74GrtwNTEVLCCspXCy82tkMC7H3KiCUwRQ
         /IOA==
X-Gm-Message-State: AOAM531pnYOgtEugA3il4DdLCOyayfMh2Bg+FSQ8/T0SJWVq2bK6Kj05
        luZlRfVE6KBFutMbt2SQbAI=
X-Google-Smtp-Source: ABdhPJx1/N+UOwDe8o50Q5sveBcdVYfIBHInb1pUczMqAJR9pI4yDB5pXD0tWbH0kfutRMCrgo4VXw==
X-Received: by 2002:a17:902:8bcb:b029:ec:a192:21cf with SMTP id r11-20020a1709028bcbb02900eca19221cfmr4918399plo.71.1619116661633;
        Thu, 22 Apr 2021 11:37:41 -0700 (PDT)
Received: from archl-on1.. ([103.51.72.77])
        by smtp.gmail.com with ESMTPSA id oa9sm2640379pjb.44.2021.04.22.11.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 11:37:40 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     linux.amoon@gmail.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm verity fec: fix misaligned RS roots IO
Date:   Thu, 22 Apr 2021 18:37:33 +0000
Message-Id: <20210422183733.918-1-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

commit df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to
block size") introduced the possibility for misaligned roots IO
relative to the underlying device's logical block size. E.g. Android's
default RS roots=2 results in dm_bufio->block_size=1024, which causes
the following EIO if the logical block size of the device is 4096,
given v->data_dev_block_bits=12:

E sd 0    : 0:0:0: [sda] tag#30 request not aligned to the logical block size
E blk_update_request: I/O error, dev sda, sector 10368424 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
E device-mapper: verity-fec: 254:8: FEC 9244672: parity read failed (block 18056): -5

Fix this by onlu using f->roots for dm_bufio blocksize IFF it is
aligned to v->data_dev_block_bits.

Fixes: df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to block size")
Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-verity-fec.c | 11 ++++++++---
 drivers/md/dm-verity-fec.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 66f4c6398f67..cea2b3789736 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -65,7 +65,7 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 	u8 *res;
 
 	position = (index + rsb) * v->fec->roots;
-	block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
+	block = div64_u64_rem(position, v->fec->io_size, &rem);
 	*offset = (unsigned)rem;
 
 	res = dm_bufio_read(v->fec->bufio, block, buf);
@@ -154,7 +154,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 
 		/* read the next block when we run out of parity bytes */
 		offset += v->fec->roots;
-		if (offset >= v->fec->roots << SECTOR_SHIFT) {
+		if (offset >= v->fec->io_size) {
 			dm_bufio_release(buf);
 
 			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
@@ -742,8 +742,13 @@ int verity_fec_ctr(struct dm_verity *v)
 		return -E2BIG;
 	}
 
+	if ((f->roots << SECTOR_SHIFT) & ((1 << v->data_dev_block_bits) - 1))
+		f->io_size = 1 << v->data_dev_block_bits;
+	else
+		f->io_size = v->fec->roots << SECTOR_SHIFT;
+
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
-					  f->roots << SECTOR_SHIFT,
+					  f->io_size,
 					  1, 0, NULL, NULL);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 42fbd3a7fc9f..3c46c8d61883 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -36,6 +36,7 @@ struct dm_verity_fec {
 	struct dm_dev *dev;	/* parity data device */
 	struct dm_bufio_client *data_bufio;	/* for data dev access */
 	struct dm_bufio_client *bufio;		/* for parity data access */
+	size_t io_size;		/* IO size for roots */
 	sector_t start;		/* parity data start in blocks */
 	sector_t blocks;	/* number of blocks covered */
 	sector_t rounds;	/* number of interleaving rounds */
-- 
2.31.1

