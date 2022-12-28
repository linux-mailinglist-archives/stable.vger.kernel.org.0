Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EED7657A1F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiL1PIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiL1PIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A44013D78
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB9CD61365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07709C433D2;
        Wed, 28 Dec 2022 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240081;
        bh=ukYNZBw1xN0wkq+ZdjV59v4CzgFnHjLv/DBZ72R39VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQxsbguKuVsV5iRU3G/m/rQnB3HhFse6VD5a7Y0vGjaMlsY143Tvi7bKh9Y+E3389
         Na0BunodrYrxnwCwdNpuDdgHJSqe70e9FFXJJeaF0GpLTCt8j1PbZkFKhLN9YAlb/Y
         zlOWSWeHXcPbtcXEUXO81pS+7+a+U2Kj5qZpOiKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luis Chamberlain <mcgrof@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/731] memstick: ms_block: Add error handling support for add_disk()
Date:   Wed, 28 Dec 2022 15:36:54 +0100
Message-Id: <20221228144305.473211614@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 2304c55fd506fcd5e1a59ae21a306ee82507340b ]

We never checked for errors on add_disk() as this function returned void.
Now that this is fixed, use the shiny new error handling.

Contrary to the typical removal which delays the put_disk() until later,
since we are failing on a probe we immediately put the disk on failure from
add_disk by using blk_cleanup_disk().

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210902174105.2418771-3-mcgrof@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 4f431a047a5c ("memstick/ms_block: Add check for alloc_ordered_workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/ms_block.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index f854822f84d6..29a69243cbd0 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2157,10 +2157,14 @@ static int msb_init_disk(struct memstick_dev *card)
 		set_disk_ro(msb->disk, 1);
 
 	msb_start(card);
-	device_add_disk(&card->dev, msb->disk, NULL);
+	rc = device_add_disk(&card->dev, msb->disk, NULL);
+	if (rc)
+		goto out_cleanup_disk;
 	dbg("Disk added");
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(msb->disk);
 out_free_tag_set:
 	blk_mq_free_tag_set(&msb->tag_set);
 out_release_id:
-- 
2.35.1



