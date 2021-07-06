Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636653BCF68
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhGFL2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233939AbhGFL0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:26:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7966B61D58;
        Tue,  6 Jul 2021 11:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570392;
        bh=C7djTTCjYd0cKj88eqwliCRjLiPRX/To8ipnMZj28IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8DFE81zkZ//PukuJemB3fr9eLwcAFxpkpzYG01MHcOugFmem//1x6YBgqvric/rJ
         Y5TdZAnz7nlFHQ+Uj6H/jSkaVeGCd6DQbcOgfxUYPAheCZEvlvQBxeeEaJCj6kjCN2
         q+wxmPBU2ZYtd9LgVX1w+IEMIXV+kpwmStvpLdR+RmekMltVXRCsjo2r2RvqEZ2Ar6
         TnFqf+G/m0PKbjzAO5FCP+hgW8WPTNkPbambeLG8z6sJXVZ6IvZQcoaxpopKgT9Iqb
         wkrdgIoDrQ06U494iHtidnLwwWvH2HWGOAey1SaeBlMX2dfZhKXeqQ00m3mZAkyr1L
         rwNPqce5DFNgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 064/160] block: introduce BIO_ZONE_WRITE_LOCKED bio flag
Date:   Tue,  6 Jul 2021 07:16:50 -0400
Message-Id: <20210706111827.2060499-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit 9ffbbb435d8f566a0924ce4b5dc7fc1bceb6dbf8 ]

Introduce the BIO flag BIO_ZONE_WRITE_LOCKED to indicate that a BIO owns
the write lock of the zone it is targeting. This is the counterpart of
the struct request flag RQF_ZONE_WRITE_LOCKED.

This new BIO flag is reserved for now for zone write locking control
for device mapper targets exposing a zoned block device. Since in this
case, the lock flag must not be propagated to the struct request that
will be used to process the BIO, a BIO private flag is used rather than
changing the RQF_ZONE_WRITE_LOCKED request flag into a common REQ_XXX
flag that could be used for both BIO and request. This avoids conflicts
down the stack with the block IO scheduler zone write locking
(in mq-deadline).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blk_types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db026b6ec15a..e5cf12f102a2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -304,6 +304,7 @@ enum {
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
+	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
 	BIO_FLAG_LAST
 };
 
-- 
2.30.2

