Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F7F3C5341
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352198AbhGLHyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244770AbhGLHtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:49:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B2461995;
        Mon, 12 Jul 2021 07:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075796;
        bh=QTl3lypdgIKQWU7PRoO3Sni6CNBBYi6P/RQfj2V9BCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4i6FLrNEviFrzWyPRGM2XRes7PKfrUG8rjM9Fk3liRu+6xeAf9Qfv0hE3mL2+b5c
         4BK5cEf4HB7sbEJxWcEKeQxZrYLhnmbTHcGQI5DR9gOuAj+vgLA2fSGzmfqTyBVXTG
         SVVJ/OzOjI58puP8u/BwvzDCbjuX+iB7eWp0N5dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 367/800] nvme-tcp: fix error codes in nvme_tcp_setup_ctrl()
Date:   Mon, 12 Jul 2021 08:06:30 +0200
Message-Id: <20210712061006.095195458@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 522af60cb2f8e3658bda1902fb7f200dcf888a5c ]

These error paths currently return success but they should return
-EOPNOTSUPP.

Fixes: 73ffcefcfca0 ("nvme-tcp: check sgl supported by target")
Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 34f4b3402f7c..79a463090dd3 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1973,11 +1973,13 @@ static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 		return ret;
 
 	if (ctrl->icdoff) {
+		ret = -EOPNOTSUPP;
 		dev_err(ctrl->device, "icdoff is not supported!\n");
 		goto destroy_admin;
 	}
 
 	if (!(ctrl->sgls & ((1 << 0) | (1 << 1)))) {
+		ret = -EOPNOTSUPP;
 		dev_err(ctrl->device, "Mandatory sgls are not supported!\n");
 		goto destroy_admin;
 	}
-- 
2.30.2



