Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A145452260
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351198AbhKPBLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244829AbhKOTRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A75E634CF;
        Mon, 15 Nov 2021 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000668;
        bh=i/7S39qQbHs2nCtUI34TzsTsOa/g1/ukLxEnfut4UTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vtuoem7szdiav+ukTAP36yC1mpDXnu2UnR039uz1UCWqSO6ZmDdNuGuSPifSkz19x
         drxRCDorgQmpANImAvJBGmR24qLT3PmcS50fFa48knRRV7tsQG9IrRC7eQ+qnx1nUY
         RRA5GrzGWewKxOidh9JpBHYJ/c5IOG+vP25KM/oM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 713/849] NFSv4: Fix a regression in nfs_set_open_stateid_locked()
Date:   Mon, 15 Nov 2021 18:03:16 +0100
Message-Id: <20211115165444.373249045@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index e1214bb6b7ee5..1f38f8cd8c3ce 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1609,15 +1609,16 @@ static bool nfs_stateid_is_sequential(struct nfs4_state *state,
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



