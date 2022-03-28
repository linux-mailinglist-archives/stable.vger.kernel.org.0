Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D63E4EA062
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343832AbiC1Trj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343838AbiC1Tqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:46:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB5A68FAE;
        Mon, 28 Mar 2022 12:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F39A6128E;
        Mon, 28 Mar 2022 19:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13602C340F0;
        Mon, 28 Mar 2022 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496592;
        bh=WUIYG6thePESUcULHT5I4qjXkkRS99F3jg0XOg3HOro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdQrv8Lt5ZMjsBWq6CzQFZ5fWuLw+N5Pr6SWczSpro0NztYsJoEvgxrKhrekndwCp
         L74UYOj8s0gTk2ECt+/XMqkxDgPp/2OHhVqIY7TC3m589JsIoS2YQIqme+stR0wGLI
         q/PB5gcjDj5wQVU2T6mxeouvDf5roWJ8bT2Fb2GxFzGAkmpXT+B/biFnZxiW6vGn3J
         FAe2NtgNFOz0d2veiwzd36pKMJYdkXh8U9LKUseCh8Rvrp8wnVYq7fWlvZODq11OCQ
         nD8Xl2CIOPdrEvCseiruf0c6XcH6ljzulgYK9ZV3MtyLkW54ldubsWF0MT4w2qR3ax
         sASMPBe71zEjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>, Dai Ngo <dai.ngo@oracle.com>,
        Sasha Levin <sashal@kernel.org>, bfields@fieldses.org,
        jlayton@poochiereds.net, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/16] NFSD: Fix nfsd_breaker_owns_lease() return values
Date:   Mon, 28 Mar 2022 15:42:52 -0400
Message-Id: <20220328194300.1586178-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194300.1586178-1-sashal@kernel.org>
References: <20220328194300.1586178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 50719bf3442dd6cd05159e9c98d020b3919ce978 ]

These have been incorrect since the function was introduced.

A proper kerneldoc comment is added since this function, though
static, is part of an external interface.

Reported-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index db4a47a280dc..181bc3d9f566 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4693,6 +4693,14 @@ nfsd_break_deleg_cb(struct file_lock *fl)
 	return ret;
 }
 
+/**
+ * nfsd_breaker_owns_lease - Check if lease conflict was resolved
+ * @fl: Lock state to check
+ *
+ * Return values:
+ *   %true: Lease conflict was resolved
+ *   %false: Lease conflict was not resolved.
+ */
 static bool nfsd_breaker_owns_lease(struct file_lock *fl)
 {
 	struct nfs4_delegation *dl = fl->fl_owner;
@@ -4700,11 +4708,11 @@ static bool nfsd_breaker_owns_lease(struct file_lock *fl)
 	struct nfs4_client *clp;
 
 	if (!i_am_nfsd())
-		return NULL;
+		return false;
 	rqst = kthread_data(current);
 	/* Note rq_prog == NFS_ACL_PROGRAM is also possible: */
 	if (rqst->rq_prog != NFS_PROGRAM || rqst->rq_vers < 4)
-		return NULL;
+		return false;
 	clp = *(rqst->rq_lease_breaker);
 	return dl->dl_stid.sc_client == clp;
 }
-- 
2.34.1

