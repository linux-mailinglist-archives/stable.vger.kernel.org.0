Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099A6549513
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352822AbiFMLUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353311AbiFMLTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:19:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9F93AA41;
        Mon, 13 Jun 2022 03:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D3D7B80EA3;
        Mon, 13 Jun 2022 10:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BEEC341C5;
        Mon, 13 Jun 2022 10:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116868;
        bh=wn3zsxvkrWjSsp5j38FYdXumpvm2wgMG6oLUd2rNGVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWUQ+icRFYxZOu2UQiV8COvf8KVXbXpxWnw5f72bOXe9HDV8uxipznI4KzkFpaKtf
         1pvs24XjacApOIGv+XUj1aQvw0phhbDysNuQPw4olNuAFHCdKuhuEyrtMr6oNfWeAy
         FuPP5qMf/p5WNdh9uH/OiXmwiLhw3wsnS+7uw6bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/411] NFS: Dont report errors from nfs_pageio_complete() more than once
Date:   Mon, 13 Jun 2022 12:07:55 +0200
Message-Id: <20220613094934.716948139@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index ecdd79a55840..10ce264a6456 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -692,11 +692,7 @@ static int nfs_writepage_locked(struct page *page,
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
@@ -747,9 +743,6 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 
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



