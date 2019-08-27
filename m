Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DDA9E133
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbfH0IKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731972AbfH0IC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E3A2186A;
        Tue, 27 Aug 2019 08:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892948;
        bh=VOBrXKGBSwVOlpOn6lPZW63CEq/o4um1ONSFvoetJZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWraExVKpwYFcDB6b0YbMjA1AgKUZrT96ImJjTwkF+z1NFvYt8ESh1Adio+S5gqjV
         /Ml7FrbU8bIKkzAFs9aR+cbfhVouhr6lxry19+CaCAsC+COJdJBovBbmQa77I4Bewy
         t6BVAsd5MHoYwUAPAkqFIOLpAbKkoJYlcLmLAiiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 071/162] NFSv4: Fix a credential refcount leak in nfs41_check_delegation_stateid
Date:   Tue, 27 Aug 2019 09:49:59 +0200
Message-Id: <20190827072740.607306162@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8c39a39e28b86a4021d9be314ce01019bafa5fdc ]

It is unsafe to dereference delegation outside the rcu lock, and in
any case, the refcount is guaranteed held if cred is non-zero.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 63edda145d1b8..420f2350c2781 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2752,8 +2752,7 @@ static void nfs41_check_delegation_stateid(struct nfs4_state *state)
 	if (status == -NFS4ERR_EXPIRED || status == -NFS4ERR_BAD_STATEID)
 		nfs_finish_clear_delegation_stateid(state, &stateid);
 
-	if (delegation->cred)
-		put_cred(cred);
+	put_cred(cred);
 }
 
 /**
-- 
2.20.1



