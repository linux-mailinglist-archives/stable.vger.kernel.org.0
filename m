Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4A02D62D2
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 18:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389270AbgLJQ7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390998AbgLJOgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e3f23ce40269a4c9053a@syzkaller.appspotmail.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.4 44/54] gfs2: check for empty rgrp tree in gfs2_ri_update
Date:   Thu, 10 Dec 2020 15:27:21 +0100
Message-Id: <20201210142604.198802898@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit 778721510e84209f78e31e2ccb296ae36d623f5e upstream.

If gfs2 tries to mount a (corrupt) file system that has no resource
groups it still tries to set preferences on the first one, which causes
a kernel null pointer dereference. This patch adds a check to function
gfs2_ri_update so this condition is detected and reported back as an
error.

Reported-by: syzbot+e3f23ce40269a4c9053a@syzkaller.appspotmail.com
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/rgrp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1008,6 +1008,10 @@ static int gfs2_ri_update(struct gfs2_in
 	if (error < 0)
 		return error;
 
+	if (RB_EMPTY_ROOT(&sdp->sd_rindex_tree)) {
+		fs_err(sdp, "no resource groups found in the file system.\n");
+		return -ENOENT;
+	}
 	set_rgrp_preferences(sdp);
 
 	sdp->sd_rindex_uptodate = 1;


