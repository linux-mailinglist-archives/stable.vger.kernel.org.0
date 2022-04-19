Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A9A5078C0
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356700AbiDSSTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356478AbiDSSR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:17:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945E63ED18;
        Tue, 19 Apr 2022 11:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31C3C60C83;
        Tue, 19 Apr 2022 18:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C179C385A5;
        Tue, 19 Apr 2022 18:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391988;
        bh=OBQXKav6Q/ArZ9XuPqIV2/9aEfF5d1dECO1BUBWbfe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBVnwHo1We4USymmgUUMGx7+FvKVSOpuTRxKg5qCovjDoBP54hDituqg+255J4Cz2
         QQjys/0MpO+Cwyy7A2xvbXUEjQdtgCcmi8FMjM6LgKgzKF9jz7v4wdSCx3IaQAxOxe
         iUAVm+iDoA91iKdLM910HbUilhVJjWJsnSCkdRKVrZWKhMP60jsntoGkIoiHT8ObIv
         HOdgnxIDNkWm0t/ZUySBGLByPQKIh1i7FfIdqJ/wKEISxABs8ncJ5n7cCFr0t6XqI4
         c2Wf1iirWG6m8LnWw4uH/B/Y3n47o4UuSviZDlpc51fyR52NdLynbnLCWtdkXeiN0t
         Jc3ZEla1Ye3rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 09/27] cifs: Check the IOCB_DIRECT flag, not O_DIRECT
Date:   Tue, 19 Apr 2022 14:12:24 -0400
Message-Id: <20220419181242.485308-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
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
index ed220daca3e1..93327ab040e5 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -934,7 +934,7 @@ cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t rc;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
-	if (iocb->ki_filp->f_flags & O_DIRECT)
+	if (iocb->ki_flags & IOCB_DIRECT)
 		return cifs_user_readv(iocb, iter);
 
 	rc = cifs_revalidate_mapping(inode);
-- 
2.35.1

