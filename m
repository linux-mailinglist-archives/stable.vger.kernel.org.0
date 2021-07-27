Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E173D7617
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbhG0NXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236896AbhG0NUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84FB461A3A;
        Tue, 27 Jul 2021 13:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391996;
        bh=K7sEvxaluQcGZVGgQ/AHGFUbIVDlE0JjgJajWOr5M40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZM8MYipCWVluJiGmTneAJKTWXc2YzI82oXCx4cG3m7gBaXGQwLiDTFEKxkjIy47A
         B7JM6jP03fDaZ7pHZtaZp240zVyIn87K7uaNng7zeEhYz2mluO+lY4KOfvW3R01UHc
         uFIBZj5KyFHtfAr+VaGawwEC8b+AZV45gokFMYXJWx18IoVutrXQ83G/+SJWTJcgIu
         eSf2Ck0sG2Vfq6oMO5dorlBfy3KvYXVmXe+LmACyOVA0D/8jgIqDATdtpStLCpUa3Y
         nO6eVys8I0JZPfs0Hicl8CA8bUsZ21ke15qCd7ZXeA+XU4ioYg4axeYbUy0Z5FEyad
         UY0b1gKb928Fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 14/17] nvme: fix nvme_setup_command metadata trace event
Date:   Tue, 27 Jul 2021 09:19:35 -0400
Message-Id: <20210727131938.834920-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131938.834920-1-sashal@kernel.org>
References: <20210727131938.834920-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 234211b8dd161fa25f192c78d5a8d2dd6bf920a0 ]

The metadata address is set after the trace event, so the trace is not
capturing anything useful. Rather than logging the memory address, it's
useful to know if the command carries a metadata payload, so change the
trace event to log that true/false state instead.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/trace.h b/drivers/nvme/host/trace.h
index daaf700eae79..35bac7a25422 100644
--- a/drivers/nvme/host/trace.h
+++ b/drivers/nvme/host/trace.h
@@ -56,7 +56,7 @@ TRACE_EVENT(nvme_setup_cmd,
 		__field(u8, fctype)
 		__field(u16, cid)
 		__field(u32, nsid)
-		__field(u64, metadata)
+		__field(bool, metadata)
 		__array(u8, cdw10, 24)
 	    ),
 	    TP_fast_assign(
@@ -66,13 +66,13 @@ TRACE_EVENT(nvme_setup_cmd,
 		__entry->flags = cmd->common.flags;
 		__entry->cid = cmd->common.command_id;
 		__entry->nsid = le32_to_cpu(cmd->common.nsid);
-		__entry->metadata = le64_to_cpu(cmd->common.metadata);
+		__entry->metadata = !!blk_integrity_rq(req);
 		__entry->fctype = cmd->fabrics.fctype;
 		__assign_disk_name(__entry->disk, req->rq_disk);
 		memcpy(__entry->cdw10, &cmd->common.cdw10,
 			sizeof(__entry->cdw10));
 	    ),
-	    TP_printk("nvme%d: %sqid=%d, cmdid=%u, nsid=%u, flags=0x%x, meta=0x%llx, cmd=(%s %s)",
+	    TP_printk("nvme%d: %sqid=%d, cmdid=%u, nsid=%u, flags=0x%x, meta=0x%x, cmd=(%s %s)",
 		      __entry->ctrl_id, __print_disk_name(__entry->disk),
 		      __entry->qid, __entry->cid, __entry->nsid,
 		      __entry->flags, __entry->metadata,
-- 
2.30.2

