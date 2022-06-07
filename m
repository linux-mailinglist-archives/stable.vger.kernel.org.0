Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F51541611
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357660AbiFGUpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376393AbiFGUnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:43:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44761F4294;
        Tue,  7 Jun 2022 11:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14475B8237B;
        Tue,  7 Jun 2022 18:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ED2C385A5;
        Tue,  7 Jun 2022 18:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627140;
        bh=u4cVDWE9ghJnWZVgnl39r4y8K2fhJNdkdYHrYy7ygyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7Kfw3WVxZvROb2RJXf40a1VEHDyHWShFTS81uO/MSg3GMIacrjUyltt533kQnHI+
         023mx0vw5Buwt27aYJu8YGLjVJraQ2oQyiJoGTn2b8LwgQiT72Ivl6iF+maonnvudG
         aYTZHwpblQDh/CsfBc0TIO1urELNbuUXQx0zun8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 631/772] bfq: Drop pointless unlock-lock pair
Date:   Tue,  7 Jun 2022 19:03:43 +0200
Message-Id: <20220607165007.529775825@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit fc84e1f941b91221092da5b3102ec82da24c5673 upstream.

In bfq_insert_request() we unlock bfqd->lock only to call
trace_block_rq_insert() and then lock bfqd->lock again. This is really
pointless since tracing is disabled if we really care about performance
and even if the tracepoint is enabled, it is a quick call.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-5-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6154,11 +6154,8 @@ static void bfq_insert_request(struct bl
 		return;
 	}
 
-	spin_unlock_irq(&bfqd->lock);
-
 	trace_block_rq_insert(rq);
 
-	spin_lock_irq(&bfqd->lock);
 	bfqq = bfq_init_rq(rq);
 	if (!bfqq || at_head) {
 		if (at_head)


