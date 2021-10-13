Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED6042B1A4
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbhJMA71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237007AbhJMA6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EFAD61056;
        Wed, 13 Oct 2021 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086599;
        bh=VjaNcfH02mdoSQdBIynyX6Gk5hSK+nI3SbY4NNHjDcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvoEQRYuYjY+e5/iSN1voZfcD0IF8q+rYU6sR9xA/jdxttlBiHPklulT0j+rJqiQ+
         ODu3qk3ZqSARbRM8QIb/ivLYAoQHKY0C9ez7BJsvD7AoLEDy7udFqfQPCB1bQuS8JD
         wa51RKuys+e1YEOmauFQeWy7texGyBwSeGKnuwNB03lV5ooQTMIJa0dTHdyGIv7Elh
         FQ8tAqok8AHcwPpu8cZwS4SrRDehUb7EmlFsyFtPMwf7lgDCmTo8+wvimxklOh7Xbv
         Cor3Vpjk1x7tsz2Lppty3Oh1bK4x/gf6IRQJ9DCfTyisIP87MFcGOV4pFNRK/9QfMf
         Lp85i6KUNnj8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, bfields@fieldses.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/5] NFSD: Keep existing listeners on portlist error
Date:   Tue, 12 Oct 2021 20:56:30 -0400
Message-Id: <20211013005631.700631-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005631.700631-1-sashal@kernel.org>
References: <20211013005631.700631-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -788,7 +788,10 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net)
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

