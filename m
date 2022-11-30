Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017CD63DDE3
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiK3Sbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiK3Sba (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:31:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4AB8FD5A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:31:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DEA8B81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1717C433D6;
        Wed, 30 Nov 2022 18:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833086;
        bh=OcU0MPac6d5yZKIgdKzZsIpxGYHF4C7GSmH9rRMiAg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6rHeMPpje5idRv6LjHGjTPBhjPnq7f9eZ3eHjEy7KzLShi8lRBcwddWUfmZqRWbZ
         ddOSgCMrfkjc37RfHgwJwkvDVNJFhud7WabX8+gMDHkhrQqP5ZsYOAf/tW4d9S7a0v
         6vaut9LarJweDIzDO5FANAefUJuFwwanTAhwVuOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/162] dm integrity: flush the journal on suspend
Date:   Wed, 30 Nov 2022 19:23:47 +0100
Message-Id: <20221130180532.438621948@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
index 835b1f3464d0..847dfd682e20 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2470,10 +2470,6 @@ static void integrity_writer(struct work_struct *w)
 
 	unsigned prev_free_sectors;
 
-	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_post_suspending(ic->ti)) && !ic->meta_dev)
-		return;
-
 	spin_lock_irq(&ic->endio_wait.lock);
 	write_start = ic->committed_section;
 	write_sections = ic->n_committed_sections;
@@ -2980,8 +2976,7 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
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



