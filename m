Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D5E1480C3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389526AbgAXLOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390119AbgAXLOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:14:16 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB32620663;
        Fri, 24 Jan 2020 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864455;
        bh=2xFYQxeoUMDOb42t4erRQhfq7gk3Vm3YhXN20mTPnyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTsJMc/r3a2i7eLB0G6UwOC8C8sYVqa85vrlNIGqS15mni+L8M0VfpVGEqeM8MRmy
         FWXu0cv2BRzDvv8ElDwMbRZARbvzICG1j03yCRgPD6hOCyYLR/2TknIpNTsbGvE7P0
         fmlPPajrbiA2VBiSYe7x6n1Ak3jmtvjA9YdM1om4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 247/639] NFSv4/flexfiles: Fix invalid deref in FF_LAYOUT_DEVID_NODE()
Date:   Fri, 24 Jan 2020 10:26:57 +0100
Message-Id: <20200124093117.707414697@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index de50a342d5a50..2ac99124474cb 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.h
+++ b/fs/nfs/flexfilelayout/flexfilelayout.h
@@ -132,16 +132,6 @@ FF_LAYOUT_LSEG(struct pnfs_layout_segment *lseg)
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
@@ -151,9 +141,25 @@ FF_LAYOUT_MIRROR_DS(struct nfs4_deviceid_node *node)
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



