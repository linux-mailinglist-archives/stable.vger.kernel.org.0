Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53346157F1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiKBClx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiKBClx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:41:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80120209BA
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D322617AD
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCCEC433D6;
        Wed,  2 Nov 2022 02:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356911;
        bh=ime7V394A9516/yHZTYfO4wuZeZR/75YH89Zwvv9y84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7T1UKpY6SHLSa4+IjnzZfvBrw9+L1BlA0sFcy1EnD6ZSuuiJGgtLYsJPBKIlTfW7
         I0m+YlEF2r4OLYXjZ7vUuU8fZ69PCPZ1wBOd2p39OEEtGYq7sLvTQQf0t7LSNYR8Oz
         CbOk46yFn2B//1DtjJlAjHPOCHsz8Z+vLe7c72wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Loehle <cloehle@hyperstone.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 080/240] mmc: queue: Cancel recovery work on cleanup
Date:   Wed,  2 Nov 2022 03:30:55 +0100
Message-Id: <20221102022113.211124743@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Löhle <CLoehle@hyperstone.com>

commit 339e3eb1facd18a98ceb1171d70674780e5014a7 upstream.

To prevent any recovery work running after the queue cleanup cancel it.
Any recovery running post-cleanup dereferenced mq->card as NULL
and was not meaningful to begin with.

Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/c865c0c9789d428494b67b820a78923e@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/queue.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -493,6 +493,13 @@ void mmc_cleanup_queue(struct mmc_queue
 	if (blk_queue_quiesced(q))
 		blk_mq_unquiesce_queue(q);
 
+	/*
+	 * If the recovery completes the last (and only remaining) request in
+	 * the queue, and the card has been removed, we could end up here with
+	 * the recovery not quite finished yet, so cancel it.
+	 */
+	cancel_work_sync(&mq->recovery_work);
+
 	blk_mq_free_tag_set(&mq->tag_set);
 
 	/*


