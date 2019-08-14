Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8465A8C8FD
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfHNCfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbfHNCNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57CC321721;
        Wed, 14 Aug 2019 02:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748819;
        bh=QDA+wZbqL00DcUe7rHsoYGH18rcg7ZtglEbJHTJC1gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1vnBWQqBYS01jtKAmZ1w3WUDtTi1yj/8ZcYxilOwx9Zn6cqXMFCQrKOiDVjlW/sZ
         /hE1vFjcy2ka4m46fXR8e3AauodPPDuYdP8tB9qjDTwWaJmo4o3sJKI/uyFOxrwaQU
         dB8yzs0czOglnd/OAbm5KT2O3rtdCiibKsz/t3IM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 080/123] NFSv4: Fix a credential refcount leak in nfs41_check_delegation_stateid
Date:   Tue, 13 Aug 2019 22:10:04 -0400
Message-Id: <20190814021047.14828-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 8c39a39e28b86a4021d9be314ce01019bafa5fdc ]

It is unsafe to dereference delegation outside the rcu lock, and in
any case, the refcount is guaranteed held if cred is non-zero.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6418cb6c079bd..11a5aa46e64c3 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2749,8 +2749,7 @@ static void nfs41_check_delegation_stateid(struct nfs4_state *state)
 	if (status == -NFS4ERR_EXPIRED || status == -NFS4ERR_BAD_STATEID)
 		nfs_finish_clear_delegation_stateid(state, &stateid);
 
-	if (delegation->cred)
-		put_cred(cred);
+	put_cred(cred);
 }
 
 /**
-- 
2.20.1

