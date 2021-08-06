Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4855C3E2543
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhHFISx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243532AbhHFIRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F2A961167;
        Fri,  6 Aug 2021 08:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237858;
        bh=K7sEvxaluQcGZVGgQ/AHGFUbIVDlE0JjgJajWOr5M40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrmVlyRqGk/Bw02YCPuT+x2jIRmE/bG0OwA/xc1btb6gTPZC9r2pf3wH1rUyMCZI9
         pQcrVseHIn1i7iLEsit6D+4gG7xRHwKDKej5XD4Dd4czfcmvua8dTOZshYTheDGZLK
         rBxN5W56dVywtPm6b9MY/LXhsbC2DI8XvJNVxKss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/23] nvme: fix nvme_setup_command metadata trace event
Date:   Fri,  6 Aug 2021 10:16:43 +0200
Message-Id: <20210806081112.516636636@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



