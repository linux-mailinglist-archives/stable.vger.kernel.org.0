Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26ABC3BBF9B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhGEPch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232110AbhGEPc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C634619A5;
        Mon,  5 Jul 2021 15:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498990;
        bh=mmdAldEcnqi6sXxjo3oondyAT2E/9YNScMhIXaq+oTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYyrBa5LvpJv+6uyngO0S9I05mZCE1MBO85Jt2E0y7Urzz81Qa3qiYfY0HHNqVSHg
         tMFcAa5fREkpLa89qFRbqE/KJS0tE0fg+R1fcEpjXW2zjy/YEzqM5WbNlba8xvcRwh
         7pMgNJdl8Xm6OsjA7wCb8wylNg/9qqNg6I3UIMUCrXrFE5GzQJoMklLpbO5dr6alx4
         XHzBbKXuBfS9giKajTZxBzY8NAk7mwoeAlEEDkmeUtibSvtHXqOZhiWizmES3ALjPA
         v7TMSnqSzkP85ll6fdwxna/B+sPyCg8zAK8GhsUjIldsAqGiQeVS6LfT5zD/RzgVsA
         N2aI5MG11nyWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JK Kim <jongkang.kim2@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 30/52] nvme-pci: fix var. type for increasing cq_head
Date:   Mon,  5 Jul 2021 11:28:51 -0400
Message-Id: <20210705152913.1521036-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JK Kim <jongkang.kim2@gmail.com>

[ Upstream commit a0aac973a26d1ac814b9e131e209eb39472a67ce ]

nvmeq->cq_head is compared with nvmeq->q_depth and changed the value
and cq_phase for handling the next cq db.

but, nvmeq->q_depth's type is u32 and max. value is 0x10000 when
CQP.MSQE is 0xffff and io_queue_depth is 0x10000.

current temp. variable for comparing with nvmeq->q_depth is overflowed
when previous nvmeq->cq_head is 0xffff.

in this case, nvmeq->cq_phase is not updated.
so, fix data type for temp. variable to u32.

Signed-off-by: JK Kim <jongkang.kim2@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c92a15c3fbc5..4555e9202851 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1027,7 +1027,7 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 
 static inline void nvme_update_cq_head(struct nvme_queue *nvmeq)
 {
-	u16 tmp = nvmeq->cq_head + 1;
+	u32 tmp = nvmeq->cq_head + 1;
 
 	if (tmp == nvmeq->q_depth) {
 		nvmeq->cq_head = 0;
-- 
2.30.2

