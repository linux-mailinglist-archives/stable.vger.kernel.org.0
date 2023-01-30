Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900B0681129
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbjA3OKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbjA3OKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:10:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38EE3BD86
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:10:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 668AFB811C7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F45C4339B;
        Mon, 30 Jan 2023 14:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087830;
        bh=e17R0PlGWdvc2mqCogeQNmUVuBVj2npH3qH/Zdq3t0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GhVkLYtHqeY/Slqa4GziqG6/cP1ducUCqeaXjwmEEt/JQIHC3MLx4W0+UxjPIehE
         ru3cEGvUMORzp6ODmZocWagFINd7GyirY8QWJPDCz+1HBLPM5FGgzT11WqrBqvEXt3
         DHZuPGvQT+vs0XOW5dzvqJ1FsTg5Q3RGbTeOXaOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/204] IB/hfi1: Fix expected receive setup error exit issues
Date:   Mon, 30 Jan 2023 14:49:48 +0100
Message-Id: <20230130134317.308716027@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit e0c4a422f5246abefbf7c178ef99a1f2dc3c5f62 ]

Fix three error exit issues in expected receive setup.
Re-arrange error exits to increase readability.

Issues and fixes:
1. Possible missed page unpin if tidlist copyout fails and
   not all pinned pages where made part of a TID.
   Fix: Unpin the unused pages.

2. Return success with unset return values tidcnt and length
   when no pages were pinned.
   Fix: Return -ENOSPC if no pages were pinned.

3. Return success with unset return values tidcnt and length when
   no rcvarray entries available.
   Fix: Return -ENOSPC if no rcvarray entries are available.

Fixes: 7e7a436ecb6e ("staging/hfi1: Add TID entry program function body")
Fixes: 97736f36dbeb ("IB/hfi1: Validate page aligned for a given virtual addres")
Fixes: f404ca4c7ea8 ("IB/hfi1: Refactor hfi_user_exp_rcv_setup() IOCTL")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167328548150.1472310.1492305874804187634.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 83 ++++++++++++++---------
 1 file changed, 50 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 236cfc560ab7..5b93a1aace9d 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -268,15 +268,14 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	tidbuf->psets = kcalloc(uctxt->expected_count, sizeof(*tidbuf->psets),
 				GFP_KERNEL);
 	if (!tidbuf->psets) {
-		kfree(tidbuf);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto fail_release_mem;
 	}
 
 	pinned = pin_rcv_pages(fd, tidbuf);
 	if (pinned <= 0) {
-		kfree(tidbuf->psets);
-		kfree(tidbuf);
-		return pinned;
+		ret = (pinned < 0) ? pinned : -ENOSPC;
+		goto fail_unpin;
 	}
 
 	/* Find sets of physically contiguous pages */
@@ -291,14 +290,16 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	fd->tid_used += pageset_count;
 	spin_unlock(&fd->tid_lock);
 
-	if (!pageset_count)
-		goto bail;
+	if (!pageset_count) {
+		ret = -ENOSPC;
+		goto fail_unreserve;
+	}
 
 	ngroups = pageset_count / dd->rcv_entries.group_size;
 	tidlist = kcalloc(pageset_count, sizeof(*tidlist), GFP_KERNEL);
 	if (!tidlist) {
 		ret = -ENOMEM;
-		goto nomem;
+		goto fail_unreserve;
 	}
 
 	tididx = 0;
@@ -394,44 +395,60 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	}
 unlock:
 	mutex_unlock(&uctxt->exp_mutex);
-nomem:
 	hfi1_cdbg(TID, "total mapped: tidpairs:%u pages:%u (%d)", tididx,
 		  mapped_pages, ret);
+
+	/* fail if nothing was programmed, set error if none provided */
+	if (tididx == 0) {
+		if (ret >= 0)
+			ret = -ENOSPC;
+		goto fail_unreserve;
+	}
+
 	/* adjust reserved tid_used to actual count */
 	spin_lock(&fd->tid_lock);
 	fd->tid_used -= pageset_count - tididx;
 	spin_unlock(&fd->tid_lock);
-	if (tididx) {
-		tinfo->tidcnt = tididx;
-		tinfo->length = mapped_pages * PAGE_SIZE;
 
-		if (copy_to_user(u64_to_user_ptr(tinfo->tidlist),
-				 tidlist, sizeof(tidlist[0]) * tididx)) {
-			/*
-			 * On failure to copy to the user level, we need to undo
-			 * everything done so far so we don't leak resources.
-			 */
-			tinfo->tidlist = (unsigned long)&tidlist;
-			hfi1_user_exp_rcv_clear(fd, tinfo);
-			tinfo->tidlist = 0;
-			ret = -EFAULT;
-			goto bail;
-		}
+	/* unpin all pages not covered by a TID */
+	unpin_rcv_pages(fd, tidbuf, NULL, mapped_pages, pinned - mapped_pages,
+			false);
+
+	tinfo->tidcnt = tididx;
+	tinfo->length = mapped_pages * PAGE_SIZE;
+
+	if (copy_to_user(u64_to_user_ptr(tinfo->tidlist),
+			 tidlist, sizeof(tidlist[0]) * tididx)) {
+		ret = -EFAULT;
+		goto fail_unprogram;
 	}
 
-	/*
-	 * If not everything was mapped (due to insufficient RcvArray entries,
-	 * for example), unpin all unmapped pages so we can pin them nex time.
-	 */
-	if (mapped_pages != pinned)
-		unpin_rcv_pages(fd, tidbuf, NULL, mapped_pages,
-				(pinned - mapped_pages), false);
-bail:
+	kfree(tidbuf->pages);
 	kfree(tidbuf->psets);
+	kfree(tidbuf);
 	kfree(tidlist);
+	return 0;
+
+fail_unprogram:
+	/* unprogram, unmap, and unpin all allocated TIDs */
+	tinfo->tidlist = (unsigned long)tidlist;
+	hfi1_user_exp_rcv_clear(fd, tinfo);
+	tinfo->tidlist = 0;
+	pinned = 0;		/* nothing left to unpin */
+	pageset_count = 0;	/* nothing left reserved */
+fail_unreserve:
+	spin_lock(&fd->tid_lock);
+	fd->tid_used -= pageset_count;
+	spin_unlock(&fd->tid_lock);
+fail_unpin:
+	if (pinned > 0)
+		unpin_rcv_pages(fd, tidbuf, NULL, 0, pinned, false);
+fail_release_mem:
 	kfree(tidbuf->pages);
+	kfree(tidbuf->psets);
 	kfree(tidbuf);
-	return ret > 0 ? 0 : ret;
+	kfree(tidlist);
+	return ret;
 }
 
 int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
-- 
2.39.0



