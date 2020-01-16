Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CBB13F18C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391232AbgAPRZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392039AbgAPRZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 632BB246CA;
        Thu, 16 Jan 2020 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195532;
        bh=rDly9D/e2MKcATx3KbDgv+EbQlDIJgBWs1wyKJxdJKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUmaK5A7uPGqrJhr1CPr+ORlc38a+iHwMinBUtqHN6M01vM7RT/cGoosxD/+IMH8Q
         byMFb7xNL0urX7V1YkaQQ36lgKr40aCYzNTuPkOxd5Xz9bea1gM25xqAJnzoTBqDxG
         pEEEYB6VODpQays6/ngSytZKSW7X0z/QksO1Y9bU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 127/371] NFSv4/flexfiles: Fix invalid deref in FF_LAYOUT_DEVID_NODE()
Date:   Thu, 16 Jan 2020 12:19:59 -0500
Message-Id: <20200116172403.18149-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 108bb4afd351d65826648a47f11fa3104e250d9b ]

If the attempt to instantiate the mirror's layout DS pointer failed,
then that pointer may hold a value of type ERR_PTR(), so we need
to check that before we dereference it.

Fixes: 65990d1afbd2d ("pNFS/flexfiles: Fix a deadlock on LAYOUTGET")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.h | 32 +++++++++++++++-----------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.h b/fs/nfs/flexfilelayout/flexfilelayout.h
index d6515f1584f3..d78ec99b6c4c 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.h
+++ b/fs/nfs/flexfilelayout/flexfilelayout.h
@@ -131,16 +131,6 @@ FF_LAYOUT_LSEG(struct pnfs_layout_segment *lseg)
 			    generic_hdr);
 }
 
-static inline struct nfs4_deviceid_node *
-FF_LAYOUT_DEVID_NODE(struct pnfs_layout_segment *lseg, u32 idx)
-{
-	if (idx >= FF_LAYOUT_LSEG(lseg)->mirror_array_cnt ||
-	    FF_LAYOUT_LSEG(lseg)->mirror_array[idx] == NULL ||
-	    FF_LAYOUT_LSEG(lseg)->mirror_array[idx]->mirror_ds == NULL)
-		return NULL;
-	return &FF_LAYOUT_LSEG(lseg)->mirror_array[idx]->mirror_ds->id_node;
-}
-
 static inline struct nfs4_ff_layout_ds *
 FF_LAYOUT_MIRROR_DS(struct nfs4_deviceid_node *node)
 {
@@ -150,9 +140,25 @@ FF_LAYOUT_MIRROR_DS(struct nfs4_deviceid_node *node)
 static inline struct nfs4_ff_layout_mirror *
 FF_LAYOUT_COMP(struct pnfs_layout_segment *lseg, u32 idx)
 {
-	if (idx >= FF_LAYOUT_LSEG(lseg)->mirror_array_cnt)
-		return NULL;
-	return FF_LAYOUT_LSEG(lseg)->mirror_array[idx];
+	struct nfs4_ff_layout_segment *fls = FF_LAYOUT_LSEG(lseg);
+
+	if (idx < fls->mirror_array_cnt)
+		return fls->mirror_array[idx];
+	return NULL;
+}
+
+static inline struct nfs4_deviceid_node *
+FF_LAYOUT_DEVID_NODE(struct pnfs_layout_segment *lseg, u32 idx)
+{
+	struct nfs4_ff_layout_mirror *mirror = FF_LAYOUT_COMP(lseg, idx);
+
+	if (mirror != NULL) {
+		struct nfs4_ff_layout_ds *mirror_ds = mirror->mirror_ds;
+
+		if (!IS_ERR_OR_NULL(mirror_ds))
+			return &mirror_ds->id_node;
+	}
+	return NULL;
 }
 
 static inline u32
-- 
2.20.1

