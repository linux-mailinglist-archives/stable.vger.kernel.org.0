Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EA53301B7
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhCGN6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231668AbhCGN6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B8E65106;
        Sun,  7 Mar 2021 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125498;
        bh=vuL1DU8JbHxwvGF0GtLVy4mJVmrXO2RAiUprga/b63s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbQ2v++bWMp126PbqVpX7Pps0xCMmLve0Mz9Lw3Ql2L/fYgfcTX32brVivWztxi4O
         rUbrOWryBPBlVJfVhttrsDNiPDmEQu5bcBNkHiTeZOhIJPtw3vTKmrkRGL5SwliJ3X
         6UEQOVyao6dBu9n42jSvkx/cpo59yv993UUydnyL3peyN6JTB62fDbMwG7bdg82YbW
         GL8pjP7vn2m3Rbgl5XLQ0Ud3ZnZ8dGrKsiqcSYnkaggYxCMIFdFAx3H2GfFTkQdjlg
         rQYy2iZ9WYzqTM7EQz0j4uMUySe7EwFN1GSIEU49oqjPUS9q0ybi5Vy4OXW7Z8CczD
         h+M4slCMJQPnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin George <marting@netapp.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 5/5] nvme-fabrics: fix kato initialization
Date:   Sun,  7 Mar 2021 08:58:11 -0500
Message-Id: <20210307135812.967702-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135812.967702-1-sashal@kernel.org>
References: <20210307135812.967702-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin George <marting@netapp.com>

[ Upstream commit 32feb6de47242e54692eceab52cfae8616aa0518 ]

Currently kato is initialized to NVME_DEFAULT_KATO for both
discovery & i/o controllers. This is a problem specifically
for non-persistent discovery controllers since it always ends
up with a non-zero kato value. Fix this by initializing kato
to zero instead, and ensuring various controllers are assigned
appropriate kato values as follows:

non-persistent controllers  - kato set to zero
persistent controllers      - kato set to NVMF_DEV_DISC_TMO
                              (or any positive int via nvme-cli)
i/o controllers             - kato set to NVME_DEFAULT_KATO
                              (or any positive int via nvme-cli)

Signed-off-by: Martin George <marting@netapp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 3bb71f177dfd..8a2c5587def9 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -632,7 +632,7 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 	opts->queue_size = NVMF_DEF_QUEUE_SIZE;
 	opts->nr_io_queues = num_online_cpus();
 	opts->reconnect_delay = NVMF_DEF_RECONNECT_DELAY;
-	opts->kato = NVME_DEFAULT_KATO;
+	opts->kato = 0;
 	opts->duplicate_connect = false;
 	opts->hdr_digest = false;
 	opts->data_digest = false;
@@ -883,6 +883,9 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 		opts->nr_write_queues = 0;
 		opts->nr_poll_queues = 0;
 		opts->duplicate_connect = true;
+	} else {
+		if (!opts->kato)
+			opts->kato = NVME_DEFAULT_KATO;
 	}
 	if (ctrl_loss_tmo < 0)
 		opts->max_reconnects = -1;
-- 
2.30.1

