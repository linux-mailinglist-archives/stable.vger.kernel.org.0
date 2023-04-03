Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB496D3F35
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjDCIkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjDCIkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:40:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C317D188
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D464B81132
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8889C433D2;
        Mon,  3 Apr 2023 08:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680511243;
        bh=g0uNF6221URQTK7Xf5X6YShz2tpswpnd7pk55ItG8k0=;
        h=Subject:To:Cc:From:Date:From;
        b=SBn4uJo4gKUwtGh1Qox1PkmY/IBI/nLz1z6I0RxTOeS6s4GS61KlwKyjcXFB68ONt
         civJnwoTkXBzShKtMw724Q/rnGq8KDooYxZdgNXQCDfmVDsPTQmOakV1HrbzzrFzL1
         A7z7cMq9/ZR5gkcBnF64MWO/MvHQBJgng9PSfPX4=
Subject: FAILED: patch "[PATCH] NFSv4: Fix hangs when recovering open state after a server" failed to apply to 4.19-stable tree
To:     trond.myklebust@hammerspace.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:40:40 +0200
Message-ID: <2023040340-bouncing-sampling-7639@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 6165a16a5ad9b237bb3131cff4d3c601ccb8f9a3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040340-bouncing-sampling-7639@gregkh' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

6165a16a5ad9 ("NFSv4: Fix hangs when recovering open state after a server reboot")
e3c8dc761ead ("NFSv4: Check the return value of update_open_stateid()")
ace9fad43aa6 ("NFSv4: Convert struct nfs4_state to use refcount_t")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6165a16a5ad9b237bb3131cff4d3c601ccb8f9a3 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Tue, 21 Mar 2023 00:17:36 -0400
Subject: [PATCH] NFSv4: Fix hangs when recovering open state after a server
 reboot

When we're using a cached open stateid or a delegation in order to avoid
sending a CLAIM_PREVIOUS open RPC call to the server, we don't have a
new open stateid to present to update_open_stateid().
Instead rely on nfs4_try_open_cached(), just as if we were doing a
normal open.

Fixes: d2bfda2e7aa0 ("NFSv4: don't reprocess cached open CLAIM_PREVIOUS")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 22a93ae46cd7..5607b1e2b821 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1980,8 +1980,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 	if (!data->rpc_done) {
 		if (data->rpc_status)
 			return ERR_PTR(data->rpc_status);
-		/* cached opens have already been processed */
-		goto update;
+		return nfs4_try_open_cached(data);
 	}
 
 	ret = nfs_refresh_inode(inode, &data->f_attr);
@@ -1990,7 +1989,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-update:
+
 	if (!update_open_stateid(state, &data->o_res.stateid,
 				NULL, data->o_arg.fmode))
 		return ERR_PTR(-EAGAIN);

