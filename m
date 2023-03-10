Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64676B4636
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjCJOlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjCJOlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:41:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C66121B57
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:41:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F0C46187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C65C4339E;
        Fri, 10 Mar 2023 14:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459270;
        bh=VantBuzLmUQ5pSnDywrq4IwrOn0bxInJZQJxlZZnvM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWDmURamaN1Ss1ztVXi1HgrgPxgyiinrSRbieDeKCAV4acBpcWO/YR+uBKyZzHoKY
         4GlYjlCu3bkAuI6HmT0d0CVfYaIJM3yxPXkUZyRREU4lNU7eZFTRo/IA7HA45eDdcZ
         TZa1zq7M0RlP5+UAZUSnbojGjSZUZ38eWkva5Yks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 305/357] ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()
Date:   Fri, 10 Mar 2023 14:39:54 +0100
Message-Id: <20230310133748.153526554@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 7def041bbe484..585c5273b1fb5 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -879,8 +879,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
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
 
@@ -1110,14 +1113,18 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
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



