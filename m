Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA993CACF1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbfJCRcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732267AbfJCQJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:09:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ECEC21A4C;
        Thu,  3 Oct 2019 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118969;
        bh=/mKR2Aj0YnNxM7Y42TKtxzacGVHLJvIRIb7cpYpcFKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwQyGrh3xvu/eWzkEocJU1pFkRr+bGw61JqXWlm/vOHF+wlWG7R2GcuOoxvAYGR1O
         3SRFTy9jFOPTh1LkIaWBnMlEBaxt+M6CpS9flkwPYo7N+71Mdkl7imUTh59VJHkvnC
         K88GowJDx+GrgdtMfD9iLwuOeYH1CdTp0sGBq4zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/185] md/raid1: end bio when the device faulty
Date:   Thu,  3 Oct 2019 17:52:34 +0200
Message-Id: <20191003154454.599749140@linuxfoundation.org>
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

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit eeba6809d8d58908b5ed1b5ceb5fcb09a98a7cad ]

When write bio return error, it would be added to conf->retry_list
and wait for raid1d thread to retry write and acknowledge badblocks.

In narrow_write_error(), the error bio will be split in the unit of
badblock shift (such as one sector) and raid1d thread issues them
one by one. Until all of the splited bio has finished, raid1d thread
can go on processing other things, which is time consuming.

But, there is a scene for error handling that is not necessary.
When the device has been set faulty, flush_bio_list() may end
bios in pending_bio_list with error status. Since these bios
has not been issued to the device actually, error handlding to
retry write and acknowledge badblocks make no sense.

Even without that scene, when the device is faulty, badblocks info
can not be written out to the device. Thus, we also no need to
handle the error IO.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 31c4391f6a62b..762d21c84774a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -435,19 +435,21 @@ static void raid1_end_write_request(struct bio *bio)
 		    /* We never try FailFast to WriteMostly devices */
 		    !test_bit(WriteMostly, &rdev->flags)) {
 			md_error(r1_bio->mddev, rdev);
-			if (!test_bit(Faulty, &rdev->flags))
-				/* This is the only remaining device,
-				 * We need to retry the write without
-				 * FailFast
-				 */
-				set_bit(R1BIO_WriteError, &r1_bio->state);
-			else {
-				/* Finished with this branch */
-				r1_bio->bios[mirror] = NULL;
-				to_put = bio;
-			}
-		} else
+		}
+
+		/*
+		 * When the device is faulty, it is not necessary to
+		 * handle write error.
+		 * For failfast, this is the only remaining device,
+		 * We need to retry the write without FailFast.
+		 */
+		if (!test_bit(Faulty, &rdev->flags))
 			set_bit(R1BIO_WriteError, &r1_bio->state);
+		else {
+			/* Finished with this branch */
+			r1_bio->bios[mirror] = NULL;
+			to_put = bio;
+		}
 	} else {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that we
-- 
2.20.1



