Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BB22E408B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441497AbgL1ORp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441493AbgL1ORp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 222A5229C5;
        Mon, 28 Dec 2020 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165024;
        bh=/qWz2VcDO/m3AyVrool8a3Qv4KL9VqTD27TO2E0UiVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0q6iJzVOYWF8xLT+UYZtJA1xSp7FXTxq8LdFBIJpjHu54dymgPc7C4yJDbcTtxbC
         VYQ3//hBFH4uvytVdfBK5KTgOTaeAokF586WPdMsU2xZyBLk2JUB1mbZbwykp4KpLt
         eCDYhFjD+xPvauSfd5YoOi4+rIQ/1oizBKrfDPs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 376/717] NFSD: Fix 5 seconds delay when doing inter server copy
Date:   Mon, 28 Dec 2020 13:46:14 +0100
Message-Id: <20201228125039.023665528@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit ca9364dde50daba93eff711b4b945fd08beafcc2 ]

Since commit b4868b44c5628 ("NFSv4: Wait for stateid updates after
CLOSE/OPEN_DOWNGRADE"), every inter server copy operation suffers 5
seconds delay regardless of the size of the copy. The delay is from
nfs_set_open_stateid_locked when the check by nfs_stateid_is_sequential
fails because the seqid in both nfs4_state and nfs4_stateid are 0.

Fix by modifying nfs4_init_cp_state to return the stateid with seqid 1
instead of 0. This is also to conform with section 4.8 of RFC 7862.

Here is the relevant paragraph from section 4.8 of RFC 7862:

   A copy offload stateid's seqid MUST NOT be zero.  In the context of a
   copy offload operation, it is inappropriate to indicate "the most
   recent copy offload operation" using a stateid with a seqid of zero
   (see Section 8.2.2 of [RFC5661]).  It is inappropriate because the
   stateid refers to internal state in the server and there may be
   several asynchronous COPY operations being performed in parallel on
   the same file by the server.  Therefore, a copy offload stateid with
   a seqid of zero MUST be considered invalid.

Fixes: ce0887ac96d3 ("NFSD add nfs4 inter ssc to nfsd4_copy")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d7f27ed6b7941..47006eec724e6 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -769,6 +769,7 @@ static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
 	spin_lock(&nn->s2s_cp_lock);
 	new_id = idr_alloc_cyclic(&nn->s2s_cp_stateids, stid, 0, 0, GFP_NOWAIT);
 	stid->stid.si_opaque.so_id = new_id;
+	stid->stid.si_generation = 1;
 	spin_unlock(&nn->s2s_cp_lock);
 	idr_preload_end();
 	if (new_id < 0)
-- 
2.27.0



