Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2565579F4D
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243416AbiGSNNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243418AbiGSNMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:12:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9401967C9E;
        Tue, 19 Jul 2022 05:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B144609FB;
        Tue, 19 Jul 2022 12:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40B3C341C6;
        Tue, 19 Jul 2022 12:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233778;
        bh=CH3O+8rE7gc07cwtk2Pd8nsB1wVExVHVq8mfQlHMR5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPy3huWVFiCBWpnv3lUipLtmwo5v7ivJia8vGvtMYkBW/zbVO2NOdT1WfpszPHC8H
         tyFVRUNA6C1PTNAd81uKX7JZaJupgnuO/uY/OEjaaw4YppQemrSGJCmGNzyPTXvU6Z
         ehgv+zBcC4tIG9cljGZzU8vRp5rGgBq4aXuGdahc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 217/231] nvme: use struct group for generic command dwords
Date:   Tue, 19 Jul 2022 13:55:02 +0200
Message-Id: <20220719114732.046532360@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



