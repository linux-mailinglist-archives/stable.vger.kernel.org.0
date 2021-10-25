Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAAA439F5C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhJYTTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234560AbhJYTTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873C06109D;
        Mon, 25 Oct 2021 19:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189407;
        bh=2m52lPcU04Cfpr0G+VzlsskUrt5DmVz7JfmNt7GObeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaE/2G0J3RFPfo73R3G/WAQPShYzCetk2pe/PexIIswXBMZJDtrPvRXmrb489yR5+
         q9ap2PT2pYbjT/P3YrKpQilT4AlkSU9EYnxRaarS9njUuyKVk2Rc2MduNMI8Di4s1b
         yigpIeTqI4nvlZTu3mCfMij3kc1MQSKWc1OkY4LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 23/44] NFSD: Keep existing listeners on portlist error
Date:   Mon, 25 Oct 2021 21:14:04 +0200
Message-Id: <20211025190933.377493895@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
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
index 0cd57db5c5af..dfd1949b31ea 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -768,7 +768,10 @@ out_close:
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



