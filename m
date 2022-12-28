Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B08B657EB2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiL1P4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbiL1P4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:56:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2782644F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:56:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8694FB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61DBC433F1;
        Wed, 28 Dec 2022 15:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242982;
        bh=BBm+FXZcXc0LQpf3qvLlhqJJqR0w8aXAsxBE3rCarZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOAB3Pg9xISDJxokFbuR5U/x/gMZmIRMPuyA/ROWaN1j++c2rnm+tPFtqcO5EO7QE
         7H2zjqO10Ap3XE0hUkIyylfTJPorKIFC0uJqgLOP00wYsa6OBSG8k006V66wLrXugn
         4brGqXnhm6oowYM0l5g3VSLYZYPy4moWSfxP9Vlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ChenXiaoSong <chenxiaosong2@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0475/1073] NFSv4.x: Fail client initialisation if state manager thread cant run
Date:   Wed, 28 Dec 2022 15:34:23 +0100
Message-Id: <20221228144340.939773150@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b4e4f66901658fae0614dea5bf91062a5387eda7 ]

If the state manager thread fails to start, then we should just mark the
client initialisation as failed so that other processes or threads don't
get stuck in nfs_wait_client_init_complete().

Reported-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Fixes: 4697bd5e9419 ("NFSv4: Fix a race in the net namespace mount notification")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index a629d7db9420..0774355249c9 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1232,6 +1232,8 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 	if (IS_ERR(task)) {
 		printk(KERN_ERR "%s: kthread_run: %ld\n",
 			__func__, PTR_ERR(task));
+		if (!nfs_client_init_is_complete(clp))
+			nfs_mark_client_ready(clp, PTR_ERR(task));
 		nfs4_clear_state_manager_bit(clp);
 		clear_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state);
 		nfs_put_client(clp);
-- 
2.35.1



