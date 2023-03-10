Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984506B4166
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjCJNwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCJNwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:52:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD71115664
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD4AA618A8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F09C433EF;
        Fri, 10 Mar 2023 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456343;
        bh=PxEU8ji8uNOd9HYk4pDPCv/Cw91MlqoJG09RlzuEelI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3yx1e5q1JB81VHxAR7Ry9qX1MC5xSi4HxQE5p0AR0ggw4bX0i3ozKWpeFZWvK0R7
         CqSu4ehd//Q6l5QqYkIq8RRJtSW8Bq/a+JrF6bNm5xIXp+SKtodbQ0sz2Z5dwQ92Vt
         RAnpYObrMNo/cdKI4MPIzK3KzDZ4eU8XfVtwzq/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 163/193] ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed
Date:   Fri, 10 Mar 2023 14:39:05 +0100
Message-Id: <20230310133716.581777427@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 4d57a7333e26040f2b583983e1970d9d460e56b0 ]

Following process will trigger an infinite loop in ubi_wl_put_peb():

	ubifs_bgt		ubi_bgt
ubifs_leb_unmap
  ubi_leb_unmap
    ubi_eba_unmap_leb
      ubi_wl_put_peb	wear_leveling_worker
                          e1 = rb_entry(rb_first(&ubi->used)
			  e2 = get_peb_for_wl(ubi)
			  ubi_io_read_vid_hdr  // return err (flash fault)
			  out_error:
			    ubi->move_from = ubi->move_to = NULL
			    wl_entry_destroy(ubi, e1)
			      ubi->lookuptbl[e->pnum] = NULL
      retry:
        e = ubi->lookuptbl[pnum];	// return NULL
	if (e == ubi->move_from) {	// NULL == NULL gets true
	  goto retry;			// infinite loop !!!

$ top
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     COMMAND
  7676 root     20   0       0      0      0 R 100.0  0.0  ubifs_bgt0_0

Fix it by:
 1) Letting ubi_wl_put_peb() returns directly if wearl leveling entry has
    been removed from 'ubi->lookuptbl'.
 2) Using 'ubi->wl_lock' protecting wl entry deletion to preventing an
    use-after-free problem for wl entry in ubi_wl_put_peb().

Fetch a reproducer in [Link].

Fixes: 43f9b25a9cdd7b1 ("UBI: bugfix: protect from volume removal")
Fixes: ee59ba8b064f692 ("UBI: Fix stale pointers in ubi->lookuptbl")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216111
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/wl.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index e267e0519d94a..4411ce5d1c8fc 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -964,11 +964,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	spin_lock(&ubi->wl_lock);
 	ubi->move_from = ubi->move_to = NULL;
 	ubi->move_to_put = ubi->wl_scheduled = 0;
+	wl_entry_destroy(ubi, e1);
+	wl_entry_destroy(ubi, e2);
 	spin_unlock(&ubi->wl_lock);
 
 	ubi_free_vid_buf(vidb);
-	wl_entry_destroy(ubi, e1);
-	wl_entry_destroy(ubi, e2);
 
 out_ro:
 	ubi_ro_mode(ubi);
@@ -1233,6 +1233,18 @@ int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 retry:
 	spin_lock(&ubi->wl_lock);
 	e = ubi->lookuptbl[pnum];
+	if (!e) {
+		/*
+		 * This wl entry has been removed for some errors by other
+		 * process (eg. wear leveling worker), corresponding process
+		 * (except __erase_worker, which cannot concurrent with
+		 * ubi_wl_put_peb) will set ubi ro_mode at the same time,
+		 * just ignore this wl entry.
+		 */
+		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_protect);
+		return 0;
+	}
 	if (e == ubi->move_from) {
 		/*
 		 * User is putting the physical eraseblock which was selected to
-- 
2.39.2



