Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64AE5A0C83
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiHYJ0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbiHYJ0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:26:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8960961730;
        Thu, 25 Aug 2022 02:26:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4081E5BCEF;
        Thu, 25 Aug 2022 09:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661419563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BYfTZFURvyLCFYVU3ltFgIRHLc50Lkg36j+xzInhtWI=;
        b=qrtmchGnpdx4Li2CexVjMJHXy+6yN4kZSUZagt6K/wEDzX6fbtPxLO/TYsa0ADZmPk6Dkt
        K0+ZYizhPYlyPeCuLO6HdEAkq3cpYHG7QUUP+BVo8f0nR91Gcn3E9LNVZPgqPttUFJTOUk
        uepJ+vC6hOLcHab0OG+L32V3qNARRgs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 059DC13517;
        Thu, 25 Aug 2022 09:26:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id luA+OypAB2M1RgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 25 Aug 2022 09:26:02 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>
Subject: [PATCH v2] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Date:   Thu, 25 Aug 2022 11:26:00 +0200
Message-Id: <20220825092600.7188-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The error exit of privcmd_ioctl_dm_op() is calling unlock_pages()
potentially with pages being NULL, leading to a NULL dereference.

Additionally lock_pages() doesn't check for pin_user_pages_fast()
having been completely successful, resulting in potentially not
locking all pages into memory. This could result in sporadic failures
when using the related memory in user mode.

Fix all of that by calling unlock_pages() always with the real number
of pinned pages, which will be zero in case pages being NULL, and by
checking the number of patches pinned by pin_user_pages_fast()
matching the expected number of pages.

Cc: <stable@vger.kernel.org>
Fixes: ab520be8cd5d ("xen/privcmd: Add IOCTL_PRIVCMD_DM_OP")
Reported-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- use "pinned" as parameter for unlock_pages() (Jan Beulich)
- drop label "unlock" again (Jan Beulich)
- add check for complete success of pin_user_pages_fast()
---
 drivers/xen/privcmd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 3369734108af..7dc62510635e 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -602,6 +602,10 @@ static int lock_pages(
 		*pinned += page_count;
 		nr_pages -= page_count;
 		pages += page_count;
+
+		/* Exact reason isn't known, EFAULT is one possibility. */
+		if (page_count < requested)
+			return -EFAULT;
 	}
 
 	return 0;
@@ -677,10 +681,8 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
 	}
 
 	rc = lock_pages(kbufs, kdata.num, pages, nr_pages, &pinned);
-	if (rc < 0) {
-		nr_pages = pinned;
+	if (rc < 0)
 		goto out;
-	}
 
 	for (i = 0; i < kdata.num; i++) {
 		set_xen_guest_handle(xbufs[i].h, kbufs[i].uptr);
@@ -692,7 +694,7 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
 	xen_preemptible_hcall_end();
 
 out:
-	unlock_pages(pages, nr_pages);
+	unlock_pages(pages, pinned);
 	kfree(xbufs);
 	kfree(pages);
 	kfree(kbufs);
-- 
2.35.3

