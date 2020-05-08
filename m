Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0C1CACB8
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgEHMzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730027AbgEHMza (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:55:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3B97218AC;
        Fri,  8 May 2020 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942530;
        bh=b2QdKOeAuXxVphJVniePs7dMgcY5GW7kcKW3nlDsHuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfdBPA/dvoYkcqTRvqU1fJikcbFaIO774aAE1ul2eZQPSQV3cpVqkdAHXVcCtyl1G
         zwRgOdJKIRDLRALhKT7A+nuqWY7aliULH3nAxDU7dTo1rS8STCmztAMSr/smiIkNMd
         kLa1JxH5MPfNtvKmWFdzXtUrNifgE1Bjj4QZP2oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 32/49] cifs: do not share tcons with DFS
Date:   Fri,  8 May 2020 14:35:49 +0200
Message-Id: <20200508123047.448817393@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 65303de829dd6d291a4947c1a31de31896f8a060 ]

This disables tcon re-use for DFS shares.

tcon->dfs_path stores the path that the tcon should connect to when
doing failing over.

If that tcon is used multiple times e.g. 2 mounts using it with
different prefixpath, each will need a different dfs_path but there is
only one tcon. The other solution would be to split the tcon in 2
tcons during failover but that is much harder.

tcons could not be shared with DFS in cifs.ko because in a
DFS namespace like:

          //domain/dfsroot -> /serverA/dfsroot, /serverB/dfsroot

          //serverA/dfsroot/link -> /serverA/target1/aa/bb

          //serverA/dfsroot/link2 -> /serverA/target1/cc/dd

you can see that link and link2 are two DFS links that both resolve to
the same target share (/serverA/target1), so cifs.ko will only contain a
single tcon for both link and link2.

The problem with that is, if we (auto)mount "link" and "link2", cifs.ko
will only contain a single tcon for both DFS links so we couldn't
perform failover or refresh the DFS cache for both links because
tcon->dfs_path was set to either "link" or "link2", but not both --
which is wrong.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d4a23b48e24d8..9c614d6916c2d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3419,6 +3419,10 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &ses->tcon_list) {
 		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+		if (tcon->dfs_path)
+			continue;
+#endif
 		if (!match_tcon(tcon, volume_info))
 			continue;
 		++tcon->tc_count;
-- 
2.20.1



