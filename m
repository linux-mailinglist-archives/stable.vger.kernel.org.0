Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFAB1F2E91
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgFIAms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgFHXMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CE7C20897;
        Mon,  8 Jun 2020 23:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657941;
        bh=jCGm61rHDVJ9r6X9hoS3jwAJ1rd3zWfrw3/4ZrbkIv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TY0FUzdwfIGLw1E2sR+sgJW22+i+8dFZyP96hGVIXUiF2xRKDiUFgrTIbvKSTOr9
         HrjmfqY4BfdQQMjCLzgla96xXviQokKpKep0CbCeYGTrmNVuuWUPJtrkwyxNT2aJx8
         j+jsabzH9NDYhuK9E6ezIAGBIiJxJBfESb4c81F0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 007/606] NFSv3: fix rpc receive buffer size for MOUNT call
Date:   Mon,  8 Jun 2020 19:02:12 -0400
Message-Id: <20200608231211.3363633-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 35c8cb2d7637..dda5c3e65d8d 100644
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
2.25.1

