Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03510419CC3
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbhI0RcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237110AbhI0RaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31948611C0;
        Mon, 27 Sep 2021 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763091;
        bh=cWf6s3w5KufPS3NvTgxGdIoyfoTRIo+gHNVhlZgTZa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OasreuGj+Hg43jDtjqem3u0qJKPFhOe+xl+M/ZvXb0nry+Q+aX41YVIQosW8ViEQj
         LKwcSwq4KBSorWJZZAig8gMSZA77lHZTPpAbFrrqbm0aspDlmXOt8HkAZV6ZtxGzst
         //kiOB+x8inKeki1wlBt95TgO5dLenrLKE/u3A+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lihong Kou <koulihong@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 132/162] block: check if a profile is actually registered in blk_integrity_unregister
Date:   Mon, 27 Sep 2021 19:02:58 +0200
Message-Id: <20210927170238.000521907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 783a40a1b3ac7f3714d2776fa8ac8cce3535e4f6 ]

While clearing the profile itself is harmless, we really should not clear
the stable writes flag if it wasn't set due to a registered integrity
profile.

Reported-by: Lihong Kou <koulihong@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Link: https://lore.kernel.org/r/20210914070657.87677-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 410da060d1f5..e9f943de377a 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -426,8 +426,12 @@ EXPORT_SYMBOL(blk_integrity_register);
  */
 void blk_integrity_unregister(struct gendisk *disk)
 {
+	struct blk_integrity *bi = &disk->queue->integrity;
+
+	if (!bi->profile)
+		return;
 	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
-	memset(&disk->queue->integrity, 0, sizeof(struct blk_integrity));
+	memset(bi, 0, sizeof(*bi));
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
 
-- 
2.33.0



