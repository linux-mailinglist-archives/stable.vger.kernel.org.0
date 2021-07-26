Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636EF3D60A7
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbhGZPXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237594AbhGZPXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1BC260240;
        Mon, 26 Jul 2021 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315442;
        bh=7EoFKsfVQOJmFmNvmQTuVHQ2W3N/DNsssLIlJoOW6jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Df9Bv1rX4jOfkCP1pdel0AmEry5SjK5YB68cH5Ks5M6QgwOgItDRv4o8IJAydB7/R
         VIhfm5xdd2qXsnsc5lhmx21sNwuqDSlZhUF0npSaszHfmyJOy+ag9JO9fwZ1lUOJ3B
         Jg/f5aigRgiEcydx4XmQb8zOT11Se0ZEWJ7GyHx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/167] nvme: set the PRACT bit when using Write Zeroes with T10 PI
Date:   Mon, 26 Jul 2021 17:38:50 +0200
Message-Id: <20210726153842.655674187@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index f520a71a361f..ff5a16b17133 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -751,7 +751,10 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
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



