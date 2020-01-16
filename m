Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1185013E234
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731690AbgAPQye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:54:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732209AbgAPQye (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A85BB214AF;
        Thu, 16 Jan 2020 16:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193673;
        bh=6RmZS8R/qbLmC24LIgFWQHrkZAi6i9WyA++AiikMsrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTcUpVKza25MiwqTSTjwhfdAkU+2RfQELH7urw2KhcLnTPaxwGu61F10l7J9TjPe9
         Wl/FVCw9FHDZuBTU/cVOi8jZm2fofbzy9U6mqIjs4ipxFhtN7aPvtdF8pX9YOH9oVq
         AAQuZwiUm7RFrlLPSDYt+MRuGklbpjjKp0K1gG4c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 198/205] NFSD fixing possible null pointer derefering in copy offload
Date:   Thu, 16 Jan 2020 11:42:53 -0500
Message-Id: <20200116164300.6705-198-sashal@kernel.org>
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

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

[ Upstream commit 18f428d4e2f7eff162d80b2b21689496c4e82afd ]

Static checker revealed possible error path leading to possible
NULL pointer dereferencing.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: e0639dc5805a: ("NFSD introduce async copy feature")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 38c0aeda500e..4798667af647 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1298,7 +1298,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 out:
 	return status;
 out_err:
-	cleanup_async_copy(async_copy);
+	if (async_copy)
+		cleanup_async_copy(async_copy);
 	goto out;
 }
 
-- 
2.20.1

