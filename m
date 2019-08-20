Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB8A9618A
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbfHTNsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730098AbfHTNkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:33 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6938E22DD6;
        Tue, 20 Aug 2019 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308433;
        bh=OgpBk28+OrnHvqPeqzMYl2oZPOYiCQY87GIAvglBGk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYToLJxMYU/ARhFt7MMADO7EDBfxUSojHPJK14U3CcjXq77EwHgmYn+GEYwKnEpa1
         YvL30qJBXJ8TYarB96IzTZ047qvZ4vIHGcSg0vIqDMdhBz864eobkxTTzZnNaXYJbU
         Cj764B9NKU7XZDRvaEpDi2nkO7OAZB+JRXr0yy0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 04/44] afs: Fix loop index mixup in afs_deliver_vl_get_entry_by_name_u()
Date:   Tue, 20 Aug 2019 09:39:48 -0400
Message-Id: <20190820134028.10829-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Dionne <marc.dionne@auristor.com>

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
index d7e0fd3c00df9..cfb0ac4bd039e 100644
--- a/fs/afs/vlclient.c
+++ b/fs/afs/vlclient.c
@@ -56,23 +56,24 @@ static int afs_deliver_vl_get_entry_by_name_u(struct afs_call *call)
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

