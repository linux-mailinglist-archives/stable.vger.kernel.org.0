Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE8513F927
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgAPQxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbgAPQxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E855021D56;
        Thu, 16 Jan 2020 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193593;
        bh=s7LTG2wB0wzmYFRwfx/x9FXxgBvnEO74YT1d8UFo9bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6IF1mqxZ4hfQw7AgoNlDBAGHlnz2MQAKyX9oKfso/HGATIGJsQoOpjb6cFwdRHYy
         tLrrHCjRQyAWX08oCyogjewU1AVBafF0U2zyxC3FFO6mA0Tn5OAQDAic6KDBR5tHnd
         w5+RVEDWHJG1JbxiyczL22zOlpG82dqZVzMcQuE0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Mayhew <smayhew@redhat.com>,
        Jamie Heilman <jamie@audible.transient.net>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 133/205] nfsd: Fix cld_net->cn_tfm initialization
Date:   Thu, 16 Jan 2020 11:41:48 -0500
Message-Id: <20200116164300.6705-133-sashal@kernel.org>
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

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 18b9a895e652979b70f9c20565394a69354dfebc ]

Don't assign an error pointer to cld_net->cn_tfm, otherwise an oops will
occur in nfsd4_remove_cld_pipe().

Also, move the initialization of cld_net->cn_tfm so that it occurs after
the check to see if nfsdcld is running.  This is necessary because
nfsd4_client_tracking_init() looks for -ETIMEDOUT to determine whether
to use the "old" nfsdcld tracking ops.

Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
Reported-by: Jamie Heilman <jamie@audible.transient.net>
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index cdc75ad4438b..c35c0ebaf722 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -1578,6 +1578,7 @@ nfsd4_cld_tracking_init(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	bool running;
 	int retries = 10;
+	struct crypto_shash *tfm;
 
 	status = nfs4_cld_state_init(net);
 	if (status)
@@ -1586,11 +1587,6 @@ nfsd4_cld_tracking_init(struct net *net)
 	status = __nfsd4_init_cld_pipe(net);
 	if (status)
 		goto err_shutdown;
-	nn->cld_net->cn_tfm = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(nn->cld_net->cn_tfm)) {
-		status = PTR_ERR(nn->cld_net->cn_tfm);
-		goto err_remove;
-	}
 
 	/*
 	 * rpc pipe upcalls take 30 seconds to time out, so we don't want to
@@ -1607,6 +1603,12 @@ nfsd4_cld_tracking_init(struct net *net)
 		status = -ETIMEDOUT;
 		goto err_remove;
 	}
+	tfm = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(tfm)) {
+		status = PTR_ERR(tfm);
+		goto err_remove;
+	}
+	nn->cld_net->cn_tfm = tfm;
 
 	status = nfsd4_cld_get_version(nn);
 	if (status == -EOPNOTSUPP)
-- 
2.20.1

