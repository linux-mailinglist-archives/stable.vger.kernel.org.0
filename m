Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110258D7EA
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfHNQUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:20:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52199 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbfHNQUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:20:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4D1EB22108;
        Wed, 14 Aug 2019 12:20:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 12:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vpB9fk
        mtDs/CeLkMFIk9pGAXShEW4ZzjRAqY5V9lyvM=; b=H8kPOlOhIPLDZFai9m5H28
        kVNaKY2ZT06TYoKaKl1UCRU1HB7qBQgeq8QzvEAsN3+32A3QvZzfZcEglHMnpLUV
        RirD0f6VaXxMskriaFJae4m1tOmn3+mbxXQo2NeaGHJHaDafnKz+l9EOGeAJFX58
        rG2jA0zk/nrX6dHLJeZ6afHE4TEx97Y3NluOnJkCOycWE7qDvjIt9H42s8OvEqAA
        /vvm8VvF79DEvhDl7FQl7pc/tUJZNnbrZVL3XAyHkHuSUG4+7LcSYTGbgVAqekfj
        on9gMc3aZrgP0/S+EnftQPH9hm298JXwQCKgs+TZNhxpjqENA+iM5L2bDTclhdxA
        ==
X-ME-Sender: <xms:sDRUXRH6iaz-pA49NF157IxSNCx-dhA6NmDOW68K69mQ0pQ6tBlbmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:sDRUXSqswXRAF0AT2RUy-xeJPGg4cqiG8EPjRqRRu9dnWEZrpkx1RQ>
    <xmx:sDRUXV4T2-iDbqeu755gnkDgdKEVfidJhCDkvZEE_NiyEofwpFAFOA>
    <xmx:sDRUXY5S6S-9FAVE99zTXd59LPJevc5eRzC6YwaAgmMyjRGhyVrBXw>
    <xmx:sDRUXd4L8xy9Vm8-RWgKbMaJz052G7bO1zJc5tMCngXn-1Xrg07MoA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4A08380076;
        Wed, 14 Aug 2019 12:19:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4: Check the return value of update_open_stateid()" failed to apply to 4.14-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Aug 2019 18:19:49 +0200
Message-ID: <156579958932137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

