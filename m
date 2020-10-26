Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D757C29A0AA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409344AbgJ0AcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409470AbgJZXvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56F821BE5;
        Mon, 26 Oct 2020 23:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756296;
        bh=M9F62+T2D+Vko2emsXaJiqrfHkqPHC7PmlJ13Y5L0zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/Hi1kbx4MDFSX6P2BLuRPgvHH6muOhfUJiF2JcSseSIlMyFTMsNdHxZXbLi182IE
         81EE2MT+emF1a+gEVafmOekfUm+BU6ocKFEPf82wWjJE0CpIDFokehZcVFr59jivU4
         nLoDbA1EaIX2tt2kmLdlnACp4D2aDcvpnNZCrIwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.9 123/147] gfs2: call truncate_inode_pages_final for address space glocks
Date:   Mon, 26 Oct 2020 19:48:41 -0400
Message-Id: <20201026234905.1022767-123-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit ee1e2c773e4f4ce2213f9d77cc703b669ca6fa3f ]

Before this patch, we were not calling truncate_inode_pages_final for the
address space for glocks, which left the possibility of a leak. We now
take care of the problem instead of complaining, and we do it during
glock tear-down..

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f13b136654cae..3554e71be06ec 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -270,7 +270,12 @@ static void __gfs2_glock_put(struct gfs2_glock *gl)
 	gfs2_glock_remove_from_lru(gl);
 	spin_unlock(&gl->gl_lockref.lock);
 	GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
-	GLOCK_BUG_ON(gl, mapping && mapping->nrpages && !gfs2_withdrawn(sdp));
+	if (mapping) {
+		truncate_inode_pages_final(mapping);
+		if (!gfs2_withdrawn(sdp))
+			GLOCK_BUG_ON(gl, mapping->nrpages ||
+				     mapping->nrexceptional);
+	}
 	trace_gfs2_glock_put(gl);
 	sdp->sd_lockstruct.ls_ops->lm_put_lock(gl);
 }
-- 
2.25.1

