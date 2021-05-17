Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8AD3831A5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbhEQOi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239931AbhEQOgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:36:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE4C661931;
        Mon, 17 May 2021 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261049;
        bh=ORIEIAuVkV+ADSqQE7UO46WkdVMw4FbH6xBYEFtThK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcvNpPYIr4EdaqN0sljLbzoLgLN9W/RsGcAen7QHpKpnysTIvDa6aDheHyHE4pinp
         FBwuVtugzSaWliHwu+mR8fzKlkT6+afix6wjXoCfTwEfu/KEh08m4LMuTqrVBphlTQ
         oT1YNNEjpgo7A+2MpDWGpryNUGyUzTL8SqrfKt4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 297/363] nvmet: fix inline bio check for bdev-ns
Date:   Mon, 17 May 2021 16:02:43 +0200
Message-Id: <20210517140312.647231788@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 608a969046e6e0567d05a166be66c77d2dd8220b ]

When handling rw commands, for inline bio case we only consider
transfer size. This works well when req->sg_cnt fits into the
req->inline_bvec, but it will result in the warning in
__bio_add_page() when req->sg_cnt > NVMET_MAX_INLINE_BVEC.

Consider an I/O size 32768 and first page is not aligned to the page
boundary, then I/O is split in following manner :-

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
This will result in the following warning message :-

nvmet_bdev_execute_rw()
	bio_add_page()
		__bio_add_page()
			WARN_ON_ONCE(bio_full(bio, len));

This scenario is very hard to reproduce on the nvme-loop transport only
with rw commands issued with the passthru IOCTL interface from the host
application and the data buffer is allocated with the malloc() and not
the posix_memalign().

Fixes: 73383adfad24 ("nvmet: don't split large I/Os unconditionally")
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 2 +-
 drivers/nvme/target/nvmet.h       | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 9a8b3726a37c..429263ca9b97 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -258,7 +258,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 
 	sector = nvmet_lba_to_sect(req->ns, req->cmd->rw.slba);
 
-	if (req->transfer_len <= NVMET_MAX_INLINE_DATA_LEN) {
+	if (nvmet_use_inline_bvec(req)) {
 		bio = &req->b.inline_bio;
 		bio_init(bio, req->inline_bvec, ARRAY_SIZE(req->inline_bvec));
 	} else {
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 4b84edb49f22..5aad34b106dc 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -614,4 +614,10 @@ static inline sector_t nvmet_lba_to_sect(struct nvmet_ns *ns, __le64 lba)
 	return le64_to_cpu(lba) << (ns->blksize_shift - SECTOR_SHIFT);
 }
 
+static inline bool nvmet_use_inline_bvec(struct nvmet_req *req)
+{
+	return req->transfer_len <= NVMET_MAX_INLINE_DATA_LEN &&
+	       req->sg_cnt <= NVMET_MAX_INLINE_BIOVEC;
+}
+
 #endif /* _NVMET_H */
-- 
2.30.2



