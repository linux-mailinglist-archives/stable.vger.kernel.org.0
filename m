Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153DDA8FE7
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388704AbfIDSGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388511AbfIDSGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C757233FF;
        Wed,  4 Sep 2019 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620393;
        bh=0O4n15exUaNewwAAnbQAviNpDYEccMYQtdw6g4eJd70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y817GkgjakYLCqB+KmPzFM1A5ZTJzYodE5QMWRPBxL09y+QIe9bF5nv2jVhWYdhzh
         x8GwlgQ/zGQqjdo6+iidfI5zb7KLocTy23hPuN/tRGuYk2mNMFDN6pn5eRziTnUUlY
         x/HpsQAXNRYxW2qjk7FuVyco0uaWNLI5yWD147kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/93] afs: Fix loop index mixup in afs_deliver_vl_get_entry_by_name_u()
Date:   Wed,  4 Sep 2019 19:53:06 +0200
Message-Id: <20190904175303.270365119@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4a46fdba449a5cd890271df5a9e23927d519ed00 ]

afs_deliver_vl_get_entry_by_name_u() scans through the vl entry
received from the volume location server and builds a return list
containing the sites that are currently valid.  When assigning
values for the return list, the index into the vl entry (i) is used
rather than the one for the new list (entry->nr_server).  If all
sites are usable, this works out fine as the indices will match.
If some sites are not valid, for example if AFS_VLSF_DONTUSE is
set, fs_mask and the uuid will be set for the wrong return site.

Fix this by using entry->nr_server as the index into the arrays
being filled in rather than i.

This can lead to EDESTADDRREQ errors if none of the returned sites
have a valid fs_mask.

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/vlclient.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/afs/vlclient.c b/fs/afs/vlclient.c
index c3b740813fc71..c7dd47eaff29d 100644
--- a/fs/afs/vlclient.c
+++ b/fs/afs/vlclient.c
@@ -60,23 +60,24 @@ static int afs_deliver_vl_get_entry_by_name_u(struct afs_call *call)
 		struct afs_uuid__xdr *xdr;
 		struct afs_uuid *uuid;
 		int j;
+		int n = entry->nr_servers;
 
 		tmp = ntohl(uvldb->serverFlags[i]);
 		if (tmp & AFS_VLSF_DONTUSE ||
 		    (new_only && !(tmp & AFS_VLSF_NEWREPSITE)))
 			continue;
 		if (tmp & AFS_VLSF_RWVOL) {
-			entry->fs_mask[i] |= AFS_VOL_VTM_RW;
+			entry->fs_mask[n] |= AFS_VOL_VTM_RW;
 			if (vlflags & AFS_VLF_BACKEXISTS)
-				entry->fs_mask[i] |= AFS_VOL_VTM_BAK;
+				entry->fs_mask[n] |= AFS_VOL_VTM_BAK;
 		}
 		if (tmp & AFS_VLSF_ROVOL)
-			entry->fs_mask[i] |= AFS_VOL_VTM_RO;
-		if (!entry->fs_mask[i])
+			entry->fs_mask[n] |= AFS_VOL_VTM_RO;
+		if (!entry->fs_mask[n])
 			continue;
 
 		xdr = &uvldb->serverNumber[i];
-		uuid = (struct afs_uuid *)&entry->fs_server[i];
+		uuid = (struct afs_uuid *)&entry->fs_server[n];
 		uuid->time_low			= xdr->time_low;
 		uuid->time_mid			= htons(ntohl(xdr->time_mid));
 		uuid->time_hi_and_version	= htons(ntohl(xdr->time_hi_and_version));
-- 
2.20.1



