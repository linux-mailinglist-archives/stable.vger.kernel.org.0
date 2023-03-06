Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69006AC13F
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjCFNd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjCFNdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:33:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EEB27D4A
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:33:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6930460F10
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CFAC433EF;
        Mon,  6 Mar 2023 13:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678109593;
        bh=XxDx8n6IzZlIFAfu5DAQzb9rCODObWLsku8co89NCkI=;
        h=Subject:To:Cc:From:Date:From;
        b=NLuLftykcQKNd2DBkzScOvzIzIULzZXAPno81G4/cPPN6K1Jse4Y9phFkIVdIAerg
         uewSD3zeFn/9+0CsPLZpp9X/LwJ6BVW/T/sEiLgNoGWybTpvGvJqLATXowfST1KTBg
         Xi7EGxg8V/aSbDoIaNgwCQFSy+osJYX/Ts01XGqU=
Subject: FAILED: patch "[PATCH] fs: dlm: be sure to call dlm_send_queue_flush()" failed to apply to 6.1-stable tree
To:     aahringo@redhat.com, teigland@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 14:33:11 +0100
Message-ID: <16781095911850@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 7354fa4ef697191effedc2ae9a8293427708bbf5
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781095911850@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

7354fa4ef697 ("fs: dlm: be sure to call dlm_send_queue_flush()")
775af207464b ("fs: dlm: use WARN_ON_ONCE() instead of WARN_ON()")
e01c4b7bd415 ("fd: dlm: trace send/recv of dlm message and rcom")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7354fa4ef697191effedc2ae9a8293427708bbf5 Mon Sep 17 00:00:00 2001
From: Alexander Aring <aahringo@redhat.com>
Date: Thu, 12 Jan 2023 17:10:33 -0500
Subject: [PATCH] fs: dlm: be sure to call dlm_send_queue_flush()

If we release a midcomms node structure, there should be nothing left
inside the dlm midcomms send queue. However, sometimes this is not true
because I believe some DLM_FIN message was not acked... if we run
into a shutdown timeout, then we should be sure there is no pending send
dlm message inside this queue when releasing midcomms node structure.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 2e60d9a2c883..a3eb19c8cec5 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1402,6 +1402,7 @@ static void midcomms_node_release(struct rcu_head *rcu)
 	struct midcomms_node *node = container_of(rcu, struct midcomms_node, rcu);
 
 	WARN_ON_ONCE(atomic_read(&node->send_queue_cnt));
+	dlm_send_queue_flush(node);
 	kfree(node);
 }
 

