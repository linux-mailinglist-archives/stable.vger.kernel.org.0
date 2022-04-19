Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5F507856
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356984AbiDSSZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357437AbiDSSXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:23:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE1B43ED0;
        Tue, 19 Apr 2022 11:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25C376142D;
        Tue, 19 Apr 2022 18:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DEFC385A5;
        Tue, 19 Apr 2022 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392169;
        bh=IZI1pv8Ex4cfr00pOxZe1myvfnxTKl2H2WTiS4ekVeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbyaPltLzw+2c4SbPpKMYkw7XjPXSZXNCZ4N7pBT2fpsFi9y6RoOHSyrQ1dFqwJ59
         LeQB0NQqMxtQa4PwfJddvs3euRAsu5CZl3gVxvbFrdrMa/G/zEWXa+NgQr6O8tqK05
         a0geGcvfjvzxSL1CQsf3pYQ+3o8qh9aYnovOE2d2ApQ8VH181GJxYbKM/GVxC2AOyb
         6bDSO5QZcKbn4cM5Rf4tikoRAMRcSIIXRpAYaD/2xf0Ep7HPsG/iOZEYHgNMZyFvxC
         QNGLVvL2w29Refb21pqIEhxw4X05PsXD0XsKJzFBbt9Efh6OsjDGxsL/VQctmTI9US
         foWwt4STxc0RA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 5/9] cifs: Check the IOCB_DIRECT flag, not O_DIRECT
Date:   Tue, 19 Apr 2022 14:15:53 -0400
Message-Id: <20220419181557.486336-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181557.486336-1-sashal@kernel.org>
References: <20220419181557.486336-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 994fd530a512597ffcd713b0f6d5bc916c5698f0 ]

Use the IOCB_DIRECT indicator flag on the I/O context rather than checking to
see if the file was opened O_DIRECT.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index dba0d12c3db1..1d3f98572068 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -773,7 +773,7 @@ cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t rc;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
-	if (iocb->ki_filp->f_flags & O_DIRECT)
+	if (iocb->ki_flags & IOCB_DIRECT)
 		return cifs_user_readv(iocb, iter);
 
 	rc = cifs_revalidate_mapping(inode);
-- 
2.35.1

