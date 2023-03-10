Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B15C6B42C0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjCJOGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbjCJOGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:06:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE62D136FA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 369CC618B8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D416C433EF;
        Fri, 10 Mar 2023 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457160;
        bh=90SnIkXiXLtPgScPIiujRElaF67OYzpDYWxkuwAPR5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSi/SnWn3SCPdx/qU/iQY97yZQHtM0sRIi+G4vLYV56HBUCGN1A1T4HzBqe+6/AB/
         rxKPq2jjnjuTKriyVJqXnKgYXj7R5xOib9X3OC1nLwbApv/6KiY4S5OmO4VaJNAjXc
         Cfcbi7uVUpWUNQQK0MaCQvd6Hb0kpn/UBUMBKE+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/200] ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()
Date:   Fri, 10 Mar 2023 14:37:28 +0100
Message-Id: <20230310133718.331798865@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

[ Upstream commit a240bc5c43130c6aa50831d7caaa02a1d84e1bce ]

Wear-leveling entry could be freed in error path, which may be accessed
again in eraseblk_count_seq_show(), for example:

__erase_worker                eraseblk_count_seq_show
                                wl = ubi->lookuptbl[*block_number]
				if (wl)
  wl_entry_destroy
    ubi->lookuptbl[e->pnum] = NULL
    kmem_cache_free(ubi_wl_entry_slab, e)
		                   erase_count = wl->ec  // UAF!

Wear-leveling entry updating/accessing in ubi->lookuptbl should be
protected by ubi->wl_lock, fix it by adding ubi->wl_lock to serialize
wl entry accessing between wl_entry_destroy() and
eraseblk_count_seq_show().

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216305
Fixes: 7bccd12d27b7e3 ("ubi: Add debugfs file for tracking PEB state")
Fixes: 801c135ce73d5d ("UBI: Unsorted Block Images")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/wl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 68eb0f21b3fe2..f45df3b773739 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -890,8 +890,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 	err = do_sync_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
-		if (e2)
+		if (e2) {
+			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e2);
+			spin_unlock(&ubi->wl_lock);
+		}
 		goto out_ro;
 	}
 
@@ -1130,14 +1133,18 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		/* Re-schedule the LEB for erasure */
 		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, false);
 		if (err1) {
+			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
+			spin_unlock(&ubi->wl_lock);
 			err = err1;
 			goto out_ro;
 		}
 		return err;
 	}
 
+	spin_lock(&ubi->wl_lock);
 	wl_entry_destroy(ubi, e);
+	spin_unlock(&ubi->wl_lock);
 	if (err != -EIO)
 		/*
 		 * If this is not %-EIO, we have no idea what to do. Scheduling
-- 
2.39.2



