Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC866E642A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjDRMql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjDRMql (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:46:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A397914F65
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32C65633A5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E8BC433D2;
        Tue, 18 Apr 2023 12:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821998;
        bh=fr6YlN6fzrhqVkz8M+pyvwLkHR5JnN7/wVxrh7KEPNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIH3MA+USZP9rdMzyDzO6ygXhYltMtUlH3/PvDfn1BEn0InWnoEgWRkAfAaW/yi44
         NUYydh5E2i+3P3Vow8NvtYivl5EDXsMaJFGRj8aVyCO1sfInlhwwuKYXPnLZyGg5GC
         v1Umt7iR+7qv4+gF225BNor0AB8iDldotLB8V48s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ZhaoLong Wang <wangzhaolong1@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/134] ubi: Fix deadlock caused by recursively holding work_sem
Date:   Tue, 18 Apr 2023 14:22:55 +0200
Message-Id: <20230418120317.335384020@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhaoLong Wang <wangzhaolong1@huawei.com>

[ Upstream commit f773f0a331d6c41733b17bebbc1b6cae12e016f5 ]

During the processing of the bgt, if the sync_erase() return -EBUSY
or some other error code in __erase_worker(),schedule_erase() called
again lead to the down_read(ubi->work_sem) hold twice and may get
block by down_write(ubi->work_sem) in ubi_update_fastmap(),
which cause deadlock.

          ubi bgt                        other task
 do_work
  down_read(&ubi->work_sem)          ubi_update_fastmap
  erase_worker                         # Blocked by down_read
   __erase_worker                      down_write(&ubi->work_sem)
    schedule_erase
     schedule_ubi_work
      down_read(&ubi->work_sem)

Fix this by changing input parameter @nested of the schedule_erase() to
'true' to avoid recursively acquiring the down_read(&ubi->work_sem).

Also, fix the incorrect comment about @nested parameter of the
schedule_erase() because when down_write(ubi->work_sem) is held, the
@nested is also need be true.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217093
Fixes: 2e8f08deabbc ("ubi: Fix races around ubi_refill_pools()")
Signed-off-by: ZhaoLong Wang <wangzhaolong1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/wl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 9e14319225c97..6049ab9e46479 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -575,7 +575,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
  * @vol_id: the volume ID that last used this PEB
  * @lnum: the last used logical eraseblock number for the PEB
  * @torture: if the physical eraseblock has to be tortured
- * @nested: denotes whether the work_sem is already held in read mode
+ * @nested: denotes whether the work_sem is already held
  *
  * This function returns zero in case of success and a %-ENOMEM in case of
  * failure.
@@ -1131,7 +1131,7 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		int err1;
 
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, false);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, true);
 		if (err1) {
 			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
-- 
2.39.2



