Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA6FCA33B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388403AbfJCQNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388398AbfJCQNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E108621A4C;
        Thu,  3 Oct 2019 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119217;
        bh=Is2ZghF4pScJ0Qc5jlZLN3T8yEWLs1UROC01YDkaX04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=se71QoT1K6lASI5ytcQPfeIh2TJONyGpGKAn6N5cjwFyt1MLl1UPtEA6+42xoQ/jx
         q1RQ4EcUUwdqEQP6cKJzMpFIQpuJieREGjX0QREcuHjti47Q3EjPyr0DmwnkgSmndc
         jU/7YChwHhSgucozbXuRzEeQY2L8H6Ix0kdLhUmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nigel Croxon <ncroxon@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 130/185] raid5: dont increment read_errors on EILSEQ return
Date:   Thu,  3 Oct 2019 17:53:28 +0200
Message-Id: <20191003154507.040387345@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nigel Croxon <ncroxon@redhat.com>

[ Upstream commit b76b4715eba0d0ed574f58918b29c1b2f0fa37a8 ]

While MD continues to count read errors returned by the lower layer.
If those errors are -EILSEQ, instead of -EIO, it should NOT increase
the read_errors count.

When RAID6 is set up on dm-integrity target that detects massive
corruption, the leg will be ejected from the array.  Even if the
issue is correctable with a sector re-write and the array has
necessary redundancy to correct it.

The leg is ejected because it runs up the rdev->read_errors beyond
conf->max_nr_stripes.  The return status in dm-drypt when there is
a data integrity error is -EILSEQ (BLK_STS_PROTECTION).

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cc0bd528136db..9f2059e185f7f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2538,7 +2538,8 @@ static void raid5_end_read_request(struct bio * bi)
 		int set_bad = 0;
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
-		atomic_inc(&rdev->read_errors);
+		if (!(bi->bi_status == BLK_STS_PROTECTION))
+			atomic_inc(&rdev->read_errors);
 		if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
 			pr_warn_ratelimited(
 				"md/raid:%s: read error on replacement device (sector %llu on %s).\n",
-- 
2.20.1



