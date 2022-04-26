Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348D150F3EF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbiDZI3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344692AbiDZI2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:28:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A123135B19;
        Tue, 26 Apr 2022 01:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA1F8617F1;
        Tue, 26 Apr 2022 08:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CD2C385A0;
        Tue, 26 Apr 2022 08:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961456;
        bh=IZI1pv8Ex4cfr00pOxZe1myvfnxTKl2H2WTiS4ekVeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bL3ij8jUPa3PMEix5AcEq6F4kCBfwV9mI5DfBVcLhXR99Oq64qLwnutlKkLX16pxF
         fn7OcWafOdNzEGBBQz6OpzySWe3lgxPSftG5OBE1b+XUVYQbdaNpprGK3RC0vq1CoJ
         QYOms8PdH+z/UQULbiVwsJ241vq5LnCEnmEgBwa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/43] cifs: Check the IOCB_DIRECT flag, not O_DIRECT
Date:   Tue, 26 Apr 2022 10:20:59 +0200
Message-Id: <20220426081735.026599886@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



