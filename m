Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A9A1D838F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbgERSFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733042AbgERSFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 418FE207D3;
        Mon, 18 May 2020 18:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825152;
        bh=kOd0bcbUg8fHPHC0USq6DxLSQK0hSCY2zfafB+/Tfwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGZlOH/pKz7UhuZDNt4QVuGFA0dnwq37KvJeYuWY0IKxbxTc296qQMNt+5Rv1SRZV
         o/3/rathz59NcvhJ6gV2gX12fBukXVqqzejOX0AqnaEj+WIM3iQF+OfDHpe/bm0Y/K
         Pln3DetEUzaHinqQqAHbTK8iA8s+KzESc0fgAM2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 123/194] NFSv3: fix rpc receive buffer size for MOUNT call
Date:   Mon, 18 May 2020 19:36:53 +0200
Message-Id: <20200518173541.823374362@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

[ Upstream commit 8eed292bc8cbf737e46fb1c119d4c8f6dcb00650 ]

Prior to commit e3d3ab64dd66 ("SUNRPC: Use au_rslack when
computing reply buffer size"), there was enough slack in the reply
buffer to commodate filehandles of size 60bytes. However, the real
problem was that the reply buffer size for the MOUNT operation was
not correctly calculated. Received buffer size used the filehandle
size for NFSv2 (32bytes) which is much smaller than the allowed
filehandle size for the v3 mounts.

Fix the reply buffer size (decode arguments size) for the MNT command.

Fixes: 2c94b8eca1a2 ("SUNRPC: Use au_rslack when computing reply buffer size")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/mount_clnt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/mount_clnt.c b/fs/nfs/mount_clnt.c
index 35c8cb2d76372..dda5c3e65d8d6 100644
--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -30,6 +30,7 @@
 #define encode_dirpath_sz	(1 + XDR_QUADLEN(MNTPATHLEN))
 #define MNT_status_sz		(1)
 #define MNT_fhandle_sz		XDR_QUADLEN(NFS2_FHSIZE)
+#define MNT_fhandlev3_sz	XDR_QUADLEN(NFS3_FHSIZE)
 #define MNT_authflav3_sz	(1 + NFS_MAX_SECFLAVORS)
 
 /*
@@ -37,7 +38,7 @@
  */
 #define MNT_enc_dirpath_sz	encode_dirpath_sz
 #define MNT_dec_mountres_sz	(MNT_status_sz + MNT_fhandle_sz)
-#define MNT_dec_mountres3_sz	(MNT_status_sz + MNT_fhandle_sz + \
+#define MNT_dec_mountres3_sz	(MNT_status_sz + MNT_fhandlev3_sz + \
 				 MNT_authflav3_sz)
 
 /*
-- 
2.20.1



