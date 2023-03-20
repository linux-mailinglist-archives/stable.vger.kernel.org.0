Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F9D6C16D4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbjCTPJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjCTPJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:09:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83831449B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1703A6154D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29641C433D2;
        Mon, 20 Mar 2023 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324670;
        bh=r4AFh1Z5AoPzx34H47DldwJMaDSmt8xpIpyRrbvQ6so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSpwD/SEQNp5/2e5DsSS7T9yasWsub2x4AGXLvH58tnBi8M1avfi2UkI2LEBxyfME
         w1LF67qQ36KzkLsp/YHA5NWKbHHEVLoqUeEovgwnB2et7tWdBfIWo3XLT++kfoakM5
         iO0rI5m/gE6t3wxPj1qYD0ykhIEAo4NzMSnWO1aY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Lei <ming.lei@redhat.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/99] nvme: fix handling single range discard request
Date:   Mon, 20 Mar 2023 15:54:07 +0100
Message-Id: <20230320145444.605564840@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 37f0dc2ec78af0c3f35dd05578763de059f6fe77 ]

When investigating one customer report on warning in nvme_setup_discard,
we observed the controller(nvme/tcp) actually exposes
queue_max_discard_segments(req->q) == 1.

Obviously the current code can't handle this situation, since contiguity
merge like normal RW request is taken.

Fix the issue by building range from request sector/nr_sectors directly.

Fixes: b35ba01ea697 ("nvme: support ranged discard requests")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e162f1dfbafe9..a4b6aa932a8fe 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -723,16 +723,26 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		range = page_address(ns->ctrl->discard_page);
 	}
 
-	__rq_for_each_bio(bio, req) {
-		u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
-		u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
-
-		if (n < segments) {
-			range[n].cattr = cpu_to_le32(0);
-			range[n].nlb = cpu_to_le32(nlb);
-			range[n].slba = cpu_to_le64(slba);
+	if (queue_max_discard_segments(req->q) == 1) {
+		u64 slba = nvme_sect_to_lba(ns, blk_rq_pos(req));
+		u32 nlb = blk_rq_sectors(req) >> (ns->lba_shift - 9);
+
+		range[0].cattr = cpu_to_le32(0);
+		range[0].nlb = cpu_to_le32(nlb);
+		range[0].slba = cpu_to_le64(slba);
+		n = 1;
+	} else {
+		__rq_for_each_bio(bio, req) {
+			u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
+			u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
+
+			if (n < segments) {
+				range[n].cattr = cpu_to_le32(0);
+				range[n].nlb = cpu_to_le32(nlb);
+				range[n].slba = cpu_to_le64(slba);
+			}
+			n++;
 		}
-		n++;
 	}
 
 	if (WARN_ON_ONCE(n != segments)) {
-- 
2.39.2



