Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910196E6367
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjDRMkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjDRMkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D48513872
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D66063303
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C58C433EF;
        Tue, 18 Apr 2023 12:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821619;
        bh=r/r8sib/28Ao+AVKtfPT1sUFZpo3yYoErKYPA7ot4S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gexPwHU0dCbAz/3zOGgdPKXD8uckkVj3ETxxKyFyzlVQHmWslNPEj0wNcnk6Ve/p3
         RDGj3n5W02vy6CB+b/xi6ahkOvb9yrBXdYO0pYeni1LMprO20Mqi1YtQASJJVJl8/6
         uLeLBRLiwLzMIJFbAK4QGZnb9dyCeqVtMT3JUFq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ZhaoLong Wang <wangzhaolong1@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 68/91] ubi: Fix deadlock caused by recursively holding work_sem
Date:   Tue, 18 Apr 2023 14:22:12 +0200
Message-Id: <20230418120307.929067994@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 2ee0e60c43c2e..4427018ad4d9b 100644
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
@@ -1121,7 +1121,7 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		int err1;
 
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, false);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, true);
 		if (err1) {
 			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
-- 
2.39.2



