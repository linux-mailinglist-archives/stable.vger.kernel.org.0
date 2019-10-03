Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BB1CA962
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392305AbfJCQl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392536AbfJCQl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC568215EA;
        Thu,  3 Oct 2019 16:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120918;
        bh=wHCe2eLqeBayLHrTaC81ulGiWcK3ZH12sxzE0bgkK5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcLCa0wX6wJrOFtumZu7r13dTwFLbsmGbF/nJ4nytrq46J5bKh82k7u4w5Ftv8Ruw
         VdcTYtEjViHG0fR6fjARtQUZaR8Bat8RA4AUZdtY2DhCtQQRbLuf4JcF0KKT0TxS0C
         p3tGS7c0XQx/ozStRd6bDHoDlmt70LdITKWLRzQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 086/344] md/raid1: end bio when the device faulty
Date:   Thu,  3 Oct 2019 17:50:51 +0200
Message-Id: <20191003154548.656243070@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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
index 34e26834ad28b..501a3b4d82f33 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -447,19 +447,21 @@ static void raid1_end_write_request(struct bio *bio)
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



