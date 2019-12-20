Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E71127D4E
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfLTOcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbfLTOav (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F7824684;
        Fri, 20 Dec 2019 14:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852251;
        bh=7JgE0/+qMmvES20+Q4uK73b5Uykyb51CBPXEGNZn+E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2wmQ52n04SDDKc38+LT6d/wEqBMVAyByA5I0mZEhy3dGhd+WUnkbJJGpQ0enFEOS
         M41z0gXo3GlKFdZPMDhzOL3ZdzWIsdzFt9M/i8+ypSGCWa60B213NzMUC+kIz1b1Bs
         84hJeyGKliqSCxFAm/b8wimUMK5LaMClEn/eCTrA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jonathan Billings <jsbillings@jsbillings.org>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 42/52] afs: Fix creation calls in the dynamic root to fail with EOPNOTSUPP
Date:   Fri, 20 Dec 2019 09:29:44 -0500
Message-Id: <20191220142954.9500-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 1da4bd9f9d187f53618890d7b66b9628bbec3c70 ]

Fix the lookup method on the dynamic root directory such that creation
calls, such as mkdir, open(O_CREAT), symlink, etc. fail with EOPNOTSUPP
rather than failing with some odd error (such as EEXIST).

lookup() itself tries to create automount directories when it is invoked.
These are cached locally in RAM and not committed to storage.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Jonathan Billings <jsbillings@jsbillings.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dynroot.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index 4150280509fff..7503899c0a1b5 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -136,6 +136,9 @@ static struct dentry *afs_dynroot_lookup(struct inode *dir, struct dentry *dentr
 
 	ASSERTCMP(d_inode(dentry), ==, NULL);
 
+	if (flags & LOOKUP_CREATE)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (dentry->d_name.len >= AFSNAMEMAX) {
 		_leave(" = -ENAMETOOLONG");
 		return ERR_PTR(-ENAMETOOLONG);
-- 
2.20.1

