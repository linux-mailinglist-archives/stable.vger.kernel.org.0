Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2778B450C2D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbhKORfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhKOReS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:34:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3C74632B7;
        Mon, 15 Nov 2021 17:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996958;
        bh=QdCuTrerCYzph3/hR6NHSxUhLpJXJmr6rZhQmEhun28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7eweGu9YMo1lqyJQcD2V44klSoHRhutRmwhdx4oy9KCfRR8s0xSimSnWGNhHUPXL
         eA8EvGJcsSzLeh3wcmj9Da3GPBesnWqNH6quSW86SV1vnY1VW67J1/8bQljdsSgN0y
         +bGa/hTcszKwxmvrVqiRrTCKexeHKdXPfY6K/NWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 313/355] NFSv4: Fix a regression in nfs_set_open_stateid_locked()
Date:   Mon, 15 Nov 2021 18:03:57 +0100
Message-Id: <20211115165323.843930691@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 01d29f87fcfef38d51ce2b473981a5c1e861ac0a ]

If we already hold open state on the client, yet the server gives us a
completely different stateid to the one we already hold, then we
currently treat it as if it were an out-of-sequence update, and wait for
5 seconds for other updates to come in.
This commit fixes the behaviour so that we immediately start processing
of the new stateid, and then leave it to the call to
nfs4_test_and_free_stateid() to decide what to do with the old stateid.

Fixes: b4868b44c562 ("NFSv4: Wait for stateid updates after CLOSE/OPEN_DOWNGRADE")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5ecaf7b6b0fa1..fb3d1532f11dd 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1549,15 +1549,16 @@ static bool nfs_stateid_is_sequential(struct nfs4_state *state,
 {
 	if (test_bit(NFS_OPEN_STATE, &state->flags)) {
 		/* The common case - we're updating to a new sequence number */
-		if (nfs4_stateid_match_other(stateid, &state->open_stateid) &&
-			nfs4_stateid_is_next(&state->open_stateid, stateid)) {
-			return true;
+		if (nfs4_stateid_match_other(stateid, &state->open_stateid)) {
+			if (nfs4_stateid_is_next(&state->open_stateid, stateid))
+				return true;
+			return false;
 		}
-	} else {
-		/* This is the first OPEN in this generation */
-		if (stateid->seqid == cpu_to_be32(1))
-			return true;
+		/* The server returned a new stateid */
 	}
+	/* This is the first OPEN in this generation */
+	if (stateid->seqid == cpu_to_be32(1))
+		return true;
 	return false;
 }
 
-- 
2.33.0



