Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981ACEEDF1
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390151AbfKDWLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389690AbfKDWLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:11:38 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D524C214D8;
        Mon,  4 Nov 2019 22:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905497;
        bh=T+LjWKOQ8tdarN2nS0pC/yJIt6hkP6gQJLvHeZuI8gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfiiVU+rulsvydgdKpGt945IaeV2QFi0GJiglZz/sXAgeLy1IBJ5fVxQriCCcpbin
         bwV217xmqQmMARxvTvc6OG+l3UC0fxwVTXUaYLU3fUwvrQwCHortMhhHbgdI37CoC9
         6B1e0YEpTHsqhZgK1g8EgtXuOFUWkFHm4bCd8br0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.3 142/163] NFS: Fix an RCU lock leak in nfs4_refresh_delegation_stateid()
Date:   Mon,  4 Nov 2019 22:45:32 +0100
Message-Id: <20191104212150.614033643@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 79cc55422ce99be5964bde208ba8557174720893 upstream.

A typo in nfs4_refresh_delegation_stateid() means we're leaking an
RCU lock, and always returning a value of 'false'. As the function
description states, we were always supposed to return 'true' if a
matching delegation was found.

Fixes: 12f275cdd163 ("NFSv4: Retry CLOSE and DELEGRETURN on NFS4ERR_OLD_STATEID.")
Cc: stable@vger.kernel.org # v4.15+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/delegation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -1181,7 +1181,7 @@ bool nfs4_refresh_delegation_stateid(nfs
 	if (delegation != NULL &&
 	    nfs4_stateid_match_other(dst, &delegation->stateid)) {
 		dst->seqid = delegation->stateid.seqid;
-		return ret;
+		ret = true;
 	}
 	rcu_read_unlock();
 out:


