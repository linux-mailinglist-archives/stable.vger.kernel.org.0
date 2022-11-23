Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3632F635E27
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbiKWMz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238754AbiKWMx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:53:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4628E28D;
        Wed, 23 Nov 2022 04:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77ECF61CB2;
        Wed, 23 Nov 2022 12:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3220AC433D7;
        Wed, 23 Nov 2022 12:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207517;
        bh=x41sjMnTaJ8MCk3n+j5olFERM9m8rFoh606sq/BfygY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6+hOjow4zInYVWqTSOjY3bYuE5USrRnFp80/L3R5LrjDiaVlfG5rN1l4mw/k+m/V
         TGJS/ve8cFhDwnajTj9b1097eaEW63c3/oVMwn5nibRgC73n1fgIXeXX/QTiFM2a6g
         Sjzz5dh6sY906bEHcSmanHkGGCV6Pbbxz9eGTioLRbKLxfFBJFhZpDspByKumxEApG
         A9uDrK+7yr89OYzWSZmRSdWh+8nnoT/AJZOtNtcS64EoV5+24E0F/646J0hm21WDwI
         8c3Vk3pc1WQXzQdyCASZJAAaUFu84my8+nfLIDYn2Ya367rQEewH9qixvXVjbFqxxm
         fW+2YfsCpb2Cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 11/11] dm integrity: flush the journal on suspend
Date:   Wed, 23 Nov 2022 07:44:56 -0500
Message-Id: <20221123124458.266492-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124458.266492-1-sashal@kernel.org>
References: <20221123124458.266492-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 5e5dab5ec763d600fe0a67837dd9155bdc42f961 ]

This commit flushes the journal on suspend. It is prerequisite for the
next commit that enables activating dm integrity devices in read-only mode.

Note that we deliberately didn't flush the journal on suspend, so that the
journal replay code would be tested. However, the dm-integrity code is 5
years old now, so that journal replay is well-tested, and we can make this
change now.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 7492e6abb5a5..e36d4cc8fd9a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2116,10 +2116,6 @@ static void integrity_writer(struct work_struct *w)
 
 	unsigned prev_free_sectors;
 
-	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_post_suspending(ic->ti)) && !ic->meta_dev)
-		return;
-
 	spin_lock_irq(&ic->endio_wait.lock);
 	write_start = ic->committed_section;
 	write_sections = ic->n_committed_sections;
@@ -2455,8 +2451,7 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 	drain_workqueue(ic->commit_wq);
 
 	if (ic->mode == 'J') {
-		if (ic->meta_dev)
-			queue_work(ic->writer_wq, &ic->writer_work);
+		queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic, true);
 	}
-- 
2.35.1

