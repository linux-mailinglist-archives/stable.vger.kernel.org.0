Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D833540769
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348138AbiFGRrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348646AbiFGRpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789F8132A01;
        Tue,  7 Jun 2022 10:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00D4561480;
        Tue,  7 Jun 2022 17:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1A8C385A5;
        Tue,  7 Jun 2022 17:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623338;
        bh=kkLcL0lXyNtpQEf5iq89zh3G3KGZ6xoM63TcfS0HYPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBlHtSGcPic5qwxRZnQV8tGFmyZ+XFkc6rPrTSf6LmkFGaW2uNf9N/k3e708g1E4c
         EJaKUlouggzYZZmNfh4ozbDuM3cTRt8S9lGZTasOVnSHIFB9nrg5GUQkR8o0q1Jyx7
         tVRA/5uK6prVkAtiQto5YrgcNi4uIfhCSF0gDv4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/452] NFS: Dont report errors from nfs_pageio_complete() more than once
Date:   Tue,  7 Jun 2022 19:03:08 +0200
Message-Id: <20220607164918.423002293@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c5e483b77cc2edb318da152abe07e33006b975fd ]

Since errors from nfs_pageio_complete() are already being reported
through nfs_async_write_error(), we should not be returning them to the
callers of do_writepages() as well. They will end up being reported
through the generic mechanism instead.

Fixes: 6fbda89b257f ("NFS: Replace custom error reporting mechanism with generic one")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index b08323ed0c25..dc08a0c02f09 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -675,11 +675,7 @@ static int nfs_writepage_locked(struct page *page,
 	err = nfs_do_writepage(page, wbc, &pgio);
 	pgio.pg_error = 0;
 	nfs_pageio_complete(&pgio);
-	if (err < 0)
-		return err;
-	if (nfs_error_is_fatal(pgio.pg_error))
-		return pgio.pg_error;
-	return 0;
+	return err;
 }
 
 int nfs_writepage(struct page *page, struct writeback_control *wbc)
@@ -730,9 +726,6 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 
 	if (err < 0)
 		goto out_err;
-	err = pgio.pg_error;
-	if (nfs_error_is_fatal(err))
-		goto out_err;
 	return 0;
 out_err:
 	return err;
-- 
2.35.1



