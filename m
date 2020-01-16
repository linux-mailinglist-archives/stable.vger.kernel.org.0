Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0198713F777
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbgAPTLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:11:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:42846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387668AbgAPRAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7A0E7B2EDC;
        Thu, 16 Jan 2020 17:00:07 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] xen/balloon: Support xend-based toolstack take two
Date:   Thu, 16 Jan 2020 18:00:04 +0100
Message-Id: <20200116170004.14373-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 3aa6c19d2f38be ("xen/balloon: Support xend-based toolstack")
tried to fix a regression with running on rather ancient Xen versions.
Unfortunately the fix was based on the assumption that xend would
just use another Xenstore node, but in reality only some downstream
versions of xend are doing that. The upstream xend does not write
that Xenstore node at all, so the problem must be fixed in another
way.

The easiest way to achieve that is to fall back to the behavior before
commit 5266b8e4445c ("xen: fix booting ballooned down hvm guest")
in case the static memory maximum can't be read.

Fixes: 3aa6c19d2f38be ("xen/balloon: Support xend-based toolstack")
Signed-off-by: Juergen Gross <jgross@suse.com>
Cc: <stable@vger.kernel.org> # 4.13
---
 drivers/xen/xen-balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
index 6d12fc368210..a8d24433c8e9 100644
--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -94,7 +94,7 @@ static void watch_target(struct xenbus_watch *watch,
 				  "%llu", &static_max) == 1))
 			static_max >>= PAGE_SHIFT - 10;
 		else
-			static_max = new_target;
+			static_max = balloon_stats.current_pages;
 
 		target_diff = (xen_pv_domain() || xen_initial_domain()) ? 0
 				: static_max - balloon_stats.target_pages;
-- 
2.16.4

