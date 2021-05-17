Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AEF383707
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbhEQPiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244187AbhEQPgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:36:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50DED6193B;
        Mon, 17 May 2021 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262415;
        bh=ZYBXfh3RkmqL8v5AMtyZ1QUZJzFMuyQUWoQSFTM50eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5Ro8opFPo6snZENiyWIe4XXeex4ZqkBiqrhBUcEepCqPwZMDIlC3eX2cU2kQIFqs
         6XmEDzFgAFNi9HAs9OTc1qJOGCpCWBH3mJLIVD9kWsiD/xGJrH6NW6vxNKATUJZbTb
         GBF7bQpBjwWn/d0itH8DDuQOvouEHF+XyIhhLyX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 273/329] nvmet: fix inline bio check for passthru
Date:   Mon, 17 May 2021 16:03:04 +0200
Message-Id: <20210517140311.352823035@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit ab96de5def854d8fc51280b6a20597e64b14ac31 ]

When handling passthru commands, for inline bio allocation we only
consider the transfer size. This works well when req->sg_cnt fits into
the req->inline_bvec, but it will result in the early return from
bio_add_hw_page() when req->sg_cnt > NVMET_MAX_INLINE_BVEC.

Consider an I/O of size 32768 and first buffer is not aligned to the
page boundary, then I/O is split in following manner :-

[ 2206.256140] nvmet: sg->length 3440 sg->offset 656
[ 2206.256144] nvmet: sg->length 4096 sg->offset 0
[ 2206.256148] nvmet: sg->length 4096 sg->offset 0
[ 2206.256152] nvmet: sg->length 4096 sg->offset 0
[ 2206.256155] nvmet: sg->length 4096 sg->offset 0
[ 2206.256159] nvmet: sg->length 4096 sg->offset 0
[ 2206.256163] nvmet: sg->length 4096 sg->offset 0
[ 2206.256166] nvmet: sg->length 4096 sg->offset 0
[ 2206.256170] nvmet: sg->length 656 sg->offset 0

Now the req->transfer_size == NVMET_MAX_INLINE_DATA_LEN i.e. 32768, but
the req->sg_cnt is (9) > NVMET_MAX_INLINE_BIOVEC which is (8).
This will result in early return in the following code path :-

nvmet_bdev_execute_rw()
	bio_add_pc_page()
		bio_add_hw_page()
			if (bio_full(bio, len))
				return 0;

Use previously introduced helper nvmet_use_inline_bvec() to consider
req->sg_cnt when using inline bio. This only affects nvme-loop
transport.

Fixes: dab3902b19a0 ("nvmet: use inline bio for passthru fast path")
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/passthru.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index b9776fc8f08f..df6f64870cec 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -194,7 +194,7 @@ static int nvmet_passthru_map_sg(struct nvmet_req *req, struct request *rq)
 	if (req->sg_cnt > BIO_MAX_PAGES)
 		return -EINVAL;
 
-	if (req->transfer_len <= NVMET_MAX_INLINE_DATA_LEN) {
+	if (nvmet_use_inline_bvec(req)) {
 		bio = &req->p.inline_bio;
 		bio_init(bio, req->inline_bvec, ARRAY_SIZE(req->inline_bvec));
 	} else {
-- 
2.30.2



