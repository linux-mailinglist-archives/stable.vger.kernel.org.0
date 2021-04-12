Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B80A35BDC9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbhDLIyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238284AbhDLIv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:51:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40DEC6127B;
        Mon, 12 Apr 2021 08:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217473;
        bh=6+aRNBCFQWKWh+PdEciLR1R9ATN1N/W9+yByr8P9lU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqsxrKFfnFMWAOAI7L0rsb8/Vpqv9hsFR3va+dRjJQFzQ2I6MoaoxRvLaJj3/AfSs
         R68SzALV2LK2pMzXQqXAYipcyjH3fsHNKtdvk2RDRfFmdd2obUxy0z7FwvPsDOUxLG
         oi3/cWPzWHDO5ddU1a8Wf2nfLBDU3X/1M2W08R54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 021/188] LOOKUP_MOUNTPOINT: we are cleaning "jumped" flag too late
Date:   Mon, 12 Apr 2021 10:38:55 +0200
Message-Id: <20210412084014.358736084@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 4f0ed93fb92d3528c73c80317509df3f800a222b upstream.

That (and traversals in case of umount .) should be done before
complete_walk().  Either a braino or mismerge damage on queue
reorders - either way, I should've spotted that much earlier.

Fucked-up-by: Al Viro <viro@zeniv.linux.org.uk>
X-Paperbag: Brown
Fixes: 161aff1d93ab "LOOKUP_MOUNTPOINT: fold path_mountpointat() into path_lookupat()"
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2328,16 +2328,16 @@ static int path_lookupat(struct nameidat
 	while (!(err = link_path_walk(s, nd)) &&
 	       (s = lookup_last(nd)) != NULL)
 		;
+	if (!err && unlikely(nd->flags & LOOKUP_MOUNTPOINT)) {
+		err = handle_lookup_down(nd);
+		nd->flags &= ~LOOKUP_JUMPED; // no d_weak_revalidate(), please...
+	}
 	if (!err)
 		err = complete_walk(nd);
 
 	if (!err && nd->flags & LOOKUP_DIRECTORY)
 		if (!d_can_lookup(nd->path.dentry))
 			err = -ENOTDIR;
-	if (!err && unlikely(nd->flags & LOOKUP_MOUNTPOINT)) {
-		err = handle_lookup_down(nd);
-		nd->flags &= ~LOOKUP_JUMPED; // no d_weak_revalidate(), please...
-	}
 	if (!err) {
 		*path = nd->path;
 		nd->path.mnt = NULL;


