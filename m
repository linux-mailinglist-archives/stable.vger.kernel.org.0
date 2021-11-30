Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971B94637E9
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242497AbhK3O5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbhK3Oxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F68DC0613B3;
        Tue, 30 Nov 2021 06:49:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75103CE1A5C;
        Tue, 30 Nov 2021 14:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9B9C53FCF;
        Tue, 30 Nov 2021 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283742;
        bh=Ku7nmQKR6nKu9eyH26k6lOkXuHGUGiDdtGKdJXVxUuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otMl+3ySrYcRYTFd0nyWylUWGcXICbxodHn9CZd7pZdGMd0TLY9QQhfumzl3v6UGI
         /cd/OKfrSHNbLRAI1C+Sw1xdzP0TeDTcEia3z5oqgs0IfoXf9hwg12NDcVa2EdV4TY
         ik5/CT2SOf3sUw37tTmt1pCqRYoBTKKl4BKTidVTBDd7bjA1JP6Z8+M5vldIoL/ox2
         gjpfWkb8c9TZwLoh0BLalEXqKY0r11NaBveGTPz4NC8zF+Ljtz6PbSIB93o+zI1rPS
         P0d7Gg9QBZ3RGXIIns4tpPeFZQGhZ5CONxVKyawsd4BRG3dta/St7mOyRHl/dkhzhj
         /Pahn0nYq9s6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 46/68] nvme-fabrics: ignore invalid fast_io_fail_tmo values
Date:   Tue, 30 Nov 2021 09:46:42 -0500
Message-Id: <20211130144707.944580-46-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 8e8aaf512a91ae44d40647a88b51326c7b0a70a8 ]

Valid fast_io_fail_tmo values are integers >= 0 or -1 (disabled).
Prevent userspace from setting arbitrary negative values.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 668c6bb7a567f..fb5cc5d14899d 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -697,6 +697,9 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			if (token >= 0)
 				pr_warn("I/O fail on reconnect controller after %d sec\n",
 					token);
+			else
+				token = -1;
+
 			opts->fast_io_fail_tmo = token;
 			break;
 		case NVMF_OPT_HOSTNQN:
-- 
2.33.0

