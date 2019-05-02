Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB7811DAF
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfEBPc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbfEBPc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D90CC204FD;
        Thu,  2 May 2019 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811147;
        bh=nhABnP/eZJca2ySwVW8EZE45ezHpT5DkPiUpZAu3HQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQD8NRI38pGVS1NBVgu/F6cmamzqfuiWAsr7HTDdhoOQC0W6aVVww9s7/hT+LfiMt
         K1NIUXTQK1m5tRhkB9ki/2FqmCUZeUgPN9Cp6XkdHPIbwtyYAVN2nOJiXlgeY+WCSK
         OtU5Xg7jw4lkErOTJ4uDAqwQdBCSyIAcuhg4ACwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 092/101] nvmet: fix building bvec from sg list
Date:   Thu,  2 May 2019 17:21:34 +0200
Message-Id: <20190502143346.030401859@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 02db99548d3608a625cf481cff2bb7b626829b3f ]

There are two mistakes for building bvec from sg list for file
backed ns:

- use request data length to compute number of io vector, this way
doesn't consider sg->offset, and the result may be smaller than required
io vectors

- bvec->bv_len isn't capped by sg->length

This patch fixes this issue by building bvec from sg directly, given
the whole IO stack is ready for multi-page bvec.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: 3a85a5de29ea ("nvme-loop: add a NVMe loopback host driver")

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 517522305e5c..9a0fa3943ca7 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -75,11 +75,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 	return ret;
 }
 
-static void nvmet_file_init_bvec(struct bio_vec *bv, struct sg_page_iter *iter)
+static void nvmet_file_init_bvec(struct bio_vec *bv, struct scatterlist *sg)
 {
-	bv->bv_page = sg_page_iter_page(iter);
-	bv->bv_offset = iter->sg->offset;
-	bv->bv_len = PAGE_SIZE - iter->sg->offset;
+	bv->bv_page = sg_page(sg);
+	bv->bv_offset = sg->offset;
+	bv->bv_len = sg->length;
 }
 
 static ssize_t nvmet_file_submit_bvec(struct nvmet_req *req, loff_t pos,
@@ -128,14 +128,14 @@ static void nvmet_file_io_done(struct kiocb *iocb, long ret, long ret2)
 
 static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 {
-	ssize_t nr_bvec = DIV_ROUND_UP(req->data_len, PAGE_SIZE);
-	struct sg_page_iter sg_pg_iter;
+	ssize_t nr_bvec = req->sg_cnt;
 	unsigned long bv_cnt = 0;
 	bool is_sync = false;
 	size_t len = 0, total_len = 0;
 	ssize_t ret = 0;
 	loff_t pos;
-
+	int i;
+	struct scatterlist *sg;
 
 	if (req->f.mpool_alloc && nr_bvec > NVMET_MAX_MPOOL_BVEC)
 		is_sync = true;
@@ -147,8 +147,8 @@ static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 	}
 
 	memset(&req->f.iocb, 0, sizeof(struct kiocb));
-	for_each_sg_page(req->sg, &sg_pg_iter, req->sg_cnt, 0) {
-		nvmet_file_init_bvec(&req->f.bvec[bv_cnt], &sg_pg_iter);
+	for_each_sg(req->sg, sg, req->sg_cnt, i) {
+		nvmet_file_init_bvec(&req->f.bvec[bv_cnt], sg);
 		len += req->f.bvec[bv_cnt].bv_len;
 		total_len += req->f.bvec[bv_cnt].bv_len;
 		bv_cnt++;
@@ -225,7 +225,7 @@ static void nvmet_file_submit_buffered_io(struct nvmet_req *req)
 
 static void nvmet_file_execute_rw(struct nvmet_req *req)
 {
-	ssize_t nr_bvec = DIV_ROUND_UP(req->data_len, PAGE_SIZE);
+	ssize_t nr_bvec = req->sg_cnt;
 
 	if (!req->sg_cnt || !nr_bvec) {
 		nvmet_req_complete(req, 0);
-- 
2.19.1



