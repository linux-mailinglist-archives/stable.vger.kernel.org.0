Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B7A3D767E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhG0N35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236947AbhG0NU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D3F761AFE;
        Tue, 27 Jul 2021 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392013;
        bh=K7sEvxaluQcGZVGgQ/AHGFUbIVDlE0JjgJajWOr5M40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJaana1LomwbEHEK11Z7GSNP7CwfRMSqmY8GCkcepdkAA9zcJx+YFSoxC7URrJX+a
         4xUVxuhai+w5fLfQ0ITVUbOCLkDCYUweS7bBB0VFeKckUj2FjxPxLn73V+f0+6UIfY
         bNw1a2uZQdo8IdGcvbekdr2pK7aFDOCfAnz3Z9oEsM2EkPMnb3nnmkwOn6b2knnB4D
         xeMa1OEs4NFd5YQ+9VgRLRKd+eJ3NXh9PxArrpTST+5vpyDSwuQ8CcStdoAOfcTKjA
         am/c5UcyVey/meNqQluYwWM6p9/2CAkLqH13LfGYPKroKDuWVg5WFwcwvno5WMlHJf
         nG2zWmAg0TrOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 8/9] nvme: fix nvme_setup_command metadata trace event
Date:   Tue, 27 Jul 2021 09:20:00 -0400
Message-Id: <20210727132002.835130-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132002.835130-1-sashal@kernel.org>
References: <20210727132002.835130-1-sashal@kernel.org>
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

