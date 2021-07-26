Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA84D3D61E9
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhGZPdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233387AbhGZPcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E2860F9D;
        Mon, 26 Jul 2021 16:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315949;
        bh=m38vBIcWTyamd9bePDedc976hEGXkZsA9Hb8ZNVDMKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSSYddA9oPXaE0RkykC/wIAuoCkY3vH8J5U7mfFsihwcuz0lbUBS2PW+d/9+ccssU
         EfJ3Xh8KGBC1mbFDo98e9RTkjs6Gjjz8TXXTBHepd61v3eJrRAhYEbXL1GU+vqfn02
         mXfbF+nEXKJoih8BiJzb9hHtkolGt68KwKjmaHlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 129/223] nvme: set the PRACT bit when using Write Zeroes with T10 PI
Date:   Mon, 26 Jul 2021 17:38:41 +0200
Message-Id: <20210726153850.475497420@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit aaeb7bb061be545251606f4d9c82d710ca2a7c8e ]

When using Write Zeroes on a namespace that has protection
information enabled they behavior without the PRACT bit
counter-intuitive and will generally lead to validation failures
when reading the written blocks.  Fix this by always setting the
PRACT bit that generates matching PI data on the fly.

Fixes: 6e02318eaea5 ("nvme: add support for the Write Zeroes command")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 66973bb56305..148e756857a8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -880,7 +880,10 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 		cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
 	cmnd->write_zeroes.length =
 		cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
-	cmnd->write_zeroes.control = 0;
+	if (nvme_ns_has_pi(ns))
+		cmnd->write_zeroes.control = cpu_to_le16(NVME_RW_PRINFO_PRACT);
+	else
+		cmnd->write_zeroes.control = 0;
 	return BLK_STS_OK;
 }
 
-- 
2.30.2



