Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62306AC13B
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjCFNdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjCFNdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:33:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66A52FCF8
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:32:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 565B7B80DA9
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7417C433EF;
        Mon,  6 Mar 2023 13:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678109568;
        bh=Y6a61qOyXnH/bwwfVayr8veh3AfwEFXXEWvyBi2dqfE=;
        h=Subject:To:Cc:From:Date:From;
        b=A4gX+57nglgYDsjJo/4PTAmBPiWS5Dm8Pxv1k7HTBaU7GKYNB0ngRToM+FkmVt+nV
         4V8WKBWnbMg2DKgDnyKvHVvOlNBNnoD5A1zTsvdkE8pC9l+CaXONhB40IF5yUwAaA7
         yo3SlOvmZCCwfz2+FIUF4VsqOvwcXsiXPgODu92E=
Subject: FAILED: patch "[PATCH] fs: dlm: start midcomms before scand" failed to apply to 5.4-stable tree
To:     aahringo@redhat.com, teigland@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 14:32:35 +0100
Message-ID: <167810955527215@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x aad633dc0cf90093998b1ae0ba9f19b5f1dab644
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167810955527215@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

aad633dc0cf9 ("fs: dlm: start midcomms before scand")
3e54c9e80e68 ("fs: dlm: fix log of lowcomms vs midcomms")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aad633dc0cf90093998b1ae0ba9f19b5f1dab644 Mon Sep 17 00:00:00 2001
From: Alexander Aring <aahringo@redhat.com>
Date: Thu, 12 Jan 2023 17:10:31 -0500
Subject: [PATCH] fs: dlm: start midcomms before scand

The scand kthread can send dlm messages out, especially dlm remove
messages to free memory for unused rsb on other nodes. To send out dlm
messages, midcomms must be initialized. This patch moves the midcomms
start before scand is started.

Cc: stable@vger.kernel.org
Fixes: e7fd41792fc0 ("[DLM] The core of the DLM for GFS2/CLVM")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index d0b4e2181a5f..99bc96f90779 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -381,23 +381,23 @@ static int threads_start(void)
 {
 	int error;
 
-	error = dlm_scand_start();
+	/* Thread for sending/receiving messages for all lockspace's */
+	error = dlm_midcomms_start();
 	if (error) {
-		log_print("cannot start dlm_scand thread %d", error);
+		log_print("cannot start dlm midcomms %d", error);
 		goto fail;
 	}
 
-	/* Thread for sending/receiving messages for all lockspace's */
-	error = dlm_midcomms_start();
+	error = dlm_scand_start();
 	if (error) {
-		log_print("cannot start dlm midcomms %d", error);
-		goto scand_fail;
+		log_print("cannot start dlm_scand thread %d", error);
+		goto midcomms_fail;
 	}
 
 	return 0;
 
- scand_fail:
-	dlm_scand_stop();
+ midcomms_fail:
+	dlm_midcomms_stop();
  fail:
 	return error;
 }

