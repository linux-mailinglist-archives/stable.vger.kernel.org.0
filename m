Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C883341A7AF
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhI1F6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239029AbhI1F6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7095761262;
        Tue, 28 Sep 2021 05:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808591;
        bh=/vMdnTGIRNxo4mGYHll6b4s9a8WgufEfVbRp/DlK4b8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9EwQalNw0xG35eHzPyfGcQEJ3wCFvuNTOXo9MfXW8jiLehmG/WKcj52dkulktQpL
         1dl5PgCBvzxVzlOhaHsKGRsjEjMuYKqa5J89bfT4VdlUBswhJFSiHFuSDgUZABgK2/
         ImKldDTbfR54KLzEnTYkgc4SCeTLFQfD7DpT5vMGm4dqjCeHzqJpKa1f/PtSa9FewL
         c805GDmDAzWGWyMSF5k/Tq3ABdd20hwbJ2DP0VHpuc4lIRw///8TrjfhhZKBlx7pSV
         avKKm1x8MFGF9R7trm+qs4P6GRA8dCM2kozPqUBVSUEpLJcCMQjkicgnpn2pCVTP34
         3zPIGvtZ390nQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.14 28/40] Xen/gntdev: don't ignore kernel unmapping error
Date:   Tue, 28 Sep 2021 01:55:12 -0400
Message-Id: <20210928055524.172051-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit f28347cc66395e96712f5c2db0a302ee75bafce6 ]

While working on XSA-361 and its follow-ups, I failed to spot another
place where the kernel mapping part of an operation was not treated the
same as the user space part. Detect and propagate errors and add a 2nd
pr_debug().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/c2513395-74dc-aea3-9192-fd265aa44e35@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index a3e7be96527d..23fd09a9bbaf 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,6 +396,14 @@ static int __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
+		if (use_ptemod) {
+			if (map->kunmap_ops[offset+i].status)
+				err = -EINVAL;
+			pr_debug("kunmap handle=%u st=%d\n",
+				 map->kunmap_ops[offset+i].handle,
+				 map->kunmap_ops[offset+i].status);
+			map->kunmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
+		}
 	}
 	return err;
 }
-- 
2.33.0

