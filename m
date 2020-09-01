Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84019259489
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbgIAPkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731251AbgIAPko (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F05206EF;
        Tue,  1 Sep 2020 15:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974844;
        bh=fgw8t3NnhMFaUUKRwL+4eoTTjNCPCjwBU1jrwJ9Oky8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2d9Fg2g1tVFBrJJBhASPwbfqUXXStgYIkfXItzQipJ8ifq+II3a02dmW7NUO2X0R
         9G84XdQYDWEp6Z4VrHgAuQAkUteyKGbRPyyeg3pdpZuorjtDufyvydjLju41UaKVtc
         C5k5fXH8f0FGbYGC62mcvTzjVPkMliyM282dPeh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Dinse <nanook@eskimo.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 085/255] nfsd: fix oops on mixed NFSv4/NFSv3 client access
Date:   Tue,  1 Sep 2020 17:09:01 +0200
Message-Id: <20200901151004.808554866@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 34b09af4f54e6485e28f138ccad159611a240cc1 ]

If an NFSv2/v3 client breaks an NFSv4 client's delegation, it will hit a
NULL dereference in nfsd_breaker_owns_lease().

Easily reproduceable with for example

	mount -overs=4.2 server:/export /mnt/
	sleep 1h </mnt/file &
	mount -overs=3 server:/export /mnt2/
	touch /mnt2/file

Reported-by: Robert Dinse <nanook@eskimo.com>
Fixes: 28df3d1539de50 ("nfsd: clients don't need to break their own delegations")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208807
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c9056316a0b35..cea682ce8aa12 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4597,6 +4597,8 @@ static bool nfsd_breaker_owns_lease(struct file_lock *fl)
 	if (!i_am_nfsd())
 		return NULL;
 	rqst = kthread_data(current);
+	if (!rqst->rq_lease_breaker)
+		return NULL;
 	clp = *(rqst->rq_lease_breaker);
 	return dl->dl_stid.sc_client == clp;
 }
-- 
2.25.1



