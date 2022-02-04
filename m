Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13014A92BA
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 04:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349352AbiBDDVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 22:21:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53456 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344597AbiBDDVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 22:21:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5F6E61AD5;
        Fri,  4 Feb 2022 03:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE639C340E8;
        Fri,  4 Feb 2022 03:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944881;
        bh=YSy+6ZH0WVfzwdmOiqKVVldecAPykJSaMLEQU6gfzTI=;
        h=From:To:Cc:Subject:Date:From;
        b=WSBc/ACdZhUSpNF2CEeZwHRZRcxLpirVZ6rt1zbfxtdU7DK6+TrGhceD2D9K7qd2z
         i7spPLc7X3Y1Netr6qZr9B2ZdTBU4ICDym4R600zyfCCfeB5CTYX5it7Y46Pg9a9os
         9twjG0AxeIr+QjZ5qORwSno6u8QeDYdZfyiywdvCC0qSEofGXSUlCSluwPPG27w5WJ
         vww65i+oQYLogba3sJfXkeptQ+hbtrlJIaUr3BniwaBmwk2BEwaodVmV5/SHWmyWE1
         eChdu7vU+CWjaKwrj/O3s4k8RV5H3rRdAdvN3/0NHhYwk0QBg8wNwyebEAUPLUD3YQ
         LI2Dp0ETSUfhA==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>
Subject: [PATCH v2] f2fs: fix to unlock page correctly in error path of is_alive()
Date:   Fri,  4 Feb 2022 11:21:14 +0800
Message-Id: <20220204032114.43720-1-chao@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As Pavel Machek reported in below link [1]:

After commit 77900c45ee5c ("f2fs: fix to do sanity check in is_alive()"),
node page should be unlock via calling f2fs_put_page() in the error path
of is_alive(), otherwise, f2fs may hang when it tries to lock the node
page, fix it.

[1] https://lore.kernel.org/stable/20220124203637.GA19321@duo.ucw.cz/

Fixes: 77900c45ee5c ("f2fs: fix to do sanity check in is_alive()")
Cc: <stable@vger.kernel.org>
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Chao Yu <chao@kernel.org>
---
v2:
- Cc stable-kernel mailing list.
 fs/f2fs/gc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 0a6b0a8ae97e..2d53ef121e76 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1038,8 +1038,10 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
 
-	if (f2fs_check_nid_range(sbi, dni->ino))
+	if (f2fs_check_nid_range(sbi, dni->ino)) {
+		f2fs_put_page(node_page, 1);
 		return false;
+	}
 
 	*nofs = ofs_of_node(node_page);
 	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);
-- 
2.32.0

