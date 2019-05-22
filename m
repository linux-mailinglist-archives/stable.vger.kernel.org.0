Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570AE26D70
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbfEVT2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732637AbfEVT2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:28:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4E9720879;
        Wed, 22 May 2019 19:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553326;
        bh=GWGQ7LyqMyF3msz3Dc3HSkHmIgeqCWLKj8slZybAwT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxblzuLMjcRqvcET937BxUAIHRpUSADG45B2UZQN+tudQXfdgd//w/f5GrjMzGQWp
         +4G5Z6D7P8WJBAKwcAoNaszmirMvQ/dhgDWynvvsgnltTl3c6oDuS3coGnf6zAXwL8
         mTnWl1DmjaR/OvUTWarzCymxiFl4sA7j9/923jW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 003/167] NFS: make nfs_match_client killable
Date:   Wed, 22 May 2019 15:25:58 -0400
Message-Id: <20190522192842.25858-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

[ Upstream commit 950a578c6128c2886e295b9c7ecb0b6b22fcc92b ]

    Actually we don't do anything with return value from
    nfs_wait_client_init_complete in nfs_match_client, as a
    consequence if we get a fatal signal and client is not
    fully initialised, we'll loop to "again" label

    This has been proven to cause soft lockups on some scenarios
    (no-carrier but configured network interfaces)

Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index a98d64a6eda5c..65da2c105f434 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -290,6 +290,7 @@ static struct nfs_client *nfs_match_client(const struct nfs_client_initdata *dat
 	struct nfs_client *clp;
 	const struct sockaddr *sap = data->addr;
 	struct nfs_net *nn = net_generic(data->net, nfs_net_id);
+	int error;
 
 again:
 	list_for_each_entry(clp, &nn->nfs_client_list, cl_share_link) {
@@ -302,8 +303,10 @@ static struct nfs_client *nfs_match_client(const struct nfs_client_initdata *dat
 		if (clp->cl_cons_state > NFS_CS_READY) {
 			atomic_inc(&clp->cl_count);
 			spin_unlock(&nn->nfs_client_lock);
-			nfs_wait_client_init_complete(clp);
+			error = nfs_wait_client_init_complete(clp);
 			nfs_put_client(clp);
+			if (error < 0)
+				return ERR_PTR(error);
 			spin_lock(&nn->nfs_client_lock);
 			goto again;
 		}
@@ -413,6 +416,8 @@ struct nfs_client *nfs_get_client(const struct nfs_client_initdata *cl_init)
 		clp = nfs_match_client(cl_init);
 		if (clp) {
 			spin_unlock(&nn->nfs_client_lock);
+			if (IS_ERR(clp))
+				return clp;
 			if (new)
 				new->rpc_ops->free_client(new);
 			return nfs_found_client(cl_init, clp);
-- 
2.20.1

