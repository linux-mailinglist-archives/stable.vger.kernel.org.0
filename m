Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFDE30C564
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbhBBQVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:21:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234264AbhBBOPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:15:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C04364FBA;
        Tue,  2 Feb 2021 13:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274029;
        bh=/VSBTtvKp3Wlh5wo50bwzjsOFjIlsBsJ9rKh7bds5eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZiKWnVaOXK6wNwfEShzyfPc783XzBCIzhk78oVG+ufI2ZrPuRJM8EszLokXQEYdJ
         NFDS7W0vcWRhj6jn40AdcJQCcYdKm42uRjf4T/jjbsfeAyu8o/zoOLRLAafkEozREw
         EyH+rJwzrhKA8I9WVKyvDxbS/z9eKjmwi/HJNEYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/37] pNFS/NFSv4: Fix a layout segment leak in pnfs_layout_process()
Date:   Tue,  2 Feb 2021 14:39:08 +0100
Message-Id: <20210202132943.970175405@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 814b84971388cd5fb182f2e914265b3827758455 ]

If the server returns a new stateid that does not match the one in our
cache, then pnfs_layout_process() will leak the layout segments returned
by pnfs_mark_layout_stateid_invalid().

Fixes: 9888d837f3cf ("pNFS: Force a retry of LAYOUTGET if the stateid doesn't match our cache")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 46ca5592b8b0d..4b165aa5a2561 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2320,6 +2320,7 @@ out_forget:
 	spin_unlock(&ino->i_lock);
 	lseg->pls_layout = lo;
 	NFS_SERVER(ino)->pnfs_curr_ld->free_lseg(lseg);
+	pnfs_free_lseg_list(&free_me);
 	return ERR_PTR(-EAGAIN);
 }
 
-- 
2.27.0



