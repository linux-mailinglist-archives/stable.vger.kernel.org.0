Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C967593F6A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346031AbiHOV23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348329AbiHOV1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:27:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A354EA324;
        Mon, 15 Aug 2022 12:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3187DB81062;
        Mon, 15 Aug 2022 19:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824B1C433D6;
        Mon, 15 Aug 2022 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591387;
        bh=zUlcBjt3sYFgyUmwRf5ZWSN61dwFobVQH7Z7LAAaPPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajCrbkyCkebLitKvF2uIQwhymYfOHHnSgWP9prmWan0oesT3sZMgWTCqbECl3EK1R
         6PfiPMO+YBMyh2C1XZknbfVO0cNJ9CPS+GUrvzzK9gr7AP6n53iYEsexiLJJwF2ZdA
         +pfV9AIH9LJe8rl6xKXWr0QBd0K1thDj4iPHStf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0563/1095] mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release
Date:   Mon, 15 Aug 2022 19:59:22 +0200
Message-Id: <20220815180452.858633452@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit a61528d997619a518ee8c51cf0ef0513021afaff ]

There is a deadlock between sm_release and sm_cache_flush_work
which is a work item. The cancel_work_sync in sm_release will
not return until sm_cache_flush_work is finished. If we hold
mutex_lock and use cancel_work_sync to wait the work item to
finish, the work item also requires mutex_lock. As a result,
the sm_release will be blocked forever. The race condition is
shown below:

    (Thread 1)             |   (Thread 2)
sm_release                 |
  mutex_lock(&ftl->mutex)  | sm_cache_flush_work
                           |   mutex_lock(&ftl->mutex)
  cancel_work_sync         |   ...

This patch moves del_timer_sync and cancel_work_sync out of
mutex_lock in order to mitigate deadlock.

Fixes: 7d17c02a01a1 ("mtd: Add new SmartMedia/xD FTL")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220524044841.10517-1-duoming@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/sm_ftl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
index 0cff2cda1b5a..7f955fade838 100644
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -1111,9 +1111,9 @@ static void sm_release(struct mtd_blktrans_dev *dev)
 {
 	struct sm_ftl *ftl = dev->priv;
 
-	mutex_lock(&ftl->mutex);
 	del_timer_sync(&ftl->timer);
 	cancel_work_sync(&ftl->flush_work);
+	mutex_lock(&ftl->mutex);
 	sm_cache_flush(ftl);
 	mutex_unlock(&ftl->mutex);
 }
-- 
2.35.1



