Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35319439FE5
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhJYTZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231723AbhJYTXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:23:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CDA6103C;
        Mon, 25 Oct 2021 19:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189681;
        bh=h3OshlrKzJ5LZMoAMLCu5XevmATvo6gO6WSAgy4xjgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/Obw4lo17yStG2hnkp9EcE1cfMG4+CJRxWz1+Sy4RRnw0/oBD+F1BCqcbOvRG714
         c01MQTuSqBkwlz4ge4MSpxmUyNMlScVei4d2DCaDh0g7qvAqKmn3mK6hD3K/30GzS/
         0bHtYHtdW8S0cqvuWB1RWSvpe/MCU7EXg1+ZO0wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/30] NFSD: Keep existing listeners on portlist error
Date:   Mon, 25 Oct 2021 21:14:25 +0200
Message-Id: <20211025190924.259563061@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
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
index d44402241d9e..50465ee502c7 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -788,7 +788,10 @@ out_close:
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



