Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890576AF171
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCGSoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjCGSni (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:43:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F16A42EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB3EC61522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCABBC433EF;
        Tue,  7 Mar 2023 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213918;
        bh=4DD6UMs/Kp7C205tvqfOYPFXx1CLsiPgjKiJk5oWt64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2eV5m2lYzNAM96B76djscwOWIAEgUuZX5qpQoycbR+SCU12KHcekJ4zx1aKLg3nO6
         iglKG8Mo/NXZ4hDlEkE2lo5HOithMaAYRxYB06obWqJvnZJwB5Fo0eeQwlM8VOmrge
         1yKxpMJohJZLsmMdN8zNOQdgUvAw5J8A7z5+tUXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 661/885] io_uring: add reschedule point to handle_tw_list()
Date:   Tue,  7 Mar 2023 17:59:55 +0100
Message-Id: <20230307170030.875304017@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
@@ -1030,10 +1030,16 @@ static unsigned int handle_tw_list(struc
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


