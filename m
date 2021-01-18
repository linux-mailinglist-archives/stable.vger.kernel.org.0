Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245FA2FA274
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391511AbhARM07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390839AbhARLpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9BB222D6E;
        Mon, 18 Jan 2021 11:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970314;
        bh=nseZlXizndgKaAlUroqqvRt/tyv4CkSRgIyY2dO2hFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dego0VFxyxfLOlp8dVTvveywtdf8LK2HpBIu5NZOF6HYAjZRicNp+HHtWnT33iomX
         HWqzlhrJFRQkXnD5KkaCHF9qNh+iM/dIqLngvEU5j93PoHtb2nGor9CQjBw7i+kNlY
         ABfTvJzJSs2xRi5weqqo4bDBMv8jy2yHlvSfddB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 127/152] NFS/pNFS: Dont leak DS commits in pnfs_generic_retry_commit()
Date:   Mon, 18 Jan 2021 12:35:02 +0100
Message-Id: <20210118113358.813015897@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 46c9ea1d4fee4cf1f8cc6001b9c14aae61b3d502 upstream.

We must ensure that we pass a layout segment to nfs_retry_commit() when
we're cleaning up after pnfs_bucket_alloc_ds_commits(). Otherwise,
requests that should be committed to the DS will get committed to the
MDS.
Do so by ensuring that pnfs_bucket_get_committing() always tries to
return a layout segment when it returns a non-empty page list.

Fixes: c84bea59449a ("NFS/pNFS: Simplify bucket layout segment reference counting")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs_nfs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -403,12 +403,16 @@ pnfs_bucket_get_committing(struct list_h
 			   struct pnfs_commit_bucket *bucket,
 			   struct nfs_commit_info *cinfo)
 {
+	struct pnfs_layout_segment *lseg;
 	struct list_head *pos;
 
 	list_for_each(pos, &bucket->committing)
 		cinfo->ds->ncommitting--;
 	list_splice_init(&bucket->committing, head);
-	return pnfs_free_bucket_lseg(bucket);
+	lseg = pnfs_free_bucket_lseg(bucket);
+	if (!lseg)
+		lseg = pnfs_get_lseg(bucket->lseg);
+	return lseg;
 }
 
 static struct nfs_commit_data *
@@ -420,8 +424,6 @@ pnfs_bucket_fetch_commitdata(struct pnfs
 	if (!data)
 		return NULL;
 	data->lseg = pnfs_bucket_get_committing(&data->pages, bucket, cinfo);
-	if (!data->lseg)
-		data->lseg = pnfs_get_lseg(bucket->lseg);
 	return data;
 }
 


