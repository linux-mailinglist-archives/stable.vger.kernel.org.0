Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142DB8D95C
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbfHNRHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbfHNRHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:07:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198172173E;
        Wed, 14 Aug 2019 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802462;
        bh=sGq5WL4OrlVm5sETWr0NMRgMXh1mIXO4iTxq/TmCj5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyVfW1YWP57GHIM8lCbCM4GBNSJFTY9GypWRF1hVps/ilJziJctfdxeceVsM4ExLk
         zb+jXXWfxZm+J9zSQjWAX863RWBROhsIX8K6QXXyAoAtVV7tFBsyrgShy5wsoVG4GF
         giIMjZxcz5WE3R0oaaUGLmdJPHz3Pw0EIl5aZ67A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 135/144] NFSv4: Check the return value of update_open_stateid()
Date:   Wed, 14 Aug 2019 19:01:31 +0200
Message-Id: <20190814165805.589869846@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit e3c8dc761ead061da2220ee8f8132f729ac3ddfe upstream.

Ensure that we always check the return value of update_open_stateid()
so that we can retry if the update of local state failed. This fixes
infinite looping on state recovery.

Fixes: e23008ec81ef3 ("NFSv4 reduce attribute requests for open reclaim")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v3.7+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1878,8 +1878,9 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
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
@@ -1944,8 +1945,11 @@ _nfs4_opendata_to_nfs4_state(struct nfs4
 
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


