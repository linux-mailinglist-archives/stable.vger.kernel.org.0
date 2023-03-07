Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37EA6AEF51
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjCGSWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjCGSW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:22:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708E8AB0A3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:16:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29109B8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25C8C433D2;
        Tue,  7 Mar 2023 18:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212996;
        bh=EdOzRtcSoY1Tehpc7bujpp4Ho9/AhaQoy1ltzSBRkVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzW+u4AzbAQ5mbkk5/wpm6uGtbB4amzv+1S8rsRe71+gcd58B3PGm2UujbWRwQmJw
         ieKFmKCXj7FYukGB72ZYkT64BJEb3fLemHPTi+rr1OBSXfLbmvgHHXg+oms6Tl1ZMY
         oiMd96nnA3aD9SI8rwgqRlB3sl3yUI3P1KPY+dM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Olga Kornievskaia <aglo@umich.edu>,
        NeilBrown <neilb@suse.de>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 364/885] NFS: fix disabling of swap
Date:   Tue,  7 Mar 2023 17:54:58 +0100
Message-Id: <20230307170018.105895626@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 5bab56fff53ce161ed859d9559a10361d4f79578 ]

When swap is activated to a file on an NFSv4 mount we arrange that the
state manager thread is always present as starting a new thread requires
memory allocations that might block waiting for swap.

Unfortunately the code for allowing the state manager thread to exit when
swap is disabled was not tested properly and does not work.
This can be seen by examining /proc/fs/nfsfs/servers after disabling swap
and unmounting the filesystem.  The servers file will still list one
entry.  Also a "ps" listing will show the state manager thread is still
present.

There are two problems.
 1/ rpc_clnt_swap_deactivate() doesn't walk up the ->cl_parent list to
    find the primary client on which the state manager runs.

 2/ The thread is not woken up properly and it immediately goes back to
    sleep without checking whether it is really needed.  Using
    nfs4_schedule_state_manager() ensures a proper wake-up.

Reported-by: Olga Kornievskaia <aglo@umich.edu>
Fixes: 4dc73c679114 ("NFSv4: keep state manager thread active if swap is enabled")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 net/sunrpc/clnt.c | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e51044a5f550f..d70da78e698d2 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10609,7 +10609,9 @@ static void nfs4_disable_swap(struct inode *inode)
 	/* The state manager thread will now exit once it is
 	 * woken.
 	 */
-	wake_up_var(&NFS_SERVER(inode)->nfs_client->cl_state);
+	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
+
+	nfs4_schedule_state_manager(clp);
 }
 
 static const struct inode_operations nfs4_dir_inode_operations = {
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 0b0b9f1eed469..fd7e1c630493e 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -3350,6 +3350,8 @@ rpc_clnt_swap_deactivate_callback(struct rpc_clnt *clnt,
 void
 rpc_clnt_swap_deactivate(struct rpc_clnt *clnt)
 {
+	while (clnt != clnt->cl_parent)
+		clnt = clnt->cl_parent;
 	if (atomic_dec_if_positive(&clnt->cl_swapper) == 0)
 		rpc_clnt_iterate_for_each_xprt(clnt,
 				rpc_clnt_swap_deactivate_callback, NULL);
-- 
2.39.2



