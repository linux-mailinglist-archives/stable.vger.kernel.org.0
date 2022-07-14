Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4675742ED
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbiGNE1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbiGNE1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:27:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E15286C5;
        Wed, 13 Jul 2022 21:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60F25CE2358;
        Thu, 14 Jul 2022 04:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB01C34114;
        Thu, 14 Jul 2022 04:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772639;
        bh=CH3O+8rE7gc07cwtk2Pd8nsB1wVExVHVq8mfQlHMR5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6M4EdKKExuf7iUl//Eg88iTfzk5q+8XQE8Ip0eMiX6lsFwFwtrCYIN3q8K9i9FUx
         MqzjJkUNGPjKg6yvwNiPT5Jb+PyvU9nX0CfFMWc272jHB/qm+JdHpEo0b2J6xQXjuP
         0ocyEksL10sxSujsZFexlNc0n0wnvNyPruG6DzbNwAap0hDJi6wmPGdK+vh68/5ES6
         KJzC/87JmDuQjvQUjUlb503CD/WhDR7JuUFkMAAtNNeoBjdSrhyKs62sJb7w/6vs/I
         F7lLP2Dh6EZedPDmhUpA0KFdJIqTSJtHWhfXyr30pMD/25k2w3fdRPhahGI8Wo7A1v
         2vOT/66ng/TKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 37/41] nvme: use struct group for generic command dwords
Date:   Thu, 14 Jul 2022 00:22:17 -0400
Message-Id: <20220714042221.281187-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 5c629dc9609dc43492a7bc8060cc6120875bf096 ]

This will allow the trace event to know the full size of the data
intended to be copied and silence read overflow checks.

Reported-by: John Garry <john.garry@huawei.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/trace.h | 2 +-
 include/linux/nvme.h      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/trace.h b/drivers/nvme/host/trace.h
index b5f85259461a..37c7f4c89f92 100644
--- a/drivers/nvme/host/trace.h
+++ b/drivers/nvme/host/trace.h
@@ -69,7 +69,7 @@ TRACE_EVENT(nvme_setup_cmd,
 		__entry->metadata = !!blk_integrity_rq(req);
 		__entry->fctype = cmd->fabrics.fctype;
 		__assign_disk_name(__entry->disk, req->q->disk);
-		memcpy(__entry->cdw10, &cmd->common.cdw10,
+		memcpy(__entry->cdw10, &cmd->common.cdws,
 			sizeof(__entry->cdw10));
 	    ),
 	    TP_printk("nvme%d: %sqid=%d, cmdid=%u, nsid=%u, flags=0x%x, meta=0x%x, cmd=(%s %s)",
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index f626a445d1a8..99b1b56f0cd3 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -867,12 +867,14 @@ struct nvme_common_command {
 	__le32			cdw2[2];
 	__le64			metadata;
 	union nvme_data_ptr	dptr;
+	struct_group(cdws,
 	__le32			cdw10;
 	__le32			cdw11;
 	__le32			cdw12;
 	__le32			cdw13;
 	__le32			cdw14;
 	__le32			cdw15;
+	);
 };
 
 struct nvme_rw_command {
-- 
2.35.1

