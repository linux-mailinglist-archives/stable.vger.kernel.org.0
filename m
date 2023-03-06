Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7DE6AC145
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCFNeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjCFNeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:34:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01232B603
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:33:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B1BE60B3C
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BA8C433EF;
        Mon,  6 Mar 2023 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678109609;
        bh=964n477nY49/GWHdoamtARi5M5r6WZ0GHyTFO7siwmk=;
        h=Subject:To:Cc:From:Date:From;
        b=oQZ0VNXK7fU3EhBEHMWpyG8Tno8gm51xa+zt1vQ9d6RgK839GKgl8iosLwKBwXVBI
         J0bKOKjIY4N0kUAc400urpJGPh4K+aaPoDC1IUJxtzIsOcsJHBNCgu/Gnu5rfvG45e
         BHDZIEg3wBj9OkFlXZt2XjfTh0ptYtfwZv5ImpLo=
Subject: FAILED: patch "[PATCH] fs: dlm: fix race setting stop tx flag" failed to apply to 6.1-stable tree
To:     aahringo@redhat.com, teigland@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 14:33:26 +0100
Message-ID: <167810960625226@kroah.com>
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
git cherry-pick -x 164272113b685927126c938b4a9cbd2075eb15ee
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167810960625226@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

164272113b68 ("fs: dlm: fix race setting stop tx flag")
e01c4b7bd415 ("fd: dlm: trace send/recv of dlm message and rcom")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 164272113b685927126c938b4a9cbd2075eb15ee Mon Sep 17 00:00:00 2001
From: Alexander Aring <aahringo@redhat.com>
Date: Thu, 12 Jan 2023 17:10:34 -0500
Subject: [PATCH] fs: dlm: fix race setting stop tx flag

This patch sets the stop tx flag before we commit the dlm message.
This flag will report about unexpected transmissions after we
send the DLM_FIN message out, which should be the last message sent.
When we commit the dlm fin message, it could be that we already
got an ack back and the CLOSED state change already happened.
We should not set this flag when we are in CLOSED state. To avoid this
race we simply set the tx flag before the state change can be in
progress by moving it before dlm_midcomms_commit_mhandle().

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index a3eb19c8cec5..9d459d5bf800 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -406,6 +406,7 @@ static int dlm_send_fin(struct midcomms_node *node,
 	if (!mh)
 		return -ENOMEM;
 
+	set_bit(DLM_NODE_FLAG_STOP_TX, &node->flags);
 	mh->ack_rcv = ack_rcv;
 
 	m_header = (struct dlm_header *)ppc;
@@ -417,7 +418,6 @@ static int dlm_send_fin(struct midcomms_node *node,
 
 	pr_debug("sending fin msg to node %d\n", node->nodeid);
 	dlm_midcomms_commit_mhandle(mh, NULL, 0);
-	set_bit(DLM_NODE_FLAG_STOP_TX, &node->flags);
 
 	return 0;
 }

