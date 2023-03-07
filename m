Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC266AEBDE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjCGRtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjCGRtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:49:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36D39CBF1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4E2A61501
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5B2C433D2;
        Tue,  7 Mar 2023 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211047;
        bh=c9CyTiVATKApjeA+HLuDo6SYgSrQTzWUQZSCT6MGW5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=al6ajsW3NPt2t3xDJ5Pscu37r95Qvvax/XoBINubALT7bI/uKywKwdFBxU71hfO3o
         J5Qmi1hDCnD0Z3zJ4XZMLYiWMHfbauNROp4kBoTgMQRIGzQk82Vjbx1/+D62aPi46Y
         9aLqOh2NWjCP043GOrmB6mmyfOFln7GKlDEV/4b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0737/1001] dm cache: add cond_resched() to various workqueue loops
Date:   Tue,  7 Mar 2023 17:58:29 +0100
Message-Id: <20230307170053.703656746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 76227f6dc805e9e960128bcc6276647361e0827c ]

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5e92fac90b675..17fde3e5a1f7b 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1805,6 +1805,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1827,6 +1828,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1867,6 +1869,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
-- 
2.39.2



