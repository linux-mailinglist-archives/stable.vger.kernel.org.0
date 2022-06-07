Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A12540F60
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353260AbiFGTGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353759AbiFGTDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:03:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCB1158F23;
        Tue,  7 Jun 2022 11:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C211617A5;
        Tue,  7 Jun 2022 18:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AF7C385A5;
        Tue,  7 Jun 2022 18:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625117;
        bh=yj/Ml6jb/VyjxhYDwDi7OwOl8HHnQ0Jn+d0s9xCWTnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUYTGXQKPZZB/HgxgoXaJFre4yG3BrKufPGU6SVAQ5h8H13JBZ9ECDjusAGcESyTg
         VIsoS8wTl0IpgtC+xnHMZMTo2tUqn4YlgQ529W1P+/1XEBYDsy8k1pJzYIBuF/s+iE
         z7+iVM6hS5Cyq0qSlEPhtm8KjUY7/krx+urLWyp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 531/667] bfq: Avoid false marking of bic as stably merged
Date:   Tue,  7 Jun 2022 19:03:16 +0200
Message-Id: <20220607164950.628242842@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

commit 70456e5210f40ffdb8f6d905acfdcec5bd5fad9e upstream.

bfq_setup_cooperator() can mark bic as stably merged even though it
decides to not merge its bfqqs (when bfq_setup_merge() returns NULL).
Make sure to mark bic as stably merged only if we are really going to
merge bfqqs.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Fixes: 430a67f9d616 ("block, bfq: merge bursts of newly-created queues")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2773,9 +2773,12 @@ bfq_setup_cooperator(struct bfq_data *bf
 				struct bfq_queue *new_bfqq =
 					bfq_setup_merge(bfqq, stable_merge_bfqq);
 
-				bic->stably_merged = true;
-				if (new_bfqq && new_bfqq->bic)
-					new_bfqq->bic->stably_merged = true;
+				if (new_bfqq) {
+					bic->stably_merged = true;
+					if (new_bfqq->bic)
+						new_bfqq->bic->stably_merged =
+									true;
+				}
 				return new_bfqq;
 			} else
 				return NULL;


