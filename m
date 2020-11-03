Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942DC2A583E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgKCVuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731505AbgKCUtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74F3F22404;
        Tue,  3 Nov 2020 20:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436555;
        bh=LksYnwxBV3OsfR5XLdj/F6NQQ21zfgNFiyrvwsplcts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0Ab4uYS9TEfPk3ehw7Y/4Uia5JdLitDwQnUoZtcQIcHeg+4vj9oEwUFxCyQljsTi
         anLd9zFC/h5IgbC+z3GmDI7SAyThaZ9279V5U6sKvMmXWWrIew8phxWtx1siZxhp4O
         DZEjZYp9MJH0ALjtCnVsrzgyANofG9IYnwu95BVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+128f4dd6e796c98b3760@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.9 264/391] udf: Fix memory leak when mounting
Date:   Tue,  3 Nov 2020 21:35:15 +0100
Message-Id: <20201103203404.836857503@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit a7be300de800e755714c71103ae4a0d205e41e99 upstream.

udf_process_sequence() allocates temporary array for processing
partition descriptors on volume which it fails to free. Free the array
when it is not needed anymore.

Fixes: 7b78fd02fb19 ("udf: Fix handling of Partition Descriptors")
CC: stable@vger.kernel.org
Reported-by: syzbot+128f4dd6e796c98b3760@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/super.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1704,7 +1704,8 @@ static noinline int udf_process_sequence
 					"Pointers (max %u supported)\n",
 					UDF_MAX_TD_NESTING);
 				brelse(bh);
-				return -EIO;
+				ret = -EIO;
+				goto out;
 			}
 
 			vdp = (struct volDescPtr *)bh->b_data;
@@ -1724,7 +1725,8 @@ static noinline int udf_process_sequence
 			curr = get_volume_descriptor_record(ident, bh, &data);
 			if (IS_ERR(curr)) {
 				brelse(bh);
-				return PTR_ERR(curr);
+				ret = PTR_ERR(curr);
+				goto out;
 			}
 			/* Descriptor we don't care about? */
 			if (!curr)
@@ -1746,28 +1748,31 @@ static noinline int udf_process_sequence
 	 */
 	if (!data.vds[VDS_POS_PRIMARY_VOL_DESC].block) {
 		udf_err(sb, "Primary Volume Descriptor not found!\n");
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out;
 	}
 	ret = udf_load_pvoldesc(sb, data.vds[VDS_POS_PRIMARY_VOL_DESC].block);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	if (data.vds[VDS_POS_LOGICAL_VOL_DESC].block) {
 		ret = udf_load_logicalvol(sb,
 				data.vds[VDS_POS_LOGICAL_VOL_DESC].block,
 				fileset);
 		if (ret < 0)
-			return ret;
+			goto out;
 	}
 
 	/* Now handle prevailing Partition Descriptors */
 	for (i = 0; i < data.num_part_descs; i++) {
 		ret = udf_load_partdesc(sb, data.part_descs_loc[i].rec.block);
 		if (ret < 0)
-			return ret;
+			goto out;
 	}
-
-	return 0;
+	ret = 0;
+out:
+	kfree(data.part_descs_loc);
+	return ret;
 }
 
 /*


