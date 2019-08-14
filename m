Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB18D7E8
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfHNQUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:20:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47681 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbfHNQUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:20:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C919B2207F;
        Wed, 14 Aug 2019 12:19:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 12:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2l2qdY
        75PMZUHzWYeNbKTZuXjhTfiRvofFfswr4bfaM=; b=ZrZeKY48yu0Lr7T7+KjvVq
        Ek5QwSjTzu2M7f7jZE8annLRXX3wOLsA6skPNEb9EOgRsiVruOz6pslhztHvb3bM
        576yqjFtxUbK5g2dedgwo1t7Qm6/beeM9atvtcpvPtKnCUnj9+CMJsaE0L1+oY6g
        lrXdQWPiokCLz0cVqYkxWl0SSzsaUoqCKiA9Aw53Lb67c0uekgxvziejRBd89gw8
        3Bcv+7KngQiRlZp7w2lAhUo2jRKsz3im9zCT2RLFdzycHk/cH1Kgt5k884UM2cRw
        NTDTQ/9ZMCgwnl6r+X1/OTtj5gg2ctbGZDak18mQnmpdXAemoZM4Zv97nVCLGZOA
        ==
X-ME-Sender: <xms:rjRUXcGDSKv8r2moiviUE8slrKJTO83zvEka2hyyQlmSJDw7LDmEWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:rjRUXR5m919hZGrq0cDzHJ9qwRrANdSVnzgggbUrZpBI7a8_A6GvRw>
    <xmx:rjRUXamnY71tEKErZJ4QMtfMuQcHsjsVQVGELc00YHnppWJj8puRjw>
    <xmx:rjRUXU46UXo6PVbtBKcVnPvUsW6DItwPP_K9ZVaQxHT34KYfjsqsTg>
    <xmx:rjRUXbwaP-PkmhkLDLK0BQfKYX6wKwdvXpHpXvlmDFQulRQu5xTr7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C368380079;
        Wed, 14 Aug 2019 12:19:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4: Check the return value of update_open_stateid()" failed to apply to 4.4-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Aug 2019 18:19:48 +0200
Message-ID: <156579958817350@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e3c8dc761ead061da2220ee8f8132f729ac3ddfe Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Mon, 29 Jul 2019 18:25:00 +0100
Subject: [PATCH] NFSv4: Check the return value of update_open_stateid()

Ensure that we always check the return value of update_open_stateid()
so that we can retry if the update of local state failed. This fixes
infinite looping on state recovery.

Fixes: e23008ec81ef3 ("NFSv4 reduce attribute requests for open reclaim")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v3.7+

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c9e14ce0b7b2..3e0b93f2b61a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1915,8 +1915,9 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
 update:
-	update_open_stateid(state, &data->o_res.stateid, NULL,
-			    data->o_arg.fmode);
+	if (!update_open_stateid(state, &data->o_res.stateid,
+				NULL, data->o_arg.fmode))
+		return ERR_PTR(-EAGAIN);
 	refcount_inc(&state->count);
 
 	return state;
@@ -1981,8 +1982,11 @@ _nfs4_opendata_to_nfs4_state(struct nfs4_opendata *data)
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-	update_open_stateid(state, &data->o_res.stateid, NULL,
-			data->o_arg.fmode);
+	if (!update_open_stateid(state, &data->o_res.stateid,
+				NULL, data->o_arg.fmode)) {
+		nfs4_put_open_state(state);
+		state = ERR_PTR(-EAGAIN);
+	}
 out:
 	nfs_release_seqid(data->o_arg.seqid);
 	return state;

