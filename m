Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6C926FABA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 12:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgIRKhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 06:37:51 -0400
Received: from m42-11.mailgun.net ([69.72.42.11]:34645 "EHLO
        m42-11.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgIRKhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 06:37:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600425470; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=qb2WoD3uf4Yfjw2dRwpjc0+G2WvhyNMin/XBmb+tRQ4=; b=IuHll3edWqs/gCibEznXYpdhZWqHzTk/QKdndMfTNnsFdsOf4FhwoZZ+u1DouSpVz3DhplbH
 NKpahd+tdgOnCz4kNej4hcABwb09gkIfrnlVhp1xadHJNtyl1FvqsAZ2WfuR/c+VpPlVUwK+
 t/S2buIp3b1AouRaGKB9VbujGKE=
X-Mailgun-Sending-Ip: 69.72.42.11
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f648ccdea858627d5e3c9de (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 18 Sep 2020 10:32:45
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EF4A1C43391; Fri, 18 Sep 2020 10:32:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from charante-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: charante)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 21028C43382;
        Fri, 18 Sep 2020 10:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 21028C43382
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=charante@codeaurora.org
From:   Charan Teja Reddy <charante@codeaurora.org>
To:     sumit.semwal@linaro.org, christian.koenig@amd.com, arnd@arndb.de
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        vinmenon@codeaurora.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] dmabuf: fix NULL pointer dereference in dma_buf_release()
Date:   Fri, 18 Sep 2020 16:02:31 +0530
Message-Id: <1600425151-27670-1-git-send-email-charante@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

NULL pointer dereference is observed while exporting the dmabuf but
failed to allocate the 'struct file' which results into the dropping of
the allocated dentry corresponding to this file in the dmabuf fs, which
is ending up in dma_buf_release() and accessing the uninitialzed
dentry->d_fsdata.

Call stack on 5.4 is below:
 dma_buf_release+0x2c/0x254 drivers/dma-buf/dma-buf.c:88
 __dentry_kill+0x294/0x31c fs/dcache.c:584
 dentry_kill fs/dcache.c:673 [inline]
 dput+0x250/0x380 fs/dcache.c:859
 path_put+0x24/0x40 fs/namei.c:485
 alloc_file_pseudo+0x1a4/0x200 fs/file_table.c:235
 dma_buf_getfile drivers/dma-buf/dma-buf.c:473 [inline]
 dma_buf_export+0x25c/0x3ec drivers/dma-buf/dma-buf.c:585

Fix this by checking for the valid pointer in the dentry->d_fsdata.

Fixes: 4ab59c3c638c ("dma-buf: Move dma_buf_release() from fops to dentry_ops")
Cc: <stable@vger.kernel.org> [5.7+]
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
---
 drivers/dma-buf/dma-buf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 58564d82..844967f 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -59,6 +59,8 @@ static void dma_buf_release(struct dentry *dentry)
 	struct dma_buf *dmabuf;
 
 	dmabuf = dentry->d_fsdata;
+	if (unlikely(!dmabuf))
+		return;
 
 	BUG_ON(dmabuf->vmapping_counter);
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

