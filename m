Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DC6268C04
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 15:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgINNQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 09:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgINNHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:07:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 451272223C;
        Mon, 14 Sep 2020 13:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088760;
        bh=PcFS4xgIDtvvf/g6pRLbif+U5fD1idhTuM9rUr1LFgc=;
        h=From:To:Cc:Subject:Date:From;
        b=K9OVUHcaVagO6a3vpUCu9ksq90VdHBi1/FLDrx8Ee9D7FgJYltyhJjaP6KqtN+eHf
         5aVOHQpAPJ5/mYqV954hoFgBUnqTrQA2QtG/UmM3oz8EnMpkuKxn2OVTex5iK4TGpP
         he7WLNzlx2iRfOe87IQUdLJeb+3ZeGpsYSGBpDxY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/8] NFSv4.1 handle ERR_DELAY error reclaiming locking state on delegation recall
Date:   Mon, 14 Sep 2020 09:05:51 -0400
Message-Id: <20200914130559.1805574-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 3d7a9520f0c3e6a68b6de8c5812fc8b6d7a52626 ]

A client should be able to handle getting an ERR_DELAY error
while doing a LOCK call to reclaim state due to delegation being
recalled. This is a transient error that can happen due to server
moving its volumes and invalidating its file location cache and
upon reference to it during the LOCK call needing to do an
expensive lookup (leading to an ERR_DELAY error on a PUTFH).

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ca1702cefb852..64d15c2662db6 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6171,7 +6171,12 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
 	err = nfs4_set_lock_state(state, fl);
 	if (err != 0)
 		return err;
-	err = _nfs4_do_setlk(state, F_SETLK, fl, NFS_LOCK_NEW);
+	do {
+		err = _nfs4_do_setlk(state, F_SETLK, fl, NFS_LOCK_NEW);
+		if (err != -NFS4ERR_DELAY)
+			break;
+		ssleep(1);
+	} while (err == -NFS4ERR_DELAY);
 	return nfs4_handle_delegation_recall_error(server, state, stateid, fl, err);
 }
 
-- 
2.25.1

