Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA96AEC11
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjCGRv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjCGRvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC4DA2F19
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D06BB819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD8DC433EF;
        Tue,  7 Mar 2023 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211169;
        bh=4pf5IBGyLue0wQb/eNIEYnSoxwNh2FO7mEpvofoi6/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rycr5sC+Vh2vwTYa7r4Id+Eqj4Q7c7fO6SFQgqpqjrC/q4KnlhWaWs5gTIUQqOR1v
         d2CAMnY55z/+mAFKskSh9lSz0bpiG1k9B0C3hYf6OzDegZ4WX0CERG3plYvGEzjfOF
         1AkVjhpgFRdhKzkah+YbTC5B9V4471H2vyoBSUO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0758/1001] io_uring: add reschedule point to handle_tw_list()
Date:   Tue,  7 Mar 2023 17:58:50 +0100
Message-Id: <20230307170054.624974474@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit f58680085478dd292435727210122960d38e8014 upstream.

If CONFIG_PREEMPT_NONE is set and the task_work chains are long, we
could be running into issues blocking others for too long. Add a
reschedule check in handle_tw_list(), and flush the ctx if we need to
reschedule.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1143,10 +1143,16 @@ static unsigned int handle_tw_list(struc
 			/* if not contended, grab and improve batching */
 			*locked = mutex_trylock(&(*ctx)->uring_lock);
 			percpu_ref_get(&(*ctx)->refs);
-		}
+		} else if (!*locked)
+			*locked = mutex_trylock(&(*ctx)->uring_lock);
 		req->io_task_work.func(req, locked);
 		node = next;
 		count++;
+		if (unlikely(need_resched())) {
+			ctx_flush_and_put(*ctx, locked);
+			*ctx = NULL;
+			cond_resched();
+		}
 	}
 
 	return count;


