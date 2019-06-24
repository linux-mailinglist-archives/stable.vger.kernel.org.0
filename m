Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D8550855
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbfFXKQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730759AbfFXKQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:35 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C96F721473;
        Mon, 24 Jun 2019 10:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371395;
        bh=ZoUvg6Cuj0gLOckE2E1pb8pVmMdC6IXEbv+tF/XOAV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fw+LhZGKx+1GB6Th3Zjyra0OgWQNqdTwEbqimPd5LCnajMQPLpfAaM2Xj1umuzarp
         67NpV8ib+33pjCG3BlaP9LS/nddAjqJdKGlqpcviu1srZjbz5xunZjQUqwrafti03S
         JDdIKeURdtXRdBqbtmJCRbLrN75dVb2G/afyKuLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaesoo Lee <jalee@purestorage.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 088/121] nvme: Fix u32 overflow in the number of namespace list calculation
Date:   Mon, 24 Jun 2019 17:57:00 +0800
Message-Id: <20190624092325.313690600@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c8e8c77b3bdbade6e26e8e76595f141ede12b692 ]

The Number of Namespaces (nn) field in the identify controller data structure is
defined as u32 and the maximum allowed value in NVMe specification is
0xFFFFFFFEUL. This change fixes the possible overflow of the DIV_ROUND_UP()
operation used in nvme_scan_ns_list() by casting the nn to u64.

Signed-off-by: Jaesoo Lee <jalee@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 35d2202ee2fd..3a390b2c7540 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3397,7 +3397,8 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl, unsigned nn)
 {
 	struct nvme_ns *ns;
 	__le32 *ns_list;
-	unsigned i, j, nsid, prev = 0, num_lists = DIV_ROUND_UP(nn, 1024);
+	unsigned i, j, nsid, prev = 0;
+	unsigned num_lists = DIV_ROUND_UP_ULL((u64)nn, 1024);
 	int ret = 0;
 
 	ns_list = kzalloc(NVME_IDENTIFY_DATA_SIZE, GFP_KERNEL);
-- 
2.20.1



