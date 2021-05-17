Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4A9382FD8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhEQOVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239244AbhEQOTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:19:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5443961437;
        Mon, 17 May 2021 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260655;
        bh=9ASF4gVcBJXPb7XfbQrYiGoXvfdqXNUbPnqz4o2aze8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeicZ8CohZmbLMwdgH2QMsGBJkUUnsD7IcAODSk9AGG5VneNlhNaDl551B/NjtW9j
         VwtHHTfenuLoXKfeAkPS431oWfP9fu4NQFpyeAarfRtDhODgCuM4bBz/3kPbc7UB34
         dGHp7dZfz/rOOVZb/0ThXWvpmItU3tWeUOrZe0yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nagendra S Tomar <natomar@microsoft.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 145/363] nfs: Subsequent READDIR calls should carry non-zero cookieverifier
Date:   Mon, 17 May 2021 16:00:11 +0200
Message-Id: <20210517140307.521535544@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nagendra S Tomar <natomar@microsoft.com>

[ Upstream commit ee3707ae2c1f1327ad5188836b7ab62ed2c93b28 ]

If the loop in nfs_readdir_xdr_to_array() runs more than once, subsequent
READDIR RPCs may wrongly carry a zero cookie verifier and non-zero cookie.
Make sure subsequent calls to READDIR carry the cookie verifier returned
by the first call.

Signed-off-by: Nagendra S Tomar <natomar@microsoft.com>
Fixes: b593c09f83a2 ("NFS: Improve handling of directory verifiers")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index fc4f490f2d78..08a1e2e31d0b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -866,6 +866,8 @@ static int nfs_readdir_xdr_to_array(struct nfs_readdir_descriptor *desc,
 			break;
 		}
 
+		verf_arg = verf_res;
+
 		status = nfs_readdir_page_filler(desc, entry, pages, pglen,
 						 arrays, narrays);
 	} while (!status && nfs_readdir_page_needs_filling(page));
-- 
2.30.2



