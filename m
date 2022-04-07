Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1894F7101
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbiDGBXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240390AbiDGBT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:19:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F24C1947A8;
        Wed,  6 Apr 2022 18:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3C21B81E7F;
        Thu,  7 Apr 2022 01:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9789C385A6;
        Thu,  7 Apr 2022 01:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294159;
        bh=bA07V3d5pxy3bq4FSeVjBX/PCVPBbT2rfgS9d+qm0vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzy3DpQKGsuUT7K6EupMBIBxtYbDkx+xZEUzdOIoNwPseCXc191HFfGegxdZ6HPIZ
         PuIag6w1QAKwxmMkPTf9bfCihKRHVGn7/ruFjb7NHkhyLuT6SyO1bjYy8HF6kFZ2BO
         nyiEh5UGaaWGk72a0n3NTQwI3yuRRlXCZ3INqsSdS+VM3M4CYyUAQGEi/zH1xoh/C5
         NWQ+5cHi0TcwSvPtSP34jhJJ9SridxwOXWERbImjrCmS68I9iqaFzoOcDLDdNrc+TW
         bbfRyzPJCOY8LLv2jSJNUaoGRpidUWpwZoMmfY6cZcj9a0gpn+ntYUCw0ntz/+sJbE
         y5D4EHv+Gg/Rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        christoph.boehmwalder@linbit.com, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/17] drbd: remove usage of list iterator variable after loop
Date:   Wed,  6 Apr 2022 21:15:17 -0400
Message-Id: <20220407011521.115014-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011521.115014-1-sashal@kernel.org>
References: <20220407011521.115014-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit 901aeda62efa21f2eae937bccb71b49ae531be06 ]

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer to iterate through the list [1].

Since that variable should not be used past the loop iteration, a
separate variable is used to 'remember the current location within the
loop'.

To either continue iterating from that position or skip the iteration
(if the previous iteration was complete) list_prepare_entry() is used.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220331220349.885126-1-jakobkoschel@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a18155cdce41..ba10fa24fa1f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -183,7 +183,7 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 		unsigned int set_size)
 {
 	struct drbd_request *r;
-	struct drbd_request *req = NULL;
+	struct drbd_request *req = NULL, *tmp = NULL;
 	int expect_epoch = 0;
 	int expect_size = 0;
 
@@ -237,8 +237,11 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 	 * to catch requests being barrier-acked "unexpectedly".
 	 * It usually should find the same req again, or some READ preceding it. */
 	list_for_each_entry(req, &connection->transfer_log, tl_requests)
-		if (req->epoch == expect_epoch)
+		if (req->epoch == expect_epoch) {
+			tmp = req;
 			break;
+		}
+	req = list_prepare_entry(tmp, &connection->transfer_log, tl_requests);
 	list_for_each_entry_safe_from(req, r, &connection->transfer_log, tl_requests) {
 		if (req->epoch != expect_epoch)
 			break;
-- 
2.35.1

