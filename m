Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC05272F7F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgIUQ5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbgIUQnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E24312076B;
        Mon, 21 Sep 2020 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706579;
        bh=lej9QhMUZOEJoSIhmR5Ga6B7vctYMZVw0Fpwlb1LJ90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KH2rg/Cmiw+w/kbQcozXOuFn5f45C0bnnucurJNfKrWkGBKwvnQxZZyAYDThy+/ta
         S5bsPryxcAKCCOcF/Vl61LoPNM2rw3UM9a4xt3F58X2qA8/GgVKp6HTvsDoLDG8dW+
         pn0Y3hLXmiBkUWT2FZwRTZIkQlFASCR6+hivmtUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 010/118] NFSv4.1 handle ERR_DELAY error reclaiming locking state on delegation recall
Date:   Mon, 21 Sep 2020 18:27:02 +0200
Message-Id: <20200921162036.810585110@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 45e0585e0667c..7f337188a2829 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7271,7 +7271,12 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
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



