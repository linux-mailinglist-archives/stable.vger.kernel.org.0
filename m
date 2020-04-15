Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2980E1AA3DA
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897086AbgDONNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897051AbgDOLf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BDF620857;
        Wed, 15 Apr 2020 11:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950526;
        bh=DJq3kiVid+PEWn5WE6VUYAktHgMxGYUpiygRCvaI3+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOxlYBsGXuwq1b7R+ihsvoFhKpIFlzh5Q8BJgMazGHHsDFlagVYhUef05ccqMh2Ec
         0s58O1a8W8kW2D+UCLyf+wS74MckGhDg/SFZDR4r7D7niEWXbyZibNf2MDHIkbZy3v
         AL/R7OechECoYUlP73TO/q23NNv2F9W4bDA1+tX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 035/129] NFSv4/pnfs: Return valid stateids in nfs_layout_find_inode_by_stateid()
Date:   Wed, 15 Apr 2020 07:33:10 -0400
Message-Id: <20200415113445.11881-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d911c57a19551c6bef116a3b55c6b089901aacb0 ]

Make sure to test the stateid for validity so that we catch instances
where the server may have been reusing stateids in
nfs_layout_find_inode_by_stateid().

Fixes: 7b410d9ce460 ("pNFS: Delay getting the layout header in CB_LAYOUTRECALL handlers")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index cd4c6bc81caed..40d31024b72d1 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -128,6 +128,8 @@ static struct inode *nfs_layout_find_inode_by_stateid(struct nfs_client *clp,
 
 	list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link) {
 		list_for_each_entry(lo, &server->layouts, plh_layouts) {
+			if (!pnfs_layout_is_valid(lo))
+				continue;
 			if (stateid != NULL &&
 			    !nfs4_stateid_match_other(stateid, &lo->plh_stateid))
 				continue;
-- 
2.20.1

