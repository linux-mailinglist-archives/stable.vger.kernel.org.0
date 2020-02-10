Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169D9157B71
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbgBJNaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgBJMgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:16 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C67B21739;
        Mon, 10 Feb 2020 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338176;
        bh=mPkgDaFWCWXZFhzDRqH4H9L3lO2S1jfAHsihU0k28P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1wJo6cD9MWNd6oWTvV6EQ+rBYfzffR8O+QqaSG6EOZ0hYej3/VLjBbHdOMBqTHYe
         PUvzCROtVlu1wmNj9OcXYGCnhwOA6oXCPks6RhNgX33iZHfBX9Y6MsjNpmcpJu9DmY
         1tNd8jL1VSoExeFYO/sUnkFAWCNTVnQEOCQIJB2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.19 163/195] ubi: Fix an error pointer dereference in error handling code
Date:   Mon, 10 Feb 2020 04:33:41 -0800
Message-Id: <20200210122321.211825570@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5d3805af279c93ef49a64701f35254676d709622 upstream.

If "seen_pebs = init_seen(ubi);" fails then "seen_pebs" is an error pointer
and we try to kfree() it which results in an Oops.

This patch re-arranges the error handling so now it only frees things
which have been allocated successfully.

Fixes: daef3dd1f0ae ("UBI: Fastmap: Add self check to detect absent PEBs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/fastmap.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1146,7 +1146,7 @@ static int ubi_write_fastmap(struct ubi_
 	struct rb_node *tmp_rb;
 	int ret, i, j, free_peb_count, used_peb_count, vol_count;
 	int scrub_peb_count, erase_peb_count;
-	unsigned long *seen_pebs = NULL;
+	unsigned long *seen_pebs;
 
 	fm_raw = ubi->fm_buf;
 	memset(ubi->fm_buf, 0, ubi->fm_size);
@@ -1160,7 +1160,7 @@ static int ubi_write_fastmap(struct ubi_
 	dvbuf = new_fm_vbuf(ubi, UBI_FM_DATA_VOLUME_ID);
 	if (!dvbuf) {
 		ret = -ENOMEM;
-		goto out_kfree;
+		goto out_free_avbuf;
 	}
 
 	avhdr = ubi_get_vid_hdr(avbuf);
@@ -1169,7 +1169,7 @@ static int ubi_write_fastmap(struct ubi_
 	seen_pebs = init_seen(ubi);
 	if (IS_ERR(seen_pebs)) {
 		ret = PTR_ERR(seen_pebs);
-		goto out_kfree;
+		goto out_free_dvbuf;
 	}
 
 	spin_lock(&ubi->volumes_lock);
@@ -1337,7 +1337,7 @@ static int ubi_write_fastmap(struct ubi_
 	ret = ubi_io_write_vid_hdr(ubi, new_fm->e[0]->pnum, avbuf);
 	if (ret) {
 		ubi_err(ubi, "unable to write vid_hdr to fastmap SB!");
-		goto out_kfree;
+		goto out_free_seen;
 	}
 
 	for (i = 0; i < new_fm->used_blocks; i++) {
@@ -1359,7 +1359,7 @@ static int ubi_write_fastmap(struct ubi_
 		if (ret) {
 			ubi_err(ubi, "unable to write vid_hdr to PEB %i!",
 				new_fm->e[i]->pnum);
-			goto out_kfree;
+			goto out_free_seen;
 		}
 	}
 
@@ -1369,7 +1369,7 @@ static int ubi_write_fastmap(struct ubi_
 		if (ret) {
 			ubi_err(ubi, "unable to write fastmap to PEB %i!",
 				new_fm->e[i]->pnum);
-			goto out_kfree;
+			goto out_free_seen;
 		}
 	}
 
@@ -1379,10 +1379,13 @@ static int ubi_write_fastmap(struct ubi_
 	ret = self_check_seen(ubi, seen_pebs);
 	dbg_bld("fastmap written!");
 
-out_kfree:
-	ubi_free_vid_buf(avbuf);
-	ubi_free_vid_buf(dvbuf);
+out_free_seen:
 	free_seen(seen_pebs);
+out_free_dvbuf:
+	ubi_free_vid_buf(dvbuf);
+out_free_avbuf:
+	ubi_free_vid_buf(avbuf);
+
 out:
 	return ret;
 }


