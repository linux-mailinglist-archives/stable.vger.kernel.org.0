Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686394525E6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345129AbhKPB74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239891AbhKOSIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:08:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EB1633B0;
        Mon, 15 Nov 2021 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998376;
        bh=9/vGCjDKh0FtxxuDvYqCS9oR8L1aHwnLR2f8pWJbRPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naUK8NHhtPJc0MqPSNyL+9DE95DBZGRxAgoed7kOQDxxoTPuqdXQ4zcpvtzd1/BIe
         JjVToHns0taJzRBfuy0Iu6zfDIc8X0FznWBEl0OQAGv2httdU82W59lolHWt6aoRUL
         bA1vQm3nAKHPPIi6RG28Ob7iKENxaFWoQrB+pJSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 487/575] Fix user namespace leak
Date:   Mon, 15 Nov 2021 18:03:32 +0100
Message-Id: <20211115165400.543918534@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit d5f458a979650e5ed37212f6134e4ee2b28cb6ed ]

Fixes: 61ca2c4afd9d ("NFS: Only reference user namespace from nfs4idmap struct instead of cred")
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4idmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
index 8d8aba305ecca..f331866dd4182 100644
--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -487,7 +487,7 @@ nfs_idmap_new(struct nfs_client *clp)
 err_destroy_pipe:
 	rpc_destroy_pipe_data(idmap->idmap_pipe);
 err:
-	get_user_ns(idmap->user_ns);
+	put_user_ns(idmap->user_ns);
 	kfree(idmap);
 	return error;
 }
-- 
2.33.0



