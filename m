Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263D359FD3D
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbiHXO1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 10:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiHXO1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 10:27:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE794D4D9;
        Wed, 24 Aug 2022 07:27:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8A88F20447;
        Wed, 24 Aug 2022 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661351252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Yi2ZNad6kgMz/6PldXnNjKbyPX0uHyJxaAqhAA//dfo=;
        b=FUHgHgR1V9zX7w8l+rS/yI6QH5Cqpo1omm+unoLQLUz1Agf/U8G0GH+Rst0xcKAH7lzsjk
        WW2yUOBSNUBidc8jsqDa2505hNaY1Y3VQdrrVrKa3yfUZ9TqhJkdRLZZWorEiDi7CjwLT/
        /fUsx7qp6AbarPHI8pxMGwt7b3Yzc/U=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 45DB313AC0;
        Wed, 24 Aug 2022 14:27:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HPKUD1Q1BmN+BgAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 24 Aug 2022 14:27:32 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>
Subject: [PATCH] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Date:   Wed, 24 Aug 2022 16:26:34 +0200
Message-Id: <20220824142634.20966-1-jgross@suse.com>
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

Fix that by calling unlock_pages only if lock_pages() was at least
partially successful.

Cc: <stable@vger.kernel.org>
Fixes: ab520be8cd5d ("xen/privcmd: Add IOCTL_PRIVCMD_DM_OP")
Reported-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/privcmd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 3369734108af..ec87968b4459 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -679,7 +679,7 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
 	rc = lock_pages(kbufs, kdata.num, pages, nr_pages, &pinned);
 	if (rc < 0) {
 		nr_pages = pinned;
-		goto out;
+		goto unlock;
 	}
 
 	for (i = 0; i < kdata.num; i++) {
@@ -691,8 +691,9 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
 	rc = HYPERVISOR_dm_op(kdata.dom, kdata.num, xbufs);
 	xen_preemptible_hcall_end();
 
-out:
+ unlock:
 	unlock_pages(pages, nr_pages);
+ out:
 	kfree(xbufs);
 	kfree(pages);
 	kfree(kbufs);
-- 
2.35.3

