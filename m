Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA7743A1E4
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhJYTnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237311AbhJYTkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:40:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16AAB6117A;
        Mon, 25 Oct 2021 19:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190564;
        bh=wSUNtwspCiBziGygOKz+u7vgx1HAmosmIvcke+ir+3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLAwU/kGwg0lzK1zYFkhcRjv8WM8NheYbQ1C61Qbtx450y4WY0xZrQlAv9iKktYbt
         mls92Z4uJQS838kiZpWqWyqzeS/DYvemfWo22KdCfJ9gjg8zSxbJmzxc60dQlFEcJ9
         6wuUZCdqakFRYBDzxYFurwQGJrdgHMSEf5qSIskg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 013/169] NFSD: Keep existing listeners on portlist error
Date:   Mon, 25 Oct 2021 21:13:14 +0200
Message-Id: <20211025191019.357343859@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit c20106944eb679fa3ab7e686fe5f6ba30fbc51e5 ]

If nfsd has existing listening sockets without any processes, then an error
returned from svc_create_xprt() for an additional transport will remove
those existing listeners.  We're seeing this in practice when userspace
attempts to create rpcrdma transports without having the rpcrdma modules
present before creating nfsd kernel processes.  Fix this by checking for
existing sockets before calling nfsd_destroy().

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 09ae1a0873d0..070e5dd03e26 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -793,7 +793,10 @@ out_close:
 		svc_xprt_put(xprt);
 	}
 out_err:
-	nfsd_destroy(net);
+	if (!list_empty(&nn->nfsd_serv->sv_permsocks))
+		nn->nfsd_serv->sv_nrthreads--;
+	 else
+		nfsd_destroy(net);
 	return err;
 }
 
-- 
2.33.0



