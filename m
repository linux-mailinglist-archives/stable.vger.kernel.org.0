Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78FC6AC147
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjCFNeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjCFNeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:34:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF299034
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:33:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FAF660F38
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B66C433D2;
        Mon,  6 Mar 2023 13:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678109617;
        bh=ZNOwLH9Jnbiu9DIJunl4ekGWSybsQ4VYCNkDGy/WbeA=;
        h=Subject:To:Cc:From:Date:From;
        b=ynHlBImeSTMUV5ahWrPiBNzaPjU9kguuSJMr2O3fak+GwuhybihuwFzorDPbDjgBB
         /ZvOtbjRx2myp/U7rh5r2Qqu7P7ybRGFiRWiPh8rcu4rEwN5QrwjTbKQLx21ox1WQQ
         YuxS9cTWXbL2jTNTEDwMW/2f3Jy+rjiMQSq4xUw4=
Subject: FAILED: patch "[PATCH] fs: dlm: fix race setting stop tx flag" failed to apply to 5.15-stable tree
To:     aahringo@redhat.com, teigland@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 14:33:27 +0100
Message-ID: <16781096071167@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 164272113b685927126c938b4a9cbd2075eb15ee
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781096071167@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

164272113b68 ("fs: dlm: fix race setting stop tx flag")
e01c4b7bd415 ("fd: dlm: trace send/recv of dlm message and rcom")
00e99ccde757 ("dlm: use __le types for dlm messages")
2f9dbeda8dc0 ("dlm: use __le types for rcom messages")
3428785a65da ("dlm: use __le types for dlm header")
a8449f232ee3 ("dlm: add __CHECKER__ for false positives")
6c2e3bf68f3e ("fs: dlm: filter user dlm messages for kernel locks")
9af5b8f0ead7 ("fs: dlm: add debugfs rawmsg send functionality")
92732376fd29 ("fs: dlm: trace socket handling")
f1d3b8f91d96 ("fs: dlm: initial support for tracepoints")

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

