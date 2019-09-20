Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F8DB927E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389596AbfITOcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:32:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36440 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388266AbfITOZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqN-0004xy-7v; Fri, 20 Sep 2019 15:25:07 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0007wz-MZ; Fri, 20 Sep 2019 15:25:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bob Peterson" <rpeterso@redhat.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.156942783@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 102/132] GFS2: Fix rgrp end rounding problem for
 bsize < page size
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Peterson <rpeterso@redhat.com>

commit 31dddd9eb9ebae9a2a9b502750e9e481d752180a upstream.

This patch fixes a bug introduced by commit 7005c3e. That patch
tries to map a vm range for resource groups, but the calculation
breaks down when the block size is less than the page size.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/gfs2/rgrp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -926,8 +926,9 @@ static int read_rindex_entry(struct gfs2
 		goto fail;
 
 	rgd->rd_gl->gl_object = rgd;
-	rgd->rd_gl->gl_vm.start = rgd->rd_addr * bsize;
-	rgd->rd_gl->gl_vm.end = rgd->rd_gl->gl_vm.start + (rgd->rd_length * bsize) - 1;
+	rgd->rd_gl->gl_vm.start = (rgd->rd_addr * bsize) & PAGE_CACHE_MASK;
+	rgd->rd_gl->gl_vm.end = PAGE_CACHE_ALIGN((rgd->rd_addr +
+						  rgd->rd_length) * bsize) - 1;
 	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
 	if (rgd->rd_data > sdp->sd_max_rg_data)

