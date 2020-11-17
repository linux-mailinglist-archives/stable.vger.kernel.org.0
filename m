Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAB12B64A9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgKQNsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:48:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732086AbgKQNg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDBE620870;
        Tue, 17 Nov 2020 13:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620218;
        bh=tL9HrRRDNxQggAbsm76sO+mn2lqsQvEHl8qyqqMWOsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfO2x9aRu6vuMFzl0QzepNEcb0UZYqU9EPb+dqHWUvfksVH4hZ34Q+8DAoJizNTvS
         zxBs1+ORU4+ehBgaTglTk7ST0qa7R7nnxaybUV7nHOLEcLmn7fiVhtoeW7bzh/+fxb
         1FjSUeRLpA7fSGUGEE6Rab5Ei3MtNaWEoHtkf7dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 145/255] NFSD: fix missing refcount in nfsd4_copy by nfsd4_do_async_copy
Date:   Tue, 17 Nov 2020 14:04:45 +0100
Message-Id: <20201117122146.020280520@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 49a361327332c9221438397059067f9b205f690d ]

Need to initialize nfsd4_copy's refcount to 1 to avoid use-after-free
warning when nfs4_put_copy is called from nfsd4_cb_offload_release.

Fixes: ce0887ac96d3 ("NFSD add nfs4 inter ssc to nfsd4_copy")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 80effaa18b7b2..3ba17b5fc9286 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1486,6 +1486,7 @@ do_callback:
 	cb_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 	if (!cb_copy)
 		goto out;
+	refcount_set(&cb_copy->refcount, 1);
 	memcpy(&cb_copy->cp_res, &copy->cp_res, sizeof(copy->cp_res));
 	cb_copy->cp_clp = copy->cp_clp;
 	cb_copy->nfserr = copy->nfserr;
-- 
2.27.0



