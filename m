Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487B713F871
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbgAPQyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:54:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbgAPQyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E308E20730;
        Thu, 16 Jan 2020 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193674;
        bh=KwjDVFbYw+rVNx+dp2OcqyOgdPW3JmecrfBX7PlNNsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KF/bgcjUQ6fGDGbGXgCFC0sOBU85OD+e6lk9JAy8++Rz7MEWP2iXne2rkREFyc1kD
         hTTqV8SPfUzgAseu1GJLVv8nuDx336Ig1jD+ZOJl7O/OKRKPCnHtRm4GKRriP4m1UY
         0MBseTMhv0GCmQNoDuBXaCePifxZL4dLpmc3n5Q8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Steinhardt <ps@pks.im>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 199/205] nfsd: depend on CRYPTO_MD5 for legacy client tracking
Date:   Thu, 16 Jan 2020 11:42:54 -0500
Message-Id: <20200116164300.6705-199-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Steinhardt <ps@pks.im>

[ Upstream commit 38a2204f5298620e8a1c3b1dc7b831425106dbc0 ]

The legacy client tracking infrastructure of nfsd makes use of MD5 to
derive a client's recovery directory name. As the nfsd module doesn't
declare any dependency on CRYPTO_MD5, though, it may fail to allocate
the hash if the kernel was compiled without it. As a result, generation
of client recovery directories will fail with the following error:

    NFSD: unable to generate recoverydir name

The explicit dependency on CRYPTO_MD5 was removed as redundant back in
6aaa67b5f3b9 (NFSD: Remove redundant "select" clauses in fs/Kconfig
2008-02-11) as it was already implicitly selected via RPCSEC_GSS_KRB5.
This broke when RPCSEC_GSS_KRB5 was made optional for NFSv4 in commit
df486a25900f (NFS: Fix the selection of security flavours in Kconfig) at
a later point.

Fix the issue by adding back an explicit dependency on CRYPTO_MD5.

Fixes: df486a25900f (NFS: Fix the selection of security flavours in Kconfig)
Signed-off-by: Patrick Steinhardt <ps@pks.im>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index c4b1a89b8845..f2f81561ebb6 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -73,6 +73,7 @@ config NFSD_V4
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
+	select CRYPTO_MD5
 	select CRYPTO_SHA256
 	select GRACE_PERIOD
 	help
-- 
2.20.1

