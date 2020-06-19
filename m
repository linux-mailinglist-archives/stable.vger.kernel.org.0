Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41D8200FF7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393227AbgFSPXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393220AbgFSPXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:23:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CFEC21841;
        Fri, 19 Jun 2020 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580228;
        bh=65ENYAQRWakhPRgaNzD0irL6QZnR+Xw7OGN49opy4QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPkBSkJcK82SO7NmDmqMVfgHv/Er/I0hk04subWMwRNtWqbRnt0ple/ipwDYhagRK
         D/l4eLDxhQj1ppBotKpqFGQE3AwVllatlO82GCyLSrGArk4zKBh9nGYTso5wBEXAh6
         FWI6kmzsan5WD11/EpBsnf7OZv4RUml6ZOErawQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 170/376] nvme-fc: avoid gcc-10 zero-length-bounds warning
Date:   Fri, 19 Jun 2020 16:31:28 +0200
Message-Id: <20200619141718.369565553@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3add1d93d9919b6de94aa47900d4904adffbc976 ]

When CONFIG_ARCH_NO_SG_CHAIN is set, op->sgl[0] cannot be dereferenced,
as gcc-10 now points out:

drivers/nvme/host/fc.c: In function 'nvme_fc_init_request':
drivers/nvme/host/fc.c:1774:29: warning: array subscript 0 is outside the bounds of an interior zero-length array 'struct scatterlist[0]' [-Wzero-length-bounds]
 1774 |  op->op.fcp_req.first_sgl = &op->sgl[0];
      |                             ^~~~~~~~~~~
drivers/nvme/host/fc.c:98:21: note: while referencing 'sgl'
   98 |  struct scatterlist sgl[NVME_INLINE_SG_CNT];
      |                     ^~~

I don't know if this is a legitimate warning or a false-positive.
If this is just a false alarm, the warning is easily suppressed
by interpreting the array as a pointer.

Fixes: b1ae1a238900 ("nvme-fc: Avoid preallocating big SGL for data")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 7dfc4a2ecf1e..5ef4a84c442a 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1771,7 +1771,7 @@ nvme_fc_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	res = __nvme_fc_init_request(ctrl, queue, &op->op, rq, queue->rqcnt++);
 	if (res)
 		return res;
-	op->op.fcp_req.first_sgl = &op->sgl[0];
+	op->op.fcp_req.first_sgl = op->sgl;
 	op->op.fcp_req.private = &op->priv[0];
 	nvme_req(rq)->ctrl = &ctrl->ctrl;
 	return res;
-- 
2.25.1



