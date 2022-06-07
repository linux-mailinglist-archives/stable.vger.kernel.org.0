Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B630D541D5F
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383646AbiFGWNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383959AbiFGWMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C6225A827;
        Tue,  7 Jun 2022 12:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2D5D61956;
        Tue,  7 Jun 2022 19:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B444CC385A2;
        Tue,  7 Jun 2022 19:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629552;
        bh=7z/LJZ+JUfk/CoOc11G3rJSu0+44RrtrKYssjymRpGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxrvjCEfky61S5wGXrSFy/zuNQHnzuMKkClXDg5ypuBnJDxI4d+1xPARz8SCExzt4
         P7srWfX+sPW1Lu0YDBx1ARLtuZax6AJ67NbT4KkaRDLM8AiBnJf333o7zKv/OzxtIB
         JwGQF8S/d5UlkTQlAZRcrqhhj9oV4j5c+ACWgxMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 733/879] bfq: Track whether bfq_group is still online
Date:   Tue,  7 Jun 2022 19:04:11 +0200
Message-Id: <20220607165024.133157498@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

commit 09f871868080c33992cd6a9b72a5ca49582578fa upstream.

Track whether bfq_group is still online. We cannot rely on
blkcg_gq->online because that gets cleared only after all policies are
offlined and we need something that gets updated already under
bfqd->lock when we are cleaning up our bfq_group to be able to guarantee
that when we see online bfq_group, it will stay online while we are
holding bfqd->lock lock.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-7-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-cgroup.c  |    3 ++-
 block/bfq-iosched.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_poli
 				   */
 	bfqg->bfqd = bfqd;
 	bfqg->active_entities = 0;
+	bfqg->online = true;
 	bfqg->rq_pos_tree = RB_ROOT;
 }
 
@@ -603,7 +604,6 @@ struct bfq_group *bfq_find_set_group(str
 	struct bfq_entity *entity;
 
 	bfqg = bfq_lookup_bfqg(bfqd, blkcg);
-
 	if (unlikely(!bfqg))
 		return NULL;
 
@@ -979,6 +979,7 @@ static void bfq_pd_offline(struct blkg_p
 
 put_async_queues:
 	bfq_put_async_queues(bfqd, bfqg);
+	bfqg->online = false;
 
 	spin_unlock_irqrestore(&bfqd->lock, flags);
 	/*
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -929,6 +929,8 @@ struct bfq_group {
 
 	/* reference counter (see comments in bfq_bic_update_cgroup) */
 	int ref;
+	/* Is bfq_group still online? */
+	bool online;
 
 	struct bfq_entity entity;
 	struct bfq_sched_data sched_data;


