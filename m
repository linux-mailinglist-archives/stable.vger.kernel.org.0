Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8126F2474A3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392112AbgHQTMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730514AbgHQPkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:40:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F6A0207DA;
        Mon, 17 Aug 2020 15:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678834;
        bh=cNyIhF9xGuChpYRKI4UxdpDeXRQU1HRs8qXk0u2UPFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/hMtUwfybdowiNpskRpLM90qEtHbnaM03JPONb+r0G4OCaxu0nD9yW/4GtyluO2t
         bSXc+VVwlOvy0PM7x/PkjBTDWp+y9GcHlAOupELiwc0SBVcoq69P22ZRF4qy9oliFb
         s5vAkOImIa1rebG9YeZ7+EjGdTamusPPVjSUP2kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 457/464] s390/dasd: fix inability to use DASD with DIAG driver
Date:   Mon, 17 Aug 2020 17:16:50 +0200
Message-Id: <20200817143855.666222705@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 9f4aa52387c68049403b59939df5c0dd8e3872cc upstream.

During initialization of the DASD DIAG driver a request is issued
that has a bio structure that resides on the stack. With virtually
mapped kernel stacks this bio address might be in virtual storage
which is unsuitable for usage with the diag250 call.
In this case the device can not be set online using the DIAG
discipline and fails with -EOPNOTSUP.
In the system journal the following error message is presented:

dasd: X.X.XXXX Setting the DASD online with discipline DIAG failed
with rc=-95

Fix by allocating the bio structure instead of having it on the stack.

Fixes: ce3dc447493f ("s390: add support for virtually mapped kernel stacks")
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: stable@vger.kernel.org #4.20
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_diag.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -319,7 +319,7 @@ dasd_diag_check_device(struct dasd_devic
 	struct dasd_diag_characteristics *rdc_data;
 	struct vtoc_cms_label *label;
 	struct dasd_block *block;
-	struct dasd_diag_bio bio;
+	struct dasd_diag_bio *bio;
 	unsigned int sb, bsize;
 	blocknum_t end_block;
 	int rc;
@@ -395,29 +395,36 @@ dasd_diag_check_device(struct dasd_devic
 		rc = -ENOMEM;
 		goto out;
 	}
+	bio = kzalloc(sizeof(*bio), GFP_KERNEL);
+	if (bio == NULL)  {
+		DBF_DEV_EVENT(DBF_WARNING, device, "%s",
+			      "No memory to allocate initialization bio");
+		rc = -ENOMEM;
+		goto out_label;
+	}
 	rc = 0;
 	end_block = 0;
 	/* try all sizes - needed for ECKD devices */
 	for (bsize = 512; bsize <= PAGE_SIZE; bsize <<= 1) {
 		mdsk_init_io(device, bsize, 0, &end_block);
-		memset(&bio, 0, sizeof (struct dasd_diag_bio));
-		bio.type = MDSK_READ_REQ;
-		bio.block_number = private->pt_block + 1;
-		bio.buffer = label;
+		memset(bio, 0, sizeof(*bio));
+		bio->type = MDSK_READ_REQ;
+		bio->block_number = private->pt_block + 1;
+		bio->buffer = label;
 		memset(&private->iob, 0, sizeof (struct dasd_diag_rw_io));
 		private->iob.dev_nr = rdc_data->dev_nr;
 		private->iob.key = 0;
 		private->iob.flags = 0;	/* do synchronous io */
 		private->iob.block_count = 1;
 		private->iob.interrupt_params = 0;
-		private->iob.bio_list = &bio;
+		private->iob.bio_list = bio;
 		private->iob.flaga = DASD_DIAG_FLAGA_DEFAULT;
 		rc = dia250(&private->iob, RW_BIO);
 		if (rc == 3) {
 			pr_warn("%s: A 64-bit DIAG call failed\n",
 				dev_name(&device->cdev->dev));
 			rc = -EOPNOTSUPP;
-			goto out_label;
+			goto out_bio;
 		}
 		mdsk_term_io(device);
 		if (rc == 0)
@@ -427,7 +434,7 @@ dasd_diag_check_device(struct dasd_devic
 		pr_warn("%s: Accessing the DASD failed because of an incorrect format (rc=%d)\n",
 			dev_name(&device->cdev->dev), rc);
 		rc = -EIO;
-		goto out_label;
+		goto out_bio;
 	}
 	/* check for label block */
 	if (memcmp(label->label_id, DASD_DIAG_CMS1,
@@ -457,6 +464,8 @@ dasd_diag_check_device(struct dasd_devic
 			(rc == 4) ? ", read-only device" : "");
 		rc = 0;
 	}
+out_bio:
+	kfree(bio);
 out_label:
 	free_page((long) label);
 out:


