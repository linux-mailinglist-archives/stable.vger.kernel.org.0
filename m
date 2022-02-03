Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2184A8E8B
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355408AbiBCUhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:37:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42008 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355388AbiBCUft (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F356F61A6A;
        Thu,  3 Feb 2022 20:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892FFC340E8;
        Thu,  3 Feb 2022 20:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920548;
        bh=8tqkdPSe1TX4gYfhZraComcw/+m05OtfO1tnPVdC2rA=;
        h=From:To:Cc:Subject:Date:From;
        b=jfFGlfra4qo85MNZwxeKLCGgDgrkJnLydQ+5NrzNW63NHn3U6d66lKPBp5Np8anTk
         RYzIDGYRW07E/8vFNFikF+j+BecO+d497MNrAmaT9BkbNCm8ZOlxZgI2mUmeG8jwvM
         p9le6rlPHbWjIuV71FTKrAYXQCqqq0oXuQn7FYllYpww3WW6mnRry1lVADg3T/Jzxx
         e1ToTOOkIkaxXGy3iY7VP7VilhaytTOAH1hjarrW8LqQEFLt+iNptYkUeV1XLdDEjC
         cU2+LFgvR6iVXI5OMDyWRJEDrxV4Qv/PnvFNaN+XSFGmQ/qWXihKWAgqhUJzuiFkQp
         nJ378DkSyKk8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/15] NFSv4 only print the label when its queried
Date:   Thu,  3 Feb 2022 15:35:31 -0500
Message-Id: <20220203203545.3879-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 2c52c8376db7160a1dd8a681c61c9258405ef143 ]

When the bitmask of the attributes doesn't include the security label,
don't bother printing it. Since the label might not be null terminated,
adjust the printing format accordingly.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 9a022a4fb9643..0fc08d22c9218 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4187,10 +4187,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		} else
 			printk(KERN_WARNING "%s: label too long (%u)!\n",
 					__func__, len);
+		if (label && label->label)
+			dprintk("%s: label=%.*s, len=%d, PI=%d, LFS=%d\n",
+				__func__, label->len, (char *)label->label,
+				label->len, label->pi, label->lfs);
 	}
-	if (label && label->label)
-		dprintk("%s: label=%s, len=%d, PI=%d, LFS=%d\n", __func__,
-			(char *)label->label, label->len, label->pi, label->lfs);
 	return status;
 }
 
-- 
2.34.1

